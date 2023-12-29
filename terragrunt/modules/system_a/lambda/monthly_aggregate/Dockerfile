FROM python:3.8-alpine as builder

WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt
RUN python -m pytest


FROM python:3.8-alpine

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /app

COPY requirements.txt /
COPY --from=builder /app/src/* /app

RUN pip install -r /requirements.txt

CMD ["python", "/app/main.py"]
