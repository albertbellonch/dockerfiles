#! /bin/sh

set -eo pipefail
set -o pipefail

if [ -z "${S3_ACCESS_KEY_ID}" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ -z "${S3_SECRET_ACCESS_KEY}" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ -z "${S3_BUCKET}" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ -z "${POSTGRES_DATABASE}" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ -z "${POSTGRES_HOST}" ]; then
  if [ -n "${POSTGRES_PORT_5432_TCP_ADDR}" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [ -z "${POSTGRES_USER}" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ -z "${POSTGRES_PASSWORD}" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

if [ -z "${S3_ENDPOINT}" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER"

echo "Finding latest backup"

LATEST_BACKUP=$(aws $AWS_ARGS s3 ls s3://$S3_BUCKET/ | sort | tail -n 1 | awk '{ print $4 }')

echo "Fetching ${LATEST_BACKUP} from S3"

aws $AWS_ARGS s3 cp s3://$S3_BUCKET/${LATEST_BACKUP} dump.sql.gz
gzip -d dump.sql.gz

if [ "${DROP_PUBLIC}" == "yes" ]; then
	echo "Recreating the public schema"
	psql $POSTGRES_HOST_OPTS -d $POSTGRES_DATABASE -c "drop schema public cascade; create schema public;"
fi

echo "Restoring ${LATEST_BACKUP}"

# Restore the database
postgres pg_restore --create --clean -d $POSTGRES_DATABASE < dump.sql

echo "Restore complete"

