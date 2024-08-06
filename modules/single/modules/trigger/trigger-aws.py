import time
import json
import sys
import hmac
import hashlib
import http.client
import ssl

timestamp = str(int(time.time() * 1000))

query = json.loads(sys.stdin.read())
ac_url = query.get('autoconnect_url')
aqua_api_key = query.get('api_key')
aqua_secret = query.get('api_secret')
cspm_role_arn = query.get('cspm_role_arn')
cspm_external_id = query.get('cspm_external_id')
is_already_cspm_client = query.get('is_already_cspm_client')
session_id = query.get('session_id')
vol_scan_role_arn = query.get('volume_scanning_role_arn')
vol_scan_external_id = query.get('volume_scanning_external_id')
cloud = "aws"
region = query.get('region')
additional_resource_tags = query.get('additional_tags')

def get_signature(aqua_secret, tstmp, path, method, body=''):
    enc = tstmp + method + path + body
    enc_b = bytes(enc, 'utf-8')
    secret = bytes(aqua_secret, 'utf-8')
    sig = hmac.new(secret, enc_b, hashlib.sha256).hexdigest()
    return sig

body = json.dumps({
      "cloud": cloud,
      "configuration_id": session_id,
      "is_already_cspm_client": is_already_cspm_client,
      "deployment_method": "Terraform",
      "additional_resource_tags": additional_resource_tags,
      "payload": {
          "cspm": {
              "role_arn": cspm_role_arn,
              "external_id": cspm_external_id
          },
          "volume_scanning": {
              "role_arn": vol_scan_role_arn,
              "external_id": vol_scan_external_id,
              "region": region
          }
      }
})

tstmp = str(int(time.time() * 1000))
sig = get_signature(aqua_secret, tstmp, "/v2/internal_apikeys", "GET", '')

headers = {
    "X-API-Key": aqua_api_key,
    "X-Authenticate-Api-Key-Signature": sig,
    "X-Timestamp": tstmp
}


conn = http.client.HTTPSConnection(ac_url.split("//")[1], context = ssl._create_unverified_context())
path = "/discover/aws"
method = "POST"

conn.request(method, path, body=body, headers=headers)
response = conn.getresponse()
onboarding_status = 'received response: status {}, body: {}'.format(response.status, response.read().decode("utf-8"))

conn.close()


output = {
    "status": onboarding_status
}

print(json.dumps(output))