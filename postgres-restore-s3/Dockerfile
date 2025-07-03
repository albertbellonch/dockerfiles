FROM alpine:3.15
LABEL maintainer="Albert Bellonch <albert@bellonch.com>"

ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ENV POSTGRES_DATABASE=''
ENV POSTGRES_HOST=''
ENV POSTGRES_PORT=5432
ENV S3_BUCKET=''
ENV S3_REGION='us-west-1'
ENV S3_PATH='backup'
ENV DROP_PUBLIC='no'

ADD restore.sh restore.sh
RUN chmod +x /restore.sh

CMD ["sh", "restore.sh"]
