import os
import boto3
import requests


def text_me(message: str):
    phone_number = os.getenv("PHONE_NUMBER")
    client = boto3.client(
        "sns",
        region_name="us-east-1"
    )
    response = client.publish(
        PhoneNumber=f"+{phone_number}",
        Message=message,
    )
    assert response['ResponseMetadata']['HTTPStatusCode'] == 200, "SMS Failed to send"


def handler(event=None, context=None):
    urls_to_check = [
        "https://tomhenighan.com",
        "https://www.tomhenighan.com",
        "http://tomhenighan.com",
        "http://www.tomhenighan.com",
        "https://havewemadeagiyet.com",
        "https://www.havewemadeagiyet.com",
        "http://havewemadeagiyet.com",
        "http://www.havewemadeagiyet.com",
        ]
    down_url_statuscodes = dict()
    for url in urls_to_check:
        statuscode = requests.get(url).status_code
        if statuscode != 200:
            down_url_statuscodes[url] = statuscode
    if down_url_statuscodes:
        msg = "The following sites appear to be down:\n{str(down_url_statuscodes)}"
        print(msg)
        text_me(msg)
    else:
        msg = "All sites appear to be up and running"
        print(msg)
        text_me(msg)
    return msg


if __name__ == "__main__":
    handler()
