import json
import os
import boto3
from botocore.exceptions import ClientError
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication


user = 'AKIAUBKOMPFACIF5W3WG'
password= 'w1KoRLIiyBjixlqLma0UkSQ5VzPmNN7yCksvX/GR'

def send_email(_address, _header ,_body ,_subject):
    SENDER = "le lapin <lelapindining@gmail.com>"
    RECIPIENT = _address
    CONFIGURATION_SET = "LeLapinOrder"
    AWS_REGION = "us-east-1"
    SUBJECT = _subject

    BODY_TEXT = "Here is your confirmed order number 12345"
    # The HTML body of the email.
    BODY_HTML = _body

    CHARSET = "utf-8"

    # Create a new SES resource and specify a region.
    client = boto3.client('ses',aws_access_key_id = user,
        aws_secret_access_key = password , region_name=AWS_REGION)

    # Create a multipart/mixed parent container.
    msg = MIMEMultipart('mixed')
    # Add subject, from and to lines.
    msg['Subject'] = SUBJECT
    msg['From'] = SENDER
    msg['To'] = RECIPIENT

    msg_body = MIMEMultipart('alternative')

    textpart = MIMEText(BODY_TEXT.encode(CHARSET), 'plain', CHARSET)
    htmlpart = MIMEText(BODY_HTML.encode(CHARSET), 'html', CHARSET)

    msg_body.attach(textpart)
    msg_body.attach(htmlpart)

    msg.attach(msg_body)

    try:
        #Provide the contents of the email.
        response = client.send_raw_email(
            Source=SENDER,
            Destinations=[
                RECIPIENT
            ],
            RawMessage={
                'Data':msg.as_string(),
            },
            ConfigurationSetName=CONFIGURATION_SET
        )
    # Display an error if something goes wrong.
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        print("Email sent! Message ID:"),
        print(response['MessageId'])


def lambda_handler(event, context):
    _address = event['address']
    _header = event['header']
    _body = event['body']
    _subject = event['subject']
    send_email(_address, _header ,_body ,_subject)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "email sent",
            "received_object" : event
        }),
    }
