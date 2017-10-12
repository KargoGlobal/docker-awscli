FROM python:3.5

RUN apt-get update && \
    apt-get install --assume-yes --no-install-recommends groff && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install awscli

WORKDIR /workdir
