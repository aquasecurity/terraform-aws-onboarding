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

    http = urllib3.PoolManager(cert_reqs='CERT_NONE')

    try:
        response = http.request(method, url, body=body, headers=headers)

        data = json.loads(response.data.decode('utf-8'))
    except Exception as e:
        print("warning: {}".format(e))
        data = {}

    return data


def generate_external_id(cspm_url, ac_url, aqua_api_key, aqua_secret, aws_account_id):
    u = cspm_url + '/v2/generatedids'
    print('api url: {}'.format(u))

    tstmp = str(int(time.time() * 1000))
    method = "POST"
    sig = get_signature(aqua_secret, tstmp, '/v2/generatedids', method, '')
    headers = {"X-API-Key": aqua_api_key, "X-Signature": sig, "X-Timestamp": tstmp}

    response = http_request(u, headers, method)
    if response.get('status', 0) != 200 and response.get('status', 0) != 201 or not response.get('data'):
        raise Exception("failed to generate external id; {}".format(response.get('message', 'Internal server error')))

    return response['data'][0]['generated_id']
