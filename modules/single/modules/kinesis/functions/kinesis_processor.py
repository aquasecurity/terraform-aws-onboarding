import base64
import json
import logging
import time
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

tagKey = "aqua-agentless-scanner"
tagValue = "true"

def handler(event, context) -> dict:
    output = []
    allowed = 0
    dropped = 0
    logging.info("main handler function")

    for record in event['records']:
        payload = base64.b64decode(record["data"])
        allowed_record = filter_record_payload(payload)

        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok' if allowed_record else 'Dropped',
            'data': record['data']
        }
        output.append(output_record)

        if allowed_record:
            allowed += 1
        else:
            dropped += 1

    logger.info(f"Successfully processed {len(event['records'])} records. Dropped {dropped}. Allowed {allowed}")
    return {'records': output}

def filter_record_payload(payload):
    sleep_seconds = 5
    num_of_retries = 3
    logging.info("filter record function")
    logging.info("Decoded payload: " + str(payload))

    decoded_payload = json.loads(payload)
    ec2_client = boto3.client('ec2', region_name=decoded_payload['region'])

    for i in range(num_of_retries):
        try:
            snapshot_arn_split = decoded_payload['resources'][0].split("/")
            snapshot_id = snapshot_arn_split[-1]
            logging.info(f"Getting snapshot description for snapshot id: {snapshot_id} in try {i}")
            snapshots_description = ec2_client.describe_snapshots(SnapshotIds=[snapshot_id])
        except Exception as e:
            logging.warning(f"Snapshots description failed. error: {e}")
            if i < num_of_retries - 1:
                time.sleep(sleep_seconds)
            sleep_seconds += 3
        else:
            break
    else:
        raise ValueError('Failed to describe snapshots')

    logging.info("Description of snapshot: " + str(snapshots_description))

    snapshot_description = snapshots_description['Snapshots'][0]
    logger.info(f"Snapshot Id: {snapshot_description['SnapshotId']} Volume Id: {snapshot_description['VolumeId']}")

    try:
        for i, tagPair in enumerate(snapshot_description['Tags']):
            logger.info(f"Verifying Tag Key: {tagPair['Key']} Value: {tagPair['Value']}")
            if tagPair['Key'] == tagKey and tagPair['Value'] == tagValue:
                logger.info("Snapshot has a tag that is matching with the desired Aqua tag")
                return True
            elif i == len(snapshot_description['Tags']) - 1:
                logger.info("None of the snapshot's tags is matching the desired tag")
                return False
    except KeyError:
        logger.info("There are no tags for this snapshot")
        return False
