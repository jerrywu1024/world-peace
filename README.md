# world-peace

一套根据个人使用习惯维护的 Shadowrocket 配置，适用于中国大陆常见的家庭、移动网络和公司网络环境。

配置采用“常用服务精细分流、中国大陆流量直连、其他未知流量代理”的基本逻辑，主要覆盖 Google、YouTube、AI、GitHub、流媒体、Apple、Microsoft 和常见国内服务。

## 配置特点

- 关闭 IPv6，减少部分网络中 IPv6 链路不完整造成的连接异常。
- 使用腾讯、阿里和 360 DoH，降低普通 DNS 被干扰的概率。
- 允许 QUIC，实际效果取决于代理节点是否稳定支持 UDP。
- 降低自动测速频率和节点切换概率，减少延迟波动导致的频繁换节点。
- 中国大陆域名及 IP 默认直连，未知海外流量使用代理兜底。
- 为 AI、Google、GitHub、Microsoft 和流媒体等常用服务设置独立策略组。
- 个人规则与主配置分离，方便长期维护。

> 配置只能优化分流逻辑，实际体验仍取决于本地网络、代理节点和服务可用性。

## 分流偏好

- 普通海外服务默认使用日本节点。
- Netflix、Disney+、HBO Max 默认使用香港节点。
- Apple、Bilibili 和游戏平台默认直连，可在 Shadowrocket 中手动切换。
- SteamCN 直连，Steam 海外服务默认使用日本节点。
- 各地区节点组会在该地区内部自动选择延迟合适的节点。
- 地区之间不会自动故障切换，需要在对应策略组中手动选择。

## 规则处理顺序

配置按照以下顺序处理网络请求：

1. 局域网流量直接连接。
2. 拦截 iCloud Private Relay。
3. 优先应用个人自定义规则。
4. 对常用海外服务进行独立分流。
5. 中国大陆域名直接连接。
6. 未匹配域名解析后，如果目标是中国大陆 IP，则直接连接。
7. 其余未知流量使用默认代理。

## 个人规则

个人规则存放在 `rules/` 目录：

- `rules/direct.list`：强制直连，例如飞书、字节跳动等国内服务。
- `rules/proxy.list`：强制使用默认代理。
- `rules/reject.list`：拦截指定域名。
- `rules/ai.list`：补充 AI 服务分流规则。

修改个人规则后，需要重新构建并推送配置。

## 修改主配置

主配置模板位于 `config/world-peace.conf.template`。需要调整 DNS、策略组或分流规则时，应修改模板文件，不要直接修改生成文件。

模板中使用以下占位符：

```text
{{RAW_BASE_URL}}
```

构建脚本会自动将它替换为仓库的 GitHub Raw 地址。

## 本地构建

在项目根目录执行：

```bash
RAW_BASE_URL="https://raw.githubusercontent.com/jerrywu1024/world-peace/main" bash scripts/build.sh
```

构建完成后，最终配置文件位于：

```text
dist/world-peace.conf
```

请勿直接修改 `dist/world-peace.conf`，否则下次构建时会被模板内容覆盖。

## 构建检查

macOS 可以使用系统自带的 `grep` 检查关键配置：

```bash
grep -E 'ipv6 =|block-quic|interval=|tolerance=|GEOIP|FINAL' dist/world-peace.conf
```

检查发布文件中是否残留模板占位符：

```bash
grep '{{RAW_BASE_URL}}' dist/world-peace.conf
```

如果构建正确，第二条命令应该没有输出。

## Shadowrocket 订阅

远程配置地址：

```text
https://raw.githubusercontent.com/jerrywu1024/world-peace/main/dist/world-peace.conf
```

在 Shadowrocket 中将该地址添加为远程配置。仓库更新后，在 Shadowrocket 中重新下载或更新配置。

更新后如果应用仍然沿用旧连接，可以彻底关闭应用后重新打开；必要时开关一次飞行模式。

## 使用建议

- 第一次使用时，检查各策略组是否已经选择预期地区。
- 普通海外服务建议保持日本节点。
- 流媒体服务根据账号地区和节点解锁情况手动调整。
- 如果开放 QUIC 后出现转圈或连接不稳定，可以将 `block-quic` 改回 `all-proxy` 对照测试。
- 如果某个国内服务错误地使用代理，可以将其域名加入 `rules/direct.list`。
- 如果某个海外服务错误地直连，可以将其域名加入 `rules/proxy.list`。
- 自动测速只能降低手动选择节点的成本，不能保证出口 IP 永远不变。

## 安全说明

代理节点通过 Shadowrocket 的订阅管理添加。本仓库不保存机场订阅地址、节点信息、认证信息或其他敏感数据。

提交前请确认没有将个人订阅链接、节点密码或其他私密内容加入仓库。

## 致谢

策略组和部分规则组织方式参考 Johnshall 的 Shadowrocket-ADBlock-Rules-Forever，并使用 Blackmatrix7 等项目维护的公开规则集。

感谢相关作者的长期维护。
