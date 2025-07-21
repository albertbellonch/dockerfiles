#! /bin/sh

set -eo pipefail

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

if [ -z "${SCHEDULE}" ]; then
  sh backup.sh
else
  export -p > /env.sh
  echo "${SCHEDULE} root /bin/sh -c '. /env.sh; /bin/sh /backup.sh'" > /etc/crontabs/root
  exec go-crond /etc/crontabs/root
fi
