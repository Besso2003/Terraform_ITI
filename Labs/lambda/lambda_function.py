import boto3

ses = boto3.client('ses')

def lambda_handler(event, context):

    print(event)

    ses.send_email(
        Source='bassantalikamal@gmail.com',
        Destination={
            'ToAddresses': ['bassantalikamal@gmail.com']
        },
        Message={
            'Subject': {'Data': 'Terraform State Updated'},
            'Body': {
                'Text': {'Data': 'Your Terraform state file was modified in S3!'}
            }
        }
    )