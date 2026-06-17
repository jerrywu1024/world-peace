#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FAILED=0

require_file() {
  local file="$1"
  if [[ ! -f "$ROOT_DIR/$file" ]]; then
    echo "缺少文件：$file" >&2
    FAILED=1
  fi
}

require_section() {
  local file="$1"
  local section="$2"
  if ! grep -Fq "$section" "$ROOT_DIR/$file"; then
    echo "$file 缺少段落：$section" >&2
    FAILED=1
  fi
}

check_rule_file() {
  local file="$1"
  awk -F, '
    /^[[:space:]]*$/ || /^[[:space:]]*#/ { next }
    $1 !~ /^(DOMAIN|DOMAIN-SUFFIX|DOMAIN-KEYWORD|DOMAIN-WILDCARD|IP-CIDR|IP-CIDR6|IP-ASN|USER-AGENT|URL-REGEX|RULE-SET|DOMAIN-SET|SCRIPT|DST-PORT|GEOIP|FINAL|AND|OR|NOT)$/ {
      printf "%s:%d 未识别的规则类型：%s\n", FILENAME, FNR, $1 > "/dev/stderr"
      exit 1
    }
  ' "$ROOT_DIR/$file" || FAILED=1
}

require_file "config/lazy_group_custom.conf.template"
require_file "rules/direct.list"
require_file "rules/proxy.list"
require_file "rules/reject.list"
require_file "rules/ai.list"
require_file "scripts/build.sh"

if [[ "$FAILED" -eq 0 ]]; then
  for section in "[General]" "[Proxy Group]" "[Rule]" "[Host]" "[URL Rewrite]" "[MITM]"; do
    require_section "config/lazy_group_custom.conf.template" "$section"
  done

  if ! grep -Fq "{{RAW_BASE_URL}}" "$ROOT_DIR/config/lazy_group_custom.conf.template"; then
    echo "config/lazy_group_custom.conf.template 缺少 {{RAW_BASE_URL}} 占位符" >&2
    FAILED=1
  fi

  check_rule_file "rules/direct.list"
  check_rule_file "rules/proxy.list"
  check_rule_file "rules/reject.list"
  check_rule_file "rules/ai.list"
fi

if [[ "$FAILED" -ne 0 ]]; then
  exit 1
fi

echo "Shadowrocket 配置检查通过"

