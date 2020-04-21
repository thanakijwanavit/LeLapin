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


HEADER_TEMPLATE = '''

<table class="tg" style="undefined;table-layout: fixed; width: 516px" border="1">
<colgroup>
<col style="width: 99px">
<col style="width: 97px">
<col style="width: 93px">
<col style="width: 64px">
<col style="width: 84px">
</colgroup>
  <tr>
    <th class="tg-0lax">Item</th>
    <th class="tg-0pky">Dish</th>
    <th class="tg-0pky">topping</th>
    <th class="tg-0pky">price</th>
    <th class="tg-0lax">item total</th>
  </tr>
'''
ORDER_TEMPLATE = '''
  <tr>
    <td class="tg-0lax">{item_id}</td>
    <td class="tg-0pky">{base_name}</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">{base_price}</td>
    <td class="tg-0lax">{order_price}</td>
  </tr>
'''
TOPPING_TEMPLATE = '''
  <tr>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax">{topping_name}</td>
    <td class="tg-0lax">{topping_price}</td>
    <td class="tg-0lax"></td>
  </tr>
'''

def generateSummary(cart):

    final_html = '''
    '''

    final_html += HEADER_TEMPLATE


    print(cart)

    orders = cart['orders']
    for i, order in enumerate(orders):
        baseItem = ORDER_TEMPLATE.format(
            item_id = i,
            order_price = order['totalPrice'],
            base_name = order['base']['name'],
            base_price = order['base']['price'])
        final_html += baseItem

        if len(order['topping']) > 0:
            for topping in order['topping']:
                toppingItem = TOPPING_TEMPLATE.format(topping_name = topping['name'],
                                                      topping_price = topping['price'])
                final_html += toppingItem


    return final_html


def lambda_handler(event, context):
    cart = event['cart']
    table = generateSummary(cart)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "email sent",
            "received_object" : event,
            "table": table
        }),
    }
