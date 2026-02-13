# OpenClaw 多 Agent 路由故障排查指南

## 问题：所有群组都使用同一个 agent

### 可能的原因

#### 1. 配置文件格式问题

**检查方法：**
```bash
cat ~/.openclaw/openclaw.json | python3 -m json.tool > /dev/null
echo $?  # 应该输出 0
```

**常见错误：**
- JSON 语法错误（多余的逗号、引号不匹配）
- 使用了 Python 语法（True/False 而不是 true/false）

**解决方案：**
```bash
# 验证 JSON 格式
openclaw doctor

# 如果有错误，手动修复或重新生成配置
```

---

#### 2. Bindings 配置被忽略

**可能原因：**
- OpenClaw 版本不支持 bindings
- Bindings 配置位置错误
- 配置优先级问题

**检查版本：**
```bash
openclaw --version
# 确保版本 >= 2026.2.6
```

**检查配置结构：**
```json
{
  "agents": {
    "list": [
      { "id": "main-agent", ... },
      { "id": "content-agent", ... }
    ]
  },
  "bindings": [
    {
      "agentId": "main-agent",
      "match": {
        "channel": "feishu",
        "peer": { "kind": "group", "id": "oc_xxx" }
      }
    }
  ]
}
```

---

#### 3. 群组 ID 不匹配

**问题：**
配置中的群组 ID 与实际群组 ID 不一致

**检查方法：**
```bash
# 在群组中发送消息，然后查看日志
openclaw logs --follow | grep chat_id

# 输出示例：
# chat_id: oc_053c93f17fc47e587df58c776f831de5
```

**对比配置：**
```bash
cat ~/.openclaw/openclaw.json | python3 -c "
import json, sys
data = json.load(sys.stdin)
bindings = data.get('bindings', [])
for b in bindings:
    peer_id = b.get('match', {}).get('peer', {}).get('id')
    print(peer_id)
"
```

**解决方案：**
如果 ID 不匹配，更新配置文件中的群组 ID

---

#### 4. 网关缓存问题

**问题：**
网关没有重新加载配置

**解决方案：**
```bash
# 完全停止网关
openclaw gateway stop

# 等待 5 秒
sleep 5

# 重新启动
openclaw gateway install

# 检查状态
openclaw gateway status
```

---

#### 5. Agent 工作空间不存在

**问题：**
配置的 workspace 路径不存在，导致 agent 无法启动

**检查方法：**
```bash
cat ~/.openclaw/openclaw.json | python3 -c "
import json, sys, os
data = json.load(sys.stdin)
agents = data.get('agents', {}).get('list', [])
for a in agents:
    workspace = a.get('workspace')
    exists = os.path.exists(workspace) if workspace else False
    status = '✅' if exists else '❌'
    print(f'{status} {a.get(\"id\")}: {workspace}')
"
```

**解决方案：**
```bash
# 创建缺失的工作空间
mkdir -p /Users/chinamanor/clawd/content
mkdir -p /Users/chinamanor/clawd/tech
mkdir -p /Users/chinamanor/clawd/ainews

# 重启网关
openclaw gateway restart
```

---

#### 6. Bindings 匹配规则问题

**可能的问题：**
- `channel` 字段拼写错误（应该是 "feishu"）
- `peer.kind` 错误（应该是 "group" 或 "dm"）
- `peer.id` 格式错误

**正确的配置格式：**
```json
{
  "agentId": "main-agent",
  "match": {
    "channel": "feishu",
    "peer": {
      "kind": "group",
      "id": "oc_053c93f17fc47e587df58c776f831de5"
    }
  }
}
```

**检查配置：**
```bash
cat ~/.openclaw/openclaw.json | python3 -c "
import json, sys
data = json.load(sys.stdin)
bindings = data.get('bindings', [])
for i, b in enumerate(bindings, 1):
    print(f'Binding {i}:')
    print(f'  agentId: {b.get(\"agentId\")}')
    match = b.get('match', {})
    print(f'  channel: {match.get(\"channel\")}')
    peer = match.get('peer', {})
    print(f'  peer.kind: {peer.get(\"kind\")}')
    print(f'  peer.id: {peer.get(\"id\")}')
    print()
"
```

---

#### 7. 默认 Agent 优先级过高

**问题：**
`agents.defaults` 配置可能覆盖了 bindings

**检查配置：**
```bash
cat ~/.openclaw/openclaw.json | python3 -c "
import json, sys
data = json.load(sys.stdin)
defaults = data.get('agents', {}).get('defaults', {})
print('Defaults 配置:')
print(json.dumps(defaults, indent=2, ensure_ascii=False))
"
```

**注意：**
- `defaults` 只是默认配置，不应该影响 bindings
- 但某些版本可能有 bug

---

## 终极解决方案

如果以上方法都不行，尝试以下步骤：

### 方案 1：使用多账号模式（推荐）

不使用 bindings，而是为每个 agent 配置独立的飞书机器人：

```json
{
  "channels": {
    "feishu": {
      "accounts": {
        "main-assistant": {
          "appId": "cli_main_xxx",
          "appSecret": "xxx",
          "botName": "主助理"
        },
        "content-creator": {
          "appId": "cli_content_xxx",
          "appSecret": "xxx",
          "botName": "内容创作助手"
        }
      }
    }
  },
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
    }
  ]
}
```

### 方案 2：使用命令切换 Agent

在群组中使用命令切换 agent：

```
/agent content-agent
/model local-antigravity/claude-sonnet-4-5
```

### 方案 3：联系官方支持

如果是 OpenClaw 的 bug，需要：

1. 收集诊断信息：
```bash
openclaw doctor > diagnosis.txt
openclaw logs --tail 100 >> diagnosis.txt
```

2. 提交 issue 到 GitHub 或官方社区

---

## 验证路由是否工作

运行以下脚本验证：

```bash
#!/bin/bash

echo "发送测试消息到 4 个群组..."
echo ""

# 等待用户发送消息
read -p "请在群组 1 中发送消息，然后按回车..."
openclaw logs --tail 5 | grep -E "agent|chat_id"

read -p "请在群组 2 中发送消息，然后按回车..."
openclaw logs --tail 5 | grep -E "agent|chat_id"

read -p "请在群组 3 中发送消息，然后按回车..."
openclaw logs --tail 5 | grep -E "agent|chat_id"

read -p "请在群组 4 中发送消息，然后按回车..."
openclaw logs --tail 5 | grep -E "agent|chat_id"

echo ""
echo "✅ 测试完成！检查上面的输出，确认每个群组使用了正确的 agent"
```

---

## 成功标志

路由正确工作时，日志应该显示：

```
群组 1 (oc_053c93f17fc47e587df58c776f831de5):
  lane=session:agent:main-agent:feishu:group:oc_053c93f17fc47e587df58c776f831de5

群组 2 (oc_b59b5a7ec4f4605ef19c7381e18441dc):
  lane=session:agent:content-agent:feishu:group:oc_b59b5a7ec4f4605ef19c7381e18441dc

群组 3 (oc_497bcc045e75228209e5030481a6fef7):
  lane=session:agent:tech-agent:feishu:group:oc_497bcc045e75228209e5030481a6fef7

群组 4 (oc_bd1074d29ace112ebbd9cf15a2c9fc2d):
  lane=session:agent:ainews-agent:feishu:group:oc_bd1074d29ace112ebbd9cf15a2c9fc2d
```

每个群组的 `agent:` 后面应该是不同的 agent ID！
