import json
import urllib3
import hashlib
import time
import hmac

def handler(event, context):
    cspm_url = event.get('ApiUrl')
    ac_url = event.get('AutoConnectApiUrl')
    aqua_api_key = event.get('AquaApiKey')
    aqua_secret = event.get('AquaSecretKey')
    aws_account_id = context.invoked_function_arn.split(":")[4]

    try:
        print('generating external id')
        external_id = generate_external_id(cspm_url, ac_url, aqua_api_key, aqua_secret, aws_account_id)
        print('generated external id: {}'.format(external_id))
        return {"ExternalId": external_id}
    except Exception as e:
        print('failed generating external id')
        print(f"error: {e}")
        raise e


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

    http = urllib3.PoolManager(cert_reqs='CERT_REQUIRED')

    try:
        response = http.request(method, url, body=body, headers=headers)
        response_data = response.data.decode('utf-8') if response.data else ''
        print(f"HTTP response: {response.status} {response.reason} - {response_data}")
        return response
    except Exception as e:
        print('Failed to send http request; {}'.format(e))
        return None


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

    response = http_request(tokens_url, headers, method, body)

    if response.status not in [200, 201]:
        raise Exception(f"Failed to get Bearer token: {response.data.decode('utf-8')}")

    json_object = json.loads(response.data.decode('utf-8'))
    if json_object.get('status') != 200:
        error_msg = json_object.get('message', 'Unknown error')
        raise Exception(f"Tokens API failed: {error_msg}")

    return json_object['data']


def cspm_request_with_fallback(cspm_base_url, path, headers, method, body, api_key, aqua_secret, tstmp):
    """Make CSPM request with automatic token authentication fallback"""
    url = cspm_base_url + path
    response = http_request(url, headers, method, body if body else '')

    if response is None:
        raise ValueError("HTTP request failed")

    # Attempt fallback for 401/403 errors
    if response.status in [401, 403]:
        print(f"Token fallback: API key authentication failed with status {response.status}, attempting Bearer token fallback")
        try:
            bearer_token = get_bearer_token(cspm_base_url, api_key, aqua_secret, tstmp)

            fallback_headers = {
                "Authorization": f"Bearer {bearer_token}",
                "X-Timestamp": tstmp,
                "Content-Type": "application/json"
            }

            response = http_request(url, fallback_headers, method, body if body else '')
            if response and response.status in [200, 201]:
                print("Token fallback: Bearer token authentication succeeded")
            elif response:
                print(f"Token fallback: Bearer token authentication failed with status {response.status}")
        except Exception as e:
            print(f"Token fallback failed: {e}")
            # Continue with original response if fallback fails

    # Parse response to match existing http_request behavior
    try:
        data = json.loads(response.data.decode('utf-8'))
    except Exception as e:
        print("warning: {}".format(e))
        data = {}

    return data


def generate_external_id(cspm_url, ac_url, aqua_api_key, aqua_secret, aws_account_id):
    path = '/v2/generatedids'
    print('api url: {}'.format(cspm_url + path))

    tstmp = str(int(time.time() * 1000))
    method = "POST"
    sig = get_signature(aqua_secret, tstmp, path, method, '')
    headers = {"X-API-Key": aqua_api_key, "X-Signature": sig, "X-Timestamp": tstmp}

    response = cspm_request_with_fallback(cspm_url, path, headers, method, '', aqua_api_key, aqua_secret, tstmp)
    if response.get('status', 0) != 200 and response.get('status', 0) != 201 or not response.get('data'):
        raise Exception("failed to generate external id; {}".format(response.get('message', 'Internal server error')))

    return response['data'][0]['generated_id']
