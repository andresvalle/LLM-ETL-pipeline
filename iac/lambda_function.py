import json
import boto3
import os
from botocore.exceptions import ClientError
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMO_TABLE']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    input_string = event['node']['inputs'][0]['value'].replace("\n", "")
    cleaned_input = json.loads(input_string, parse_float=Decimal)

    for record in cleaned_input:
        
        item = {
            'transaction_id': record['transaction_id'],
            'timestamp': record['timestamp'],
            'cashier': record['cashier'],
            'total': record['total']
        }

        try:
            table.put_item(Item=item)
        except ClientError as e:
            return {
                'statusCode': 500,
                'body': json.dumps(f'Error writing to DynamoDB: {e.response["Error"]["Message"]}')
            }

    return {
        'statusCode': 200,
        'body': json.dumps('Records successfully written to DynamoDB.')
    }
