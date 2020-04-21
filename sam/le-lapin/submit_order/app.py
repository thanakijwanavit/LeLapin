import json
import os
import boto3
from botocore.exceptions import ClientError
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication


user = 'AKIAUBKOMPFACIF5W3WG'
password= 'w1KoRLIiyBjixlqLma0UkSQ5VzPmNN7yCksvX/GR'
AWS_REGION = 'ap-southeast-1'
CUSTOMER_EMAIL_FUNCTION = 'arn:aws:lambda:ap-southeast-1:277726656832:function:le-lapin-order-CustomerEmail-1R4HVL80MFDOX'
INTERNAL_EMAIL_FUNCTION = 'arn:aws:lambda:ap-southeast-1:277726656832:function:le-lapin-order-LapinEmail-8852MSJ3IVKB'

def send_email(data, functionName):

    lambdaClient = boto3.client(
        'lambda',
        aws_access_key_id = user,
        aws_secret_access_key = password ,
        region_name = AWS_REGION
    )

    response = lambdaClient.invoke(
        FunctionName = functionName,
        InvocationType='Event',
        Payload=json.dumps(data)
    )
    return response



def lambda_handler(event, context):

    # send mail to customer
    send_email(event, CUSTOMER_EMAIL_FUNCTION)
    # send mail to kitchen
    send_email(event, INTERNAL_EMAIL_FUNCTION)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "email sent",
            "received_object" : event
        }),
    }
