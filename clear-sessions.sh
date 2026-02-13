#!/bin/bash

echo "🧹 清除所有 Agent 会话"
echo "=================================="
echo ""

echo "⚠️  警告：这将删除所有 agent 的会话历史！"
echo ""
read -p "确定要继续吗？(y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 取消操作"
    exit 1
fi

echo ""
echo "1️⃣  停止网关..."
openclaw gateway stop

echo ""
echo "2️⃣  备份会话..."
backup_dir=~/.openclaw/sessions-backup-$(date +%Y%m%d_%H%M%S)
mkdir -p "$backup_dir"

for agent_dir in ~/.openclaw/agents/*/; do
    agent_name=$(basename "$agent_dir")
    if [ -d "$agent_dir/sessions" ]; then
        echo "   备份 $agent_name 的会话..."
        cp -r "$agent_dir/sessions" "$backup_dir/$agent_name-sessions"
    fi
done

echo "   ✅ 会话已备份到: $backup_dir"

echo ""
echo "3️⃣  清除会话..."
rm -rf ~/.openclaw/agents/*/sessions/
echo "   ✅ 所有会话已清除"

echo ""
echo "4️⃣  重启网关..."
openclaw gateway install

echo ""
echo "⏳ 等待网关启动..."
sleep 3

echo ""
echo "5️⃣  检查网关状态..."
openclaw gateway status 2>&1 | grep -E "Gateway:|running|active" | head -3

echo ""
echo ""
echo "✅ 会话已清除！"
echo "=================================="
echo ""
echo "📱 下一步："
echo ""
echo "1. 在 4 个不同的飞书群组中分别发送新消息"
echo "2. 运行测试脚本验证路由："
echo ""
echo "   ./final-test.sh"
echo ""
echo "3. 如果还是不工作，查看诊断报告："
echo ""
echo "   cat FINAL-DIAGNOSIS.md"
echo ""
echo "💾 会话备份位置："
echo "   $backup_dir"
echo ""
