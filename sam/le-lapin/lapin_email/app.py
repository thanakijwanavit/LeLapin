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



def order_email(user, cart, purchaseOrderId, deliveryDate):
    subject = 'order received'
    email1 = 'nwanavit@gmail.com'
    email2 = 'lelapindining@gmail.com'
    body = '''
    <html>
    <head>Congratulation, the customer has placed an order</head>
    <body>
    <h1>Please process the order id: {orderID}</h1>
    <p>order total is {price}</p>
    <h2>customer details are</h2>
    <p>{customer_name} <br />
    email: {customer_email},<br />
    phoneNumber {customer_phone}, <br />
    line_id: {customer_line_id}, </p>
    <p>customer is expecting the delivery at {deliveryDate} </p>
    <p>delivery address is {address} </p>
    <p>google link for address is{mapLink}</p>
    <p>customer has ordered{number_of_items}</p>
    {orderSummary}
    <p> any problem feel free to email me at nwanavit@hatari.cc</p>
    </body>
    </html>
    '''.format(address = user.get('address','missing address'),
               mapLink = user.get('mapLink', 'missing map link'),
               customer_name = user.get('name', 'missing name'),
               customer_email = user.get('email', 'missing email'),
               customer_phone = user.get( 'phoneNumber', 'missing phone number'),
               customer_line_id = user.get( 'lineID', 'missing line id'),
               orderID = purchaseOrderId,
               deliveryDate = deliveryDate,
               price = cart['total'],
               orderSummary = genTable(cart),
               number_of_items = len(cart['orders'])
               )

    header = 'thanks for ordering'

    send_email(email1, header ,body , subject )
    send_email(email2, header ,body , subject )




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
    order_email(user,_cart, purchaseOrderId, deliveryDate)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "email sent",
            "received_object" : event
        }),
    }
