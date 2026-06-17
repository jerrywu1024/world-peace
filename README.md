# world-peace

这个仓库用于维护并发布自己的 Shadowrocket 配置和规则。当前结构参考了 [Johnshall/Shadowrocket-ADBlock-Rules-Forever](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever) 项目中的 [懒人配置（含策略组）](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever#%E6%87%92%E4%BA%BA%E9%85%8D%E7%BD%AE-%E5%90%AB%E7%AD%96%E7%95%A5%E7%BB%84) 思路，并在此基础上把个人规则拆成独立文件，方便后续长期维护。


## 本地预览

如果想先在本地生成一份配置：

```bash
RAW_BASE_URL="https://raw.githubusercontent.com/jerrywu1024/world-peace/main" ./scripts/build.sh
```

本地生成后的配置在：

```text
dist/world-peace.conf
```

当前可直接使用的 Raw 订阅链接：

```text
https://raw.githubusercontent.com/jerrywu1024/world-peace/main/dist/world-peace.conf
```

## 日常维护

优先改 `rules/` 里的文件：

- 想让某个网站永远直连：加到 `rules/direct.list`
- 想让某个网站永远走代理：加到 `rules/proxy.list`
- 想屏蔽某个广告或跟踪域名：加到 `rules/reject.list`
- 想补充 AI 服务分流：加到 `rules/ai.list`

改完后运行：

```bash
./scripts/validate-shadowrocket.sh
RAW_BASE_URL="https://raw.githubusercontent.com/jerrywu1024/world-peace/main" ./scripts/build.sh
```

然后提交并推送到 GitHub。Shadowrocket 里更新配置即可。

## 本版策略调整

本配置在 Johnshall 懒人配置的基础上，按个人 OpenClash 分流习惯调整了策略组顺序：

- 非流媒体和泛海外服务默认日本优先，并按日本、美国、新加坡、香港、台湾、韩国、`PROXY` 兜底。
- 流媒体单独按解锁偏好排序，`Netflix`、`Disney+`、`HBO Max` 按香港、新加坡、日本、台湾、韩国、美国、`PROXY` 选择。
- `Apple`、`Bilibili`、`Gaming Platform` 默认直连优先，其后再兜底到 `PROXY` 和国家节点。
- `Steam` 已从 `Gaming Platform` 单独拆分；`SteamCN` 保持直连。
- 原中文策略组名已统一改为 `Apple`、`Bilibili`、`Gaming Platform`。
- 规则顺序调整为：局域网、个人拦截/直连/AI/代理、常用服务、中国直连、海外代理兜底、`FINAL,PROXY`。
- 国家节点组保持 `url-test`，统一使用 `https://www.gstatic.com/generate_204` 测速，`interval=600`、`tolerance=50`、`timeout=5`。
- direct.list增加bytedance、feishu、larksuite等直连域名，保证国内服务正常

主配置仍然保持个人规则优先：本地拦截、直连、代理、AI 补充规则会先于公开规则集匹配。

## 致谢

感谢 [Johnshall/Shadowrocket-ADBlock-Rules-Forever](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever) 长期维护 Shadowrocket 去广告与分流规则。本仓库的主配置和策略组组织方式参考了该项目的 [懒人配置（含策略组）](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever#%E6%87%92%E4%BA%BA%E9%85%8D%E7%BD%AE-%E5%90%AB%E7%AD%96%E7%95%A5%E7%BB%84)，并根据个人使用习惯做了拆分和调整。
