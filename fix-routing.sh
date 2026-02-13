#!/bin/bash

echo "🔧 修复 OpenClaw 多 Agent 路由"
echo "=================================="
echo ""

# 1. 确认配置
echo "📋 当前 Bindings 配置："
cat ~/.openclaw/openclaw.json | python3 -c "
import json, sys
data = json.load(sys.stdin)
bindings = data.get('bindings', [])
for b in bindings:
    agent_id = b.get('agentId')
    peer = b.get('match', {}).get('peer', {})
    peer_id = peer.get('id')
    print(f'  {agent_id:20} → {peer_id}')
"

echo ""

# 2. 重启网关
echo "🔄 重启网关..."
openclaw gateway restart

echo ""
echo "⏳ 等待网关启动..."
sleep 3

echo ""

# 3. 检查状态
echo "✅ 网关状态："
openclaw gateway status 2>&1 | grep -E "Gateway:|running|active" | head -3

echo ""
echo ""
echo "📱 下一步操作："
echo "=================================="
echo ""
echo "1. 在以下群组中分别发送测试消息（例如：'测试'）："
echo ""
echo "   群组 1 (oc_053c93f17fc47e587df58c776f831de5) → 应使用 main-agent"
echo "   群组 2 (oc_b59b5a7ec4f4605ef19c7381e18441dc) → 应使用 content-agent"
echo "   群组 3 (oc_497bcc045e75228209e5030481a6fef7) → 应使用 tech-agent"
echo "   群组 4 (oc_bd1074d29ace112ebbd9cf15a2c9fc2d) → 应使用 ainews-agent"
echo ""
echo "2. 运行以下命令查看实时路由："
echo ""
echo "   ./monitor-routing.sh"
echo ""
echo "   或者："
echo ""
echo "   openclaw logs --follow | grep -E 'chat_id|lane=session:agent'"
echo ""
