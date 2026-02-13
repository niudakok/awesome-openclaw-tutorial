#!/bin/bash

echo "🔍 OpenClaw 多 Agent 路由诊断工具"
echo "=================================="
echo ""

# 1. 检查配置文件是否一致
echo "📄 步骤 1: 检查配置文件"
echo "-----------------------------------"

if [ -f ~/.openclaw/openclaw.json ]; then
    echo "✅ 找到运行配置: ~/.openclaw/openclaw.json"
    
    # 检查 bindings 数量
    bindings_count=$(cat ~/.openclaw/openclaw.json | python3 -c "import json, sys; print(len(json.load(sys.stdin).get('bindings', [])))" 2>/dev/null)
    echo "   Bindings 数量: $bindings_count"
    
    # 检查 agents 数量
    agents_count=$(cat ~/.openclaw/openclaw.json | python3 -c "import json, sys; print(len(json.load(sys.stdin).get('agents', {}).get('list', [])))" 2>/dev/null)
    echo "   Agents 数量: $agents_count"
else
    echo "❌ 未找到配置文件: ~/.openclaw/openclaw.json"
fi

echo ""

# 2. 检查网关状态
echo "🌐 步骤 2: 检查网关状态"
echo "-----------------------------------"
openclaw gateway status 2>&1 | head -5

echo ""

# 3. 检查配置是否有效
echo "⚙️  步骤 3: 验证配置"
echo "-----------------------------------"
openclaw doctor 2>&1 | grep -E "Config|Gateway|Agents" | head -10

echo ""

# 4. 提供解决方案
echo "💡 步骤 4: 解决方案"
echo "-----------------------------------"
echo ""
echo "如果配置正确但路由不工作，请按以下步骤操作："
echo ""
echo "1️⃣  复制配置到运行目录："
echo "   cp openclaw.json ~/.openclaw/openclaw.json"
echo ""
echo "2️⃣  重启网关服务："
echo "   openclaw gateway restart"
echo ""
echo "3️⃣  查看实时日志："
echo "   openclaw logs --follow"
echo ""
echo "4️⃣  在不同群组发送测试消息，观察日志中的："
echo "   - chat_id (群组 ID)"
echo "   - agent (使用的 agent)"
echo "   - model (使用的模型)"
echo ""
echo "5️⃣  如果还是不工作，运行详细诊断："
echo "   openclaw logs --follow | grep -E 'chat_id|agent.*session|binding'"
echo ""
