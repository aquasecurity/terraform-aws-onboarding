import json
import urllib3
import hashlib
import time
import hmac

# This Lambda isn't used currently, but it is kept for future use.

def handler(event, context):
    cspm_url = event.get('ApiUrl')
    aqua_api_key = event.get('AquaApiKey')
    aqua_secret = event.get('AquaSecretKey')
    role_arn = event.get('RoleArn')
    account_id = event.get('AccountId')
    external_id = event.get('ExternalId')
    group = int(event.get('GroupId'))
    custom_regions = event.get('CustomCSPMRegions')
    aws_account_id = context.invoked_function_arn.split(":")[4]

    try:
        cspm_key_id = get_cspm_key_id(aqua_api_key, aqua_secret, cspm_url, role_arn)
        is_already_cspm_client = True
        print(f'Existing CSPM key found: {cspm_key_id}')
    except Exception as key_not_found:
        print(f'No existing key found')
        print('Creating new CSPM key')
        is_already_cspm_client = create_cspm_key(
            cspm_url, aqua_api_key, aqua_secret,
            role_arn, external_id, group, account_id, aws_account_id, custom_regions
        )

    return {"IsAlreadyCSPMClient": is_already_cspm_client}


def get_signature(aqua_secret, tstmp, path, method, body):
    enc = tstmp + method + path + body
    enc_b = bytes(enc, 'utf-8')
    secret = bytes(aqua_secret, 'utf-8')
    sig = hmac.new(secret, enc_b, hashlib.sha256).hexdigest()
    return sig


def http_request(url, headers, method, body=None):
    if body is None:
        body = {}

    print(f"HTTP request: {method} {url}")

    http = urllib3.PoolManager(cert_reqs='CERT_NONE')

    response = http.request(method, url, body=body, headers=headers)
    response_data = response.data.decode('utf-8') if response.data else ''

    # Don't log response body for /v2/tokens endpoint to avoid exposing bearer tokens
    if '/v2/tokens' in url and response.status == 200:
        print(f"HTTP response: {response.status} {response.reason}")
    else:
        print(f"HTTP response: {response.status} {response.reason} - {response_data}")
    return response.status, response_data


def get_bearer_token(cspm_base_url, api_key, aqua_secret, tstmp):
    """Obtain Bearer token from CSPM /v2/tokens endpoint"""
    path = "/v2/tokens"
    method = "POST"
    body = '{"validity":1,"allowed_endpoints":["ANY"]}'
    tokens_url = cspm_base_url + path

    print("Token fallback: Calling POST /v2/tokens to obtain Bearer token")

    tokens_sig = get_signature(aqua_secret, tstmp, path, method, body)
    headers = {
        "X-API-Key": api_key,
        "X-Signature": tokens_sig,
        "X-Timestamp": tstmp,
        "Content-Type": "application/json"
    }

    status, data = http_request(tokens_url, headers, method, body)
    if status not in [200, 201]:
        raise Exception(f"Failed to get Bearer token: {data}")

    json_object = json.loads(data)
    return json_object['data']


def cspm_request_with_fallback(cspm_base_url, path, headers, method, body, api_key, aqua_secret, tstmp):
    """Make CSPM request with automatic token authentication fallback"""
    url = cspm_base_url + path
    original_status, original_data = http_request(url, headers, method, body if body else '')

    # Attempt fallback for 401/403 errors
    if original_status in [401, 403]:
        print(f"Token fallback: API key authentication failed with status {original_status}, attempting Bearer token fallback")
        try:
            bearer_token = get_bearer_token(cspm_base_url, api_key, aqua_secret, tstmp)

            fallback_headers = {
                "Authorization": f"Bearer {bearer_token}",
                "X-Timestamp": tstmp,
                "Content-Type": "application/json"
            }

            fallback_status, fallback_data = http_request(url, fallback_headers, method, body if body else '')
            if fallback_status in [200, 201]:
                print("Token fallback: Bearer token authentication succeeded")
                return fallback_status, fallback_data
            else:
                print(f"Token fallback: Bearer token authentication failed with status {fallback_status}")
        except Exception as e:
            print(f"Token fallback failed: {e}")
            # Return original response if fallback fails

    return original_status, original_data


def get_cspm_key_id(aqua_api_key, aqua_secret, cspm_url, role_arn):
    tstmp = str(int(time.time() * 1000))
    sig = get_signature(aqua_secret, tstmp, "/v2/keys", "GET", '')
    headers = {"X-API-Key": aqua_api_key, "X-Signature": sig, "X-Timestamp": tstmp}

    status, data = cspm_request_with_fallback(cspm_url, "/v2/keys", headers, "GET", '', aqua_api_key, aqua_secret, tstmp)
    if status not in (200, 201):
        raise ValueError(f"Failed to get cspm key id for {role_arn}: {data}")

    json_object = json.loads(data)

    for key in json_object['data']:
        if key['role_arn'] == role_arn:
            return key['id']
    raise Exception("key not found")


def create_cspm_key(cspm_url, aqua_api_key, aqua_secret, role_arn, external_id, group, account_id, aws_account_id, custom_regions):
    body = {
        "name": account_id,
        "cloud": "aws",
        "autoconnect": True,
        "role_arn": role_arn,
        "external_id": external_id,
        "group_id": group
    }

    if custom_regions != "":
        body['enabled_regions'] = custom_regions

    print(f'CSPM body: {body}')
    tstmp = str(int(time.time() * 1000))
    jsonbody = json.dumps(body, separators=(',', ':'))
    sig = get_signature(aqua_secret, tstmp, "/v2/keys", "POST", jsonbody)
    headers = {
        "X-API-Key": aqua_api_key,
        "X-Signature": sig,
        "X-Timestamp": tstmp
    }

    status, data = cspm_request_with_fallback(cspm_url, '/v2/keys', headers, "POST", jsonbody, aqua_api_key, aqua_secret, tstmp)
    if status not in (200, 201):
        raise Exception("Failed to create cspm key id", data)

    print(f'CSPM response: {data}')
    is_already_cspm_client = False
    if status == 200:
        is_already_cspm_client = True

    return is_already_cspm_client
