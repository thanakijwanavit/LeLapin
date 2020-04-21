import json
import os
import boto3
from datetime import datetime
from dateutil.relativedelta import relativedelta
from botocore.exceptions import ClientError
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication


user = 'AKIAUBKOMPFACIF5W3WG'
password= 'w1KoRLIiyBjixlqLma0UkSQ5VzPmNN7yCksvX/GR'
AWS_REGION = 'ap-southeast-1'

def send_email(_address, _header ,_body ,_subject):
    data = {
        "address" : _address,
        "header" : _header,
        "body" : _body,
        "subject" : _subject
    }

    lambdaClient = boto3.client(
        'lambda',
        aws_access_key_id = user,
        aws_secret_access_key = password ,
        region_name = AWS_REGION
    )

    response = lambdaClient.invoke(
        FunctionName = "arn:aws:lambda:ap-southeast-1:277726656832:function:le-lapin-order-SendEmailFunction-1P9RPFPXOG1NV",
        InvocationType='Event',
        Payload=json.dumps(data)
    )
    return response

def genTable(cart):
    print('submitting cart of', cart)
    data = {
        "cart" : cart
    }

    lambdaClient = boto3.client(
        'lambda',
        aws_access_key_id = user,
        aws_secret_access_key = password ,
        region_name = AWS_REGION
    )

    response = lambdaClient.invoke(
        FunctionName = "arn:aws:lambda:ap-southeast-1:277726656832:function:le-lapin-order-GenOrderTable-XBVEPZQTYHJH",
        InvocationType='RequestResponse',
        Payload=json.dumps(data)
    )
    print("response is",response)

    responseData = response['Payload'].read().decode('UTF-8')
    print("data is",responseData)
    body = json.loads(responseData)['body']
    print('body is:', body)
    table = json.loads(body)['table']
    return table

def customer_email(user, cart, purchaseOrderId, deliveryDate):
    price = cart['total']
    subject = 'order received (testing)'
    address = user['address']
    orderSummary = genTable(cart)

    body = '''
    <html>
    <head>We have received your order</head>
    <body>
    <h1>Thank you for your order</h1>
    <p>Dear {name}</p>
    <h2> order details</h2>
    <p>
    your order number {purchaseOrderId}<br/>
    total is {price} baht<br/>
    expected delivery date {deliveryDate}<br/>
    including {number_of_items} items<br/><br/>
    we will contact you shortly through provided phone number of {phoneNumber} and line id of {line_id}
    </p>
    <p>sending to your address {address}</p>
    <p>{mapLink}</p>
    <p>please do not hesitate to contact {contacts_email}</p>
    {orderSummary}
    </body>
    </html>
    '''.format(
               name = user['name'],
               contacts_email = 'lelapindining@gmail.com',
               phoneNumber = user.get('phoneNumber', 'missing phone number'),
               line_id = user.get('lineID', 'missing line id'),
               mapLink = user.get('mapLink', 'missing mapLink'),
               address = address,
               deliveryDate = deliveryDate,
               number_of_items = len(cart['orders']),
               purchaseOrderId = purchaseOrderId,
               orderSummary = orderSummary,
               price = price)
    header = 'thanks for ordering'
    send_email(user['email'], header ,body ,subject)



def lambda_handler(event, context):
    user = event['user']
    _cart = event['cart']
    purchaseOrderId = event['purchaseOrderId']
    rawDeliveryDate = event.get('deliveryDate')
    try:
        deliveryDateTime = datetime.fromtimestamp(float(rawDeliveryDate)) + relativedelta(years = 31, hours=7)
        deliveryDate = deliveryDateTime.strftime('%c')
    except:
        deliveryDate = "missing deliveryDate"
    customer_email(user,_cart, purchaseOrderId, deliveryDate)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "email sent",
            "received_object" : event
        }),
    }
