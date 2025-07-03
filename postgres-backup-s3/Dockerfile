FROM webdevops/go-crond:master-alpine
LABEL maintainer="Albert Bellonch <albert@bellonch.com>"

ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ENV POSTGRES_DATABASE=''
ENV POSTGRES_BACKUP_ALL=''
ENV POSTGRES_HOST=''
ENV POSTGRES_PORT=5432
ENV POSTGRES_EXTRA_OPTS=''
ENV S3_BUCKET=''
ENV S3_FILE_NAME=''
ENV S3_REGION='us-west-1'
ENV S3_S3V4='no'
ENV SCHEDULE=''

ADD run.sh run.sh
ADD backup.sh backup.sh
RUN chmod +x /backup.sh

ENTRYPOINT []
CMD ["sh", "run.sh"]
