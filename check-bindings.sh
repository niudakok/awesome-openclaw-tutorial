#!/bin/bash

echo "=== 检查 OpenClaw Bindings 配置 ==="
echo ""

echo "📋 当前的 Bindings 配置："
cat ~/.openclaw/openclaw.json | python3 -c "
import json, sys
data = json.load(sys.stdin)
bindings = data.get('bindings', [])
for b in bindings:
    agent_id = b.get('agentId')
    peer = b.get('match', {}).get('peer', {})
    kind = peer.get('kind')
    peer_id = peer.get('id')
    print(f'  {agent_id:20} → {kind:8} → {peer_id}')
"

echo ""
echo "🤖 当前的 Agents 配置："
cat ~/.openclaw/openclaw.json | python3 -c "
import json, sys
data = json.load(sys.stdin)
agents = data.get('agents', {}).get('list', [])
for a in agents:
    agent_id = a.get('id')
    model = a.get('model', {}).get('primary', 'N/A')
    workspace = a.get('workspace', 'N/A')
    print(f'  {agent_id:20} → {model:40} → {workspace}')
"

echo ""
echo "📱 飞书机器人配置："
cat ~/.openclaw/openclaw.json | python3 -c "
import json, sys
data = json.load(sys.stdin)
accounts = data.get('channels', {}).get('feishu', {}).get('accounts', {})
for name, config in accounts.items():
    bot_name = config.get('botName', 'N/A')
    app_id = config.get('appId', 'N/A')
    enabled = config.get('enabled', False)
    status = '✅' if enabled else '❌'
    print(f'  {status} {name:20} → {bot_name:20} → {app_id}')
"

echo ""
echo "💡 使用说明："
echo "1. 在不同的飞书群组中发送消息"
echo "2. 运行 'openclaw logs --follow' 查看日志"
echo "3. 在日志中找到 'chat_id: oc_xxx' 来确认群组 ID"
echo "4. 确保群组 ID 与 bindings 配置中的 ID 匹配"
