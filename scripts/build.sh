#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$ROOT_DIR/config/lazy_group_custom.conf.template"
OUTPUT_DIR="$ROOT_DIR/dist"
OUTPUT="$OUTPUT_DIR/lazy_group.conf"

if [[ -z "${RAW_BASE_URL:-}" ]]; then
  echo "请先设置 RAW_BASE_URL，例如："
  echo 'RAW_BASE_URL="https://raw.githubusercontent.com/<user>/<repo>/main" ./scripts/build.sh'
  exit 1
fi

mkdir -p "$OUTPUT_DIR"
sed "s#{{RAW_BASE_URL}}#${RAW_BASE_URL%/}#g" "$TEMPLATE" > "$OUTPUT"
echo "已生成：$OUTPUT"

