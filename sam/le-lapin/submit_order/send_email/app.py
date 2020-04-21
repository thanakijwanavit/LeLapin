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
    SENDER = "le lapin <nicxxx1@gmail.com>"
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

def customer_email(user, cart):
    price = cart['total']
    subject = 'order received'

    body = '''
    <html>
    <head></head>
    <body>
    <h1>Congratulation you have received an order</h1>
    <p>your order total is{price} \n including {number_of_items}</p>
    <p>sending to your address {address}</p>
    <p>please do not hesitate to contact us</p>
    </body>
    </html>
    '''.format(
               address = address,
               number_of_items = len(cart['orders']),
               price = price)
    header = 'thanks for ordering'
    send_email(user['address'], header ,body ,subject)

def order_email(user, cart):
    subject = 'order received'
    address = 'nwanavit@gmail.com'
    body = '''
    <html>
    <head></head>
    <body>
    <h1>Thanks for ordereing from le lapin market!</h1>
    <p>your order is {price}</p>
    <p>delivery address is{address}</p>
    <p>google link for address is{mapLink}</p>
    <p>customer has ordered{number_of_items}</p>
    <p> any problem feel free to email me at </p>
    </body>
    </html>
    '''.format(address = user['address'],
               price = cart['total'],
               number_of_items = len(cart['orders']),
               mapLink = user['mapLink']
               )

    header = 'thanks for ordering'

    send_email(address, header ,body , subject )




def lambda_handler(event, context):
    user = event['user']
    _cart = event['cart']
    customer_email(user,_cart)
    order_email(user,_cart)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "email sent",
            "received_object" : event
        }),
    }
