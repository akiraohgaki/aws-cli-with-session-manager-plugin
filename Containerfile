FROM docker.io/amazon/aws-cli:latest

ARG SESSION_MANAGER_PLUGIN_RPM_URL=https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm

RUN curl -fsSL ${SESSION_MANAGER_PLUGIN_RPM_URL} -o /tmp/session-manager-plugin.rpm && \
  yum install -y /tmp/session-manager-plugin.rpm && \
  rm /tmp/session-manager-plugin.rpm
