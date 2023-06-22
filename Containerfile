FROM docker.io/amazon/aws-cli:latest

COPY setup.sh /tmp/setup.sh

RUN bash /tmp/setup.sh && rm /tmp/setup.sh
