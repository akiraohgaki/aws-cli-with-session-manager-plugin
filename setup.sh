#!/bin/bash

ARCH="$(uname -m)"
SESSION_MANAGER_PLUGIN_RPM_URL='https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm'

if [ "${ARCH}" = 'aarch64' ] || [ "${ARCH}" = 'arm64' ]; then
  SESSION_MANAGER_PLUGIN_RPM_URL='https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_arm64/session-manager-plugin.rpm'
fi

curl -fsSL "${SESSION_MANAGER_PLUGIN_RPM_URL}" -o /tmp/session-manager-plugin.rpm

yum install -y /tmp/session-manager-plugin.rpm

rm /tmp/session-manager-plugin.rpm
