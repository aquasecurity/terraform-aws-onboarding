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

    http = urllib3.PoolManager(cert_reqs='CERT_NONE')

    try:
        response = http.request(method, url, body=body, headers=headers)
        return response
    except Exception as e:
        print('Failed to send http request; {}'.format(e))
        return None


def get_cspm_key_id(aqua_api_key, aqua_secret, cspm_url, role_arn):
    tstmp = str(int(time.time() * 1000))
    sig = get_signature(aqua_secret, tstmp, "/v2/keys", "GET", '')
    headers = {"X-API-Key": aqua_api_key, "X-Signature": sig, "X-Timestamp": tstmp}

    response = http_request(cspm_url + "/v2/keys", headers, "GET")
    json_object = json.loads(response.data)
    if response.status not in (200, 201):
        raise ValueError(f"Failed to get cspm key id for {role_arn}: {response.message}")

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

    response = http_request(cspm_url + '/v2/keys', headers, "POST", jsonbody)
    if response.status not in (200, 201):
        raise Exception("Failed to create cspm key id", response.data.decode("utf-8"))

    print(f'CSPM response: {response.data.decode("utf-8")}')
    is_already_cspm_client = False
    if response.status == 200:
        is_already_cspm_client = True

    return is_already_cspm_client
