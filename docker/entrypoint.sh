#!/bin/sh
set -e

CONFIG_DIR="/config"
CONFIG_FILE="${CONFIG_DIR}/config.conf"
LOG_FILE="${CONFIG_DIR}/cf-probe.log"

# 创建目录（Docker Compose volume 挂载后持久化）
mkdir -p "${CONFIG_DIR}"

# 首次运行自动生成配置（仅第一次）
if [ ! -f "${CONFIG_FILE}" ]; then
  echo "首次运行，自动生成 config.conf"
  cat > "${CONFIG_FILE}" <<EOF
server_id=${SERVER_ID}
secret=${SECRET}
worker_url=${WORKER_URL}
report_interval=${REPORT_INTERVAL:-60}
connection_mode=${CONNECTION_MODE:-auto}
ping_mode=${PING_MODE:-tcp}
auto_update=${AUTO_UPDATE:-0}
debug=${DEBUG:-0}
EOF
fi

echo "启动 cf-probe..."
exec /usr/local/bin/cf-probe run -config "${CONFIG_FILE}" 2>&1 | tee -a "${LOG_FILE}"
