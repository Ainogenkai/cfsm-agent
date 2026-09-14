#!/bin/sh
set -e

CONFIG_DIR="/config"
CONFIG_FILE="${CONFIG_DIR}/config.conf"
LOG_FILE="${CONFIG_DIR}/cf-probe.log"

mkdir -p "${CONFIG_DIR}"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "首次运行，自动生成 config.conf"
  cat > "${CONFIG_FILE}" <<EOF
SERVER_ID="${SERVER_ID}"
SECRET="${SECRET}"
WORKER_URL="${WORKER_URL}"
COLLECT_INTERVAL="${COLLECT_INTERVAL:-0}"
REPORT_INTERVAL="${REPORT_INTERVAL:-60}"
RESET_DAY="${RESET_DAY:-1}"
CONNECTION_MODE="${CONNECTION_MODE:-auto}"
PING_MODE="${PING_MODE:-tcp}"
INTERFACE="${INTERFACE}"
CT_NODE="${CT_NODE}"
CU_NODE="${CU_NODE}"
CM_NODE="${CM_NODE}"
BD_NODE="${BD_NODE}"
NODE_1="${NODE_1}"
NODE_2="${NODE_2}"
NODE_3="${NODE_3}"
NODE_4="${NODE_4}"
AUTO_UPDATE="${AUTO_UPDATE:-0}"
UPDATE_PROXY="${UPDATE_PROXY}"
EOF
fi

echo "启动 cf-probe..."
exec /usr/local/bin/cf-probe run -config "${CONFIG_FILE}" 2>&1 | tee -a "${LOG_FILE}"
