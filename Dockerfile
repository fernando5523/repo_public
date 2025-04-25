FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip3 install --upgrade pip &&pip3 install -r requirements.txt && pip3 install gunicorn

COPY . .

ENV PORT=8080
EXPOSE $PORT

CMD ["sh", "-c", "gunicorn -b 0.0.0.0:${PORT} app:app --access-logfile - --error-logfile -"]