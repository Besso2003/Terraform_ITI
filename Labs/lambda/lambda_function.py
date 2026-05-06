import boto3

ses = boto3.client('ses')

def lambda_handler(event, context):

    ses.send_email(
        Source='bassantalikamal@gmail.com',
        Destination={
            'ToAddresses': ['bassantalikamal@gmail.com']
        },
        Message={
            'Subject': {'Data': 'Terraform State Changed'},
            'Body': {'Text': {'Data': 'Terraform state file was updated!'}}
        }
    )