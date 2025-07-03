FROM webdevops/go-crond:master-alpine
LABEL maintainer="Albert Bellonch <albert@bellonch.com>"

ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ENV POSTGRES_DATABASE=**None**
ENV POSTGRES_BACKUP_ALL=**None**
ENV POSTGRES_HOST=**None**
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=**None**
ENV POSTGRES_EXTRA_OPTS=''
ENV S3_BUCKET=**None**
ENV S3_FILE_NAME=**None**
ENV S3_REGION=us-west-1
ENV S3_ENDPOINT=**None**
ENV S3_S3V4=no
ENV SCHEDULE=**None**

ADD run.sh run.sh
ADD backup.sh backup.sh
RUN chmod +x /backup.sh

ENTRYPOINT []
CMD ["sh", "run.sh"]
