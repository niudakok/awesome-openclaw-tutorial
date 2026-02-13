#!/bin/bash

echo "🧪 OpenClaw 多 Agent 路由最终测试"
echo "=================================="
echo ""

echo "📋 配置摘要："
echo "-----------------------------------"
cat ~/.openclaw/openclaw.json | python3 -c "
import json, sys
data = json.load(sys.stdin)

# Bindings
bindings = data.get('bindings', [])
print(f'Bindings: {len(bindings)} 个')
for b in bindings:
    agent = b.get('agentId')
    peer_id = b.get('match', {}).get('peer', {}).get('id', '')
    short_id = peer_id[-8:] if peer_id else 'N/A'
    print(f'  • {agent:15} → ...{short_id}')

print()

# Agents
agents = data.get('agents', {}).get('list', [])
print(f'Agents: {len(agents)} 个')
for a in agents:
    agent_id = a.get('id')
    model = a.get('model', {}).get('primary', '').split('/')[-1]
    print(f'  • {agent_id:15} → {model}')
"

echo ""
echo "🔍 测试步骤："
echo "-----------------------------------"
echo ""
echo "1️⃣  在群组 1 (主助理群) 发送: '测试1'"
echo "   期望: main-agent + claude-opus-4-6-thinking"
echo ""
echo "2️⃣  在群组 2 (内容创作群) 发送: '测试2'"
echo "   期望: content-agent + claude-sonnet-4-5"
echo ""
echo "3️⃣  在群组 3 (技术开发群) 发送: '测试3'"
echo "   期望: tech-agent + claude-sonnet-4-5-thinking"
echo ""
echo "4️⃣  在群组 4 (AI资讯群) 发送: '测试4'"
echo "   期望: ainews-agent + gemini-2.5-flash"
echo ""
echo "-----------------------------------"
echo ""
read -p "准备好了吗？按回车开始监控日志..."

echo ""
echo "📊 实时监控（按 Ctrl+C 停止）："
echo "=================================="
echo ""

openclaw logs --follow | grep --line-buffered -E "chat_id|lane=session:agent:|model:" | while read line; do
    if [[ $line =~ chat_id ]]; then
        group_id=$(echo "$line" | grep -oE "oc_[a-z0-9]+" | head -1)
        echo "📱 群组: ...${group_id: -8}"
    elif [[ $line =~ lane=session:agent: ]]; then
        agent=$(echo "$line" | grep -oE "agent:[a-z-]+" | cut -d':' -f2)
        echo "   🤖 Agent: $agent"
    elif [[ $line =~ "model:" ]]; then
        model=$(echo "$line" | grep -oE "model: [a-z0-9/-]+" | cut -d' ' -f2 | cut -d'/' -f2)
        echo "   🧠 Model: $model"
        echo ""
    fi
done
