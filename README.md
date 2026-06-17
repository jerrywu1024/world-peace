# Shadowrocket 自定义规则

这个仓库用于维护并发布自己的 Shadowrocket 配置和规则。当前结构参考了 `lazy_group.conf` 的常见分组方式，但把个人规则拆成独立文件，方便后续长期维护。

## 文件结构

- `config/lazy_group_custom.conf.template`：主配置模板
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
https://<你的 GitHub 用户名>.github.io/<仓库名>/lazy_group.conf
```

例如：

```text
https://jerrywu1024.github.io/shadowrocket-rules/lazy_group.conf
```

## 本地预览

如果想先在本地生成一份配置：

```bash
RAW_BASE_URL="https://raw.githubusercontent.com/jerrywu1024/shadowrocket-rules/main" ./scripts/build.sh
```

本地生成后的配置在：

```text
dist/lazy_group.conf
```

当前可直接使用的 Raw 订阅链接：

```text
https://raw.githubusercontent.com/jerrywu1024/shadowrocket-rules/main/dist/lazy_group.conf
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

## 规则顺序

主配置里的匹配顺序是：

1. 本地拦截规则
2. 本地直连规则
3. 本地代理规则
4. 本地 AI 补充规则
5. 常用公开规则集
6. 中国大陆 IP 直连
7. 其他全部走代理

这意味着你自己的规则优先级高于公开规则集。
