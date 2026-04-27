FROM python:3.11-slim-buster

USER root

WORKDIR /app

ENV TZ=America/Sao_Paulo

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

RUN chmod +x /app/extracaodadoscomerciaistenant.py

ENTRYPOINT ["python", "extracaodadoscomerciaistenant.py"]