import json
import datetime
import logging
import requests

from customlogger import logger

# # カスタムフォーマットを設定するためのフォーマッター
# class CustomFormatter(logging.Formatter):
#   def format(self, record):
#     # JSON形式でログを生成
#     log_record = {
#       "time": datetime.datetime.utcnow().isoformat(),
#       "level": record.levelname,
#       "message": record.getMessage(),
#       "pathname": record.pathname,
#       "lineno": record.lineno
#     }
#     return json.dumps(log_record)

# # ロガーを設定
# logger = logging.getLogger()
# logger.setLevel(logging.INFO)

# # カスタムフォーマッターを使用
# formatter = CustomFormatter()
# handler = logging.StreamHandler()
# handler.setFormatter(formatter)
# logger.addHandler(handler)

def lambda_handler(event, context):
  # ここに処理を記述する
  logger.error("error message")
  logger.warn("warn message")
  logger.info("info message")
  if event.get("error") == 1:
    raise KeyError

  return {
    'statusCode': 200,
    'body': json.dumps('Hello from Lambda!')
  }
