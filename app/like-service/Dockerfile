FROM python:2.7-slim

RUN set -ex && \
    mkdir /MythicalMysfitsService

WORKDIR /MythicalMysfitsService
COPY ./service /MythicalMysfitsService

RUN set -ex && \
    pip install -r requirements.txt && \
    rm -rf requirements.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80

CMD ["python", "mysfits_like.py"]
