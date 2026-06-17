# Shadowrocket 自定义规则

这个仓库用于维护并发布自己的 Shadowrocket 配置和规则。当前结构参考了 [Johnshall/Shadowrocket-ADBlock-Rules-Forever](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever) 项目中的 [懒人配置（含策略组）](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever#%E6%87%92%E4%BA%BA%E9%85%8D%E7%BD%AE-%E5%90%AB%E7%AD%96%E7%95%A5%E7%BB%84) 思路，并在此基础上把个人规则拆成独立文件，方便后续长期维护。

## 文件结构

- `config/World Peace.conf.template`：主配置模板
- `rules/direct.list`：强制直连规则
- `rules/proxy.list`：强制代理规则
- `rules/reject.list`：广告、跟踪、骚扰域名拦截规则
- `rules/ai.list`：AI 服务补充规则
- `scripts/build.sh`：生成可发布配置
- `scripts/validate-shadowrocket.sh`：基础格式检查

## 第一次发布

1. 在 GitHub 新建一个公开仓库，例如 `shadowrocket-rules`。
2. 把本文件夹推送到该仓库。
3. 推送后，在 GitHub 仓库的 `Settings -> Pages` 里选择 `GitHub Actions`。
4. 每次推送到 `main` 分支后，GitHub 会自动生成并发布配置。

发布地址通常是：

```text
https://<你的 GitHub 用户名>.github.io/<仓库名>/World%20Peace.conf
```

例如：

```text
https://jerrywu1024.github.io/shadowrocket-rules/World%20Peace.conf
```

## 本地预览

如果想先在本地生成一份配置：

```bash
RAW_BASE_URL="https://raw.githubusercontent.com/jerrywu1024/shadowrocket-rules/main" ./scripts/build.sh
```

本地生成后的配置在：

```text
dist/World Peace.conf
```

当前可直接使用的 Raw 订阅链接：

```text
https://raw.githubusercontent.com/jerrywu1024/shadowrocket-rules/main/dist/World%20Peace.conf
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
RAW_BASE_URL="https://raw.githubusercontent.com/jerrywu1024/shadowrocket-rules/main" ./scripts/build.sh
```

然后提交并推送到 GitHub。Shadowrocket 里更新配置即可。

## 本版策略调整

本配置在 Johnshall 懒人配置的基础上，按个人 OpenClash 分流习惯调整了策略组顺序：

- 非流媒体和泛海外服务默认日本优先，例如 `AI`、`Google`、`YouTube`、`Telegram`、`Twitter`、`Facebook`、`GitHub`、`Microsoft`、`OneDrive`、`PayPal`、`Amazon`、`TikTok`。
- 流媒体单独按解锁偏好排序，`Netflix`、`Disney+`、`HBO Max` 优先使用香港节点，其后再按日本、美国、新加坡、台湾、韩国兜底。
- 通用默认组 `PROXY` 也采用日本优先，并把 `自动选择` 放在国家节点之后、`DIRECT` 之前。
- 业务策略组不把 `PROXY` 放在第一位，优先列出明确地区节点，`PROXY` 只作为兜底。
- `Max` 统一命名为 `HBO Max`，对应规则也统一指向 `HBO Max`。
- 国家节点组保持 `url-test`，统一使用 `https://www.gstatic.com/generate_204` 测速，`interval=600`、`tolerance=80`、`timeout=5`。

主配置仍然保持个人规则优先：本地拦截、直连、代理、AI 补充规则会先于公开规则集匹配。

## 致谢

感谢 [Johnshall/Shadowrocket-ADBlock-Rules-Forever](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever) 长期维护 Shadowrocket 去广告与分流规则。本仓库的主配置和策略组组织方式参考了该项目的 [懒人配置（含策略组）](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever#%E6%87%92%E4%BA%BA%E9%85%8D%E7%BD%AE-%E5%90%AB%E7%AD%96%E7%95%A5%E7%BB%84)，并根据个人使用习惯做了拆分和调整。
