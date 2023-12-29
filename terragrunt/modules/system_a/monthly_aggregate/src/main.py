import json

def lambda_handler(event, context):
    # ここに処理を記述する
    print("hogera2")
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
