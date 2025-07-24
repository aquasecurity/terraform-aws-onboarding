import time
import json
import sys
import hmac
import hashlib
import http.client
import ssl

query = json.loads(sys.stdin.read())
ac_url = query.get('autoconnect_url')
cspm_url = query.get('cspm_url')
aqua_api_key = query.get('api_key')
aqua_secret = query.get('api_secret')
cspm_role_arn = query.get('cspm_role_arn')
cspm_external_id = query.get('cspm_external_id')
session_id = query.get('session_id')
vol_scan_role_arn = query.get('volume_scanning_role_arn')
vol_scan_external_id = query.get('volume_scanning_external_id')
cloud = "aws"
region = query.get('region')
additional_resource_tags = query.get('additional_tags')
aws_account_id = query.get('aws_account_id')
volume_scanning_deployment = query.get('volume_scanning_deployment')
tstmp = str(int(time.time() * 1000))
base_cspm = query.get('base_cspm', 'false').lower() == 'true'
custom_regions = query.get('custom_cspm_regions')
cspm_group_id = int(query.get('cspm_group_id'))


def get_signature(aqua_secret, tstmp, path, method, body=''):
    """Generate HMAC signature for API authentication"""

    enc = tstmp + method + path + body
    enc_b = bytes(enc, 'utf-8')
    secret = bytes(aqua_secret, 'utf-8')
    sig = hmac.new(secret, enc_b, hashlib.sha256).hexdigest()
    return sig


def http_request(url, headers, method, body=None):
    """Send an HTTP request"""

    if body is None:
        body = ''

    if url.startswith("https://"):
        hostname = url.split("//")[1].split("/")[0]
        path = "/" + "/".join(url.split("//")[1].split("/")[1:])
    else:
        raise ValueError("Unsupported URL format")

    try:
        conn = http.client.HTTPSConnection(hostname, context=ssl._create_unverified_context())
        conn.request(method, path, body=body, headers=headers)

        response = conn.getresponse()
        response_data = response.read().decode("utf-8")

        conn.close()

        return {
            "status": response.status,
            "reason": response.reason,
            "data": response_data
        }
    except Exception as e:
        print(f"Failed to send HTTP request: {e}")
        return None


def get_cspm_key_id(aqua_api_key, aqua_secret, cspm_url, role_arn):
    """Fetch the CSPM key ID for the given IAM role ARN"""

    sig = get_signature(aqua_secret, tstmp, "/v2/keys", "GET", '')
    headers = {
        "X-API-Key": aqua_api_key,
        "X-Signature": sig,
        "X-Timestamp": tstmp
    }

    response = http_request(cspm_url + "/v2/keys", headers, "GET")

    if response is None:
        raise ValueError(f"HTTP request failed while getting CSPM key ID for {role_arn}")

    if response["status"] not in [200, 201]:
        raise ValueError(f"Failed to get CSPM key ID: {response['data']}")

    json_object = json.loads(response["data"])
    for key in json_object['data']:
        if key['role_arn'] == role_arn:
            return key['id']

    raise Exception("Key not found")


def trigger_discovery():
    """Perform cloud discovery and onboarding"""

    body = json.dumps({
        "cloud": cloud,
        "configuration_id": session_id,
        "deployment_method": "Terraform",
        "additional_resource_tags": additional_resource_tags,
        "volume_scanning_deployment": volume_scanning_deployment,
        "base_cspm": base_cspm,
        "cspm_group_id": cspm_group_id,
        "enabled_regions": custom_regions,
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

    sig = get_signature(aqua_secret, tstmp, "/v2/internal_apikeys", "GET", '')
    body_cspm = (
        '{"autoconnect":true,"base_cspm":' + str(base_cspm).lower() + ',"cloud":"aws","external_id":"' + cspm_external_id + '","group_id":' + str(int(cspm_group_id)) + ',"name":"' + aws_account_id + '","role_arn":"' + cspm_role_arn + '"}'
    )

    if custom_regions != "":
        body_cspm = (
            '{"autoconnect":true,"base_cspm":' + str(base_cspm).lower() + ',"cloud":"aws","enabled_regions":"' + custom_regions + '","external_id":"' + cspm_external_id + '","group_id":' + str(int(cspm_group_id)) + ',"name":"' + aws_account_id + '","role_arn":"' + cspm_role_arn + '"}'
        )

    cspm_sig = get_signature(aqua_secret, tstmp, "/v2/keys", "POST", body_cspm)
    headers = {
        "X-API-Key": aqua_api_key,
        "X-Authenticate-Api-Key-Signature": sig,
        "X-Register-New-Cspm-Signature": cspm_sig,
        "X-Timestamp": tstmp
    }

    response = http_request(url=f"{ac_url}/discover/{cloud}", headers=headers, method="POST", body=body)

    if response is None:
        raise ValueError("Discovery request failed")

    return response


def update_credentials():
    """Update credentials"""

    cspm_body = ('{"connection":{"aws":{"external_id":"' +
                 cspm_external_id + '","role_name":"' + cspm_role_arn.split('/')[1] + '"}}}')

    cspm_key_id = get_cspm_key_id(aqua_api_key, aqua_secret, cspm_url, cspm_role_arn)

    cspm_sig = get_signature(aqua_secret, tstmp, f"/v2/keys/{cspm_key_id}", "PUT", cspm_body)

    cspm_headers = {"X-API-Key": aqua_api_key, "X-Signature": cspm_sig, "X-Timestamp": tstmp}

    cspm_response = http_request(cspm_url + f"/v2/keys/{cspm_key_id}", cspm_headers, "PUT", cspm_body)

    ac_body = json.dumps({
        "cloud_account_id": aws_account_id,
        "credentials": {
            "cspm_role_arn": cspm_role_arn,
            "cspm_external_id": cspm_external_id,
            "volume_scanning_role_arn": vol_scan_role_arn,
            "volume_scanning_external_id": vol_scan_external_id,
        }
    })

    ac_sig = get_signature(aqua_secret, tstmp, "/v2/internal_apikeys", method="GET")

    ac_headers = {"X-API-Key": aqua_api_key, "X-Authenticate-Api-Key-Signature": ac_sig, "X-Timestamp": tstmp}

    ac_response = http_request(ac_url + f"/discover/update-credentials/{cloud}", ac_headers, "PUT", ac_body)

    if ac_response is None:
        raise ValueError("Update credentials request failed")

    return cspm_response


def main():
    try:
        discovery_response = trigger_discovery()
        discovery_data = json.loads(discovery_response.get("data", "{}"))
        if discovery_data.get("state") == "discover_in_progress":
            update_credentials_response = update_credentials()
            update_credentials_data = json.loads(update_credentials_response.get("data", "{}"))

            if update_credentials_response and update_credentials_response.get('status') == 200:
                onboarding_status = f"received response: discovery status {discovery_response.get('status', 'Unknown')}, body: {discovery_data}"
            else:
                onboarding_status = f"received response: update status {update_credentials_response.get('status', 'Unknown')}, body: {update_credentials_data}"
        else:
            onboarding_status = f"received response: discovery status {discovery_response.get('status', 'Unknown')}, body: {discovery_data}"

    except Exception as e:
        onboarding_status = f"received response: status Error, body: {str(e)}"

    output = {
        "status": onboarding_status
    }

    print(json.dumps(output))


if __name__ == "__main__":
    main()
