#!/bin/bash

ACCESS_KEY_ID=''
SECRET_ACCESS_KEY=''
REGION=''
CLUSTER=''
TASK=''
CONTAINER=''

COMMAND='podman'
WORK_DIR="$(cd "$(dirname "${0}")" && pwd)"

if [ "${1}" = '--build' ]; then
  COMMAND build -t localhost/aws-cli-with-session-manager-plugin:latest \
    -f "${WORK_DIR}/Containerfile" "${WORK_DIR}"
fi

if [ ! -d "${WORK_DIR}/.aws" ]; then
  mkdir "${WORK_DIR}/.aws"
fi

COMMAND run --rm -ti \
  -e AWS_ACCESS_KEY_ID="${ACCESS_KEY_ID}" \
  -e AWS_SECRET_ACCESS_KEY="${SECRET_ACCESS_KEY}" \
  -e AWS_DEFAULT_REGION="${REGION}" \
  -e AWS_DEFAULT_OUTPUT=json \
  -v "${WORK_DIR}/.aws:/root/.aws:z" \
  -v "${WORK_DIR}:/aws:z" \
  localhost/aws-cli-with-session-manager-plugin:latest ecs execute-command \
  --region "${REGION}" \
  --cluster "${CLUSTER}" \
  --task "${TASK}" \
  --container "${CONTAINER}" \
  --interactive \
  --command "/bin/bash"
