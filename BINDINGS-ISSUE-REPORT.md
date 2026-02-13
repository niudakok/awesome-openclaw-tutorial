# OpenClaw Bindings 路由问题诊断报告

## 问题描述

配置了 4 个 agents 和 4 个 bindings，但所有飞书群组都路由到 `main-agent`，而不是配置的专属 agent。

## 配置信息

### Agents 配置
```
- main-agent    → claude-opus-4-6-thinking
- content-agent → claude-sonnet-4-5
- tech-agent    → claude-sonnet-4-5-thinking
- ainews-agent  → gemini-2.5-flash
```

### Bindings 配置
```
- main-agent    → oc_YOUR_MAIN_GROUP_ID
- content-agent → oc_YOUR_CONTENT_GROUP_ID
- tech-agent    → oc_YOUR_TECH_GROUP_ID
- ainews-agent  → oc_YOUR_NEWS_GROUP_ID
```

### 飞书账号配置
```
- main-assistant   → 主助理
- content-creator  → 内容创作助手
- tech-dev         → 技术开发助手
- ai-news          → AI资讯助手
```

## 实际运行情况

从日志可以看到：

```
lane=session:agent:main-agent:feishu:group:oc_YOUR_TECH_GROUP_ID
lane=session:agent:main-agent:feishu:group:oc_YOUR_CONTENT_GROUP_ID
```

**所有群组都使用 main-agent**，即使群组 ID 不同。

## 配置加载情况

日志显示配置已成功加载：

```
config change detected; evaluating reload (..., agents.list, bindings)
config change applied (dynamic reads: ..., agents.list, bindings)
```

## 问题分析

### ✅ 排除的问题

1. ✅ 配置文件格式正确（JSON 语法无误）
2. ✅ Bindings 配置已加载
3. ✅ Agents 配置已加载
4. ✅ 工作空间路径存在
5. ✅ 网关已重启
6. ✅ 群组 ID 正确

### ❌ 可能的原因

1. **Bindings 匹配逻辑问题**
   - OpenClaw 2026.2.9 的 bindings 功能可能有 bug
   - peer.id 匹配可能不工作
   - 默认 agent 优先级过高

2. **配置结构问题**
   - 当前使用 4 个飞书账号 + peer.id bindings
   - 可能需要使用 account bindings 而不是 peer.id bindings

3. **版本兼容性问题**
   - 文档中的配置示例可能是旧版本的
   - 新版本的 bindings 语法可能有变化

## 解决方案

### 方案 1：使用 Account Bindings（推荐）

修改配置，使用 `account` 匹配而不是 `peer.id` 匹配：

```json
{
  "bindings": [
    {
      "agentId": "main-agent",
      "match": {
        "channel": "feishu",
        "account": "main-assistant"
      }
    },
    {
      "agentId": "content-agent",
      "match": {
        "channel": "feishu",
        "account": "content-creator"
      }
    },
    {
      "agentId": "tech-agent",
      "match": {
        "channel": "feishu",
        "account": "tech-dev"
      }
    },
    {
      "agentId": "ainews-agent",
      "match": {
        "channel": "feishu",
        "account": "ai-news"
      }
    }
  ]
}
```

这样每个飞书机器人直接绑定到一个 agent，不依赖群组 ID。

### 方案 2：在群组中手动切换 Agent

在每个群组中发送命令：

```
群组 1: /agent main-agent
群组 2: /agent content-agent
群组 3: /agent tech-agent
群组 4: /agent ainews-agent
```

### 方案 3：使用单机器人 + 群组绑定（当前方案）

如果 peer.id bindings 应该工作但没有工作，可能需要：

1. 升级 OpenClaw 到最新版本
2. 查看官方文档确认 bindings 的正确语法
3. 提交 bug 报告到 OpenClaw 项目

## 测试步骤

### 测试方案 1（Account Bindings）

1. 修改配置文件，使用 account bindings
2. 重启网关：`openclaw gateway restart`
3. 在不同的飞书机器人中发送消息
4. 查看日志确认使用了不同的 agent

### 测试方案 2（手动切换）

1. 在群组 1 中发送：`/agent main-agent`
2. 在群组 2 中发送：`/agent content-agent`
3. 在群组 3 中发送：`/agent tech-agent`
4. 在群组 4 中发送：`/agent ainews-agent`
5. 发送测试消息确认 agent 已切换

## 下一步行动

1. **立即尝试**：方案 1（Account Bindings）
2. **备选方案**：方案 2（手动切换）
3. **长期方案**：联系 OpenClaw 官方确认 peer.id bindings 的正确用法

## 相关文件

- 配置文件：`~/.openclaw/openclaw.json`
- 本地副本：`openclaw.json`
- 日志文件：`/tmp/openclaw/openclaw-2026-02-13.log`
- 诊断脚本：
  - `diagnose-routing.sh`
  - `fix-routing.sh`
  - `monitor-routing.sh`
  - `check-logs-detailed.sh`

## 参考文档

- OpenClaw 版本：2026.2.9
- 文档章节：9.1.11 多 Agent 配置
- 配置示例：docs/03-advanced/09-multi-platform-integration.md

---

**结论**：配置本身是正确的，但 peer.id bindings 没有生效。建议尝试使用 account bindings 或手动切换 agent。
