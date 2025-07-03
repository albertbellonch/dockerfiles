#! /bin/sh

# exit if a command fails
set -eo pipefail

# update and install dependencies
apk update
apk add openssl aws-cli

# add postgres repo and install postgresql-client
echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
apk update
apk add postgresql17-client

# cleanup
rm -rf /var/cache/apk/*

# print and verify pg_dump version
pg_dump --version

if ! pg_dump --version | grep -q "17."; then
  echo "❌ pg_dump is not 17.X!"
  exit 1
fi
