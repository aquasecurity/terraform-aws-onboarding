
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
    role_arn = event.get('RoleArn')
    account_id = event.get('AccountId')
    external_id = event.get('ExternalId')
    group = int(event.get('GroupId'))
    aws_account_id = context.invoked_function_arn.split(":")[4]

    try:
        print('creating a new cspm key')
        is_already_cspm_client = create_cspm_key(
            cspm_url, ac_url, aqua_api_key, aqua_secret,
            role_arn, external_id, group, account_id, aws_account_id
        )
        return {"IsAlreadyCSPMClient": is_already_cspm_client}

    except Exception as e:
        print(f"error: {e}")
        return {"error": e}


def get_signature(aqua_secret, tstmp, path, method, body):
    enc = tstmp + method + path + body
    print(f'enc: {enc}')
    enc_b = bytes(enc, 'utf-8')
    secret = bytes(aqua_secret, 'utf-8')
    sig = hmac.new(secret, enc_b, hashlib.sha256).hexdigest()
    return sig

def http_request(url, headers, method, body=None):
    http = urllib3.PoolManager(cert_reqs='CERT_NONE')

    try:
        response = http.request(method, url, body=body, headers=headers)
        data = json.loads(response.data.decode('utf-8'))
    except Exception as e:
        print(f'could not parse event data; {e}')
        data = {}
    return data

def create_cspm_key(cspm_url, ac_url, aqua_api_key, aqua_secret, role_arn, external_id, group, account_id, aws_account_id):
    body = {
        "name": account_id,
        "cloud": "aws",
        "autoconnect": True,
        "role_arn": role_arn,
        "external_id": external_id,
        "group_id": group
    }

    print(f'body: {body}')
    tstmp = str(int(time.time() * 1000))
    jsonbody = json.dumps(body, separators=(',', ':'))
    sig = get_signature(aqua_secret, tstmp, "/v2/keys", "POST", jsonbody)
    headers = {
        "X-API-Key": aqua_api_key,
        "X-Signature": sig,
        "X-Timestamp": tstmp
    }

    response = http_request(cspm_url + '/v2/keys', headers, "POST", jsonbody)
    print(f'response: {response}')
    if response.get('status', 0) != 200 and response.get('status', 0) != 201:
        raise Exception(response.get('message', "Internal server error"))

    is_already_cspm_client = False
    if response.get('status', 0) == 200:
        is_already_cspm_client = True

    return is_already_cspm_client