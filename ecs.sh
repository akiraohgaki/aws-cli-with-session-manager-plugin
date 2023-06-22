#!/bin/bash

ACCESS_KEY_ID=''
SECRET_ACCESS_KEY=''
REGION=''
CLUSTER=''
TASK=''
CONTAINER=''

WORK_DIR="$(cd "$(dirname "${0}")" && pwd)"
IMAGE_BUILD_CONTEXT="${WORK_DIR}"
IMAGE_TAG='localhost/aws-cli-with-session-manager-plugin:latest'

COMMAND=''

if [ "${COMMAND}" = '' ]; then
  if [ "$(which docker)" ]; then
    COMMAND='docker'
  elif [ "$(which podman)" ]; then
    COMMAND='podman'
  else
    echo 'docker or podman required'
    exit 1
  fi
fi

if [ "${1}" = '--build' ]; then
  "${COMMAND}" build -t "${IMAGE_TAG}" \
    -f "${IMAGE_BUILD_CONTEXT}/Containerfile" "${IMAGE_BUILD_CONTEXT}"
fi

if [ ! -d "${WORK_DIR}/.aws" ]; then
  mkdir "${WORK_DIR}/.aws"
fi

"${COMMAND}" run --rm -ti \
  -e AWS_ACCESS_KEY_ID="${ACCESS_KEY_ID}" \
  -e AWS_SECRET_ACCESS_KEY="${SECRET_ACCESS_KEY}" \
  -e AWS_DEFAULT_REGION="${REGION}" \
  -e AWS_DEFAULT_OUTPUT=json \
  -v "${WORK_DIR}/.aws:/root/.aws:z" \
  -v "${WORK_DIR}:/aws:z" \
  "${IMAGE_TAG}" ecs execute-command \
  --region "${REGION}" \
  --cluster "${CLUSTER}" \
  --task "${TASK}" \
  --container "${CONTAINER}" \
  --interactive \
  --command '/bin/bash'
