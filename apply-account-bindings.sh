#!/bin/bash

echo "🔧 应用 Account Bindings 配置"
echo "=================================="
echo ""

echo "📋 新配置说明："
echo "-----------------------------------"
echo "使用 account 匹配而不是 peer.id 匹配："
echo ""
echo "  main-agent    → account: main-assistant  (主助理)"
echo "  content-agent → account: content-creator (内容创作助手)"
echo "  tech-agent    → account: tech-dev        (技术开发助手)"
echo "  ainews-agent  → account: ai-news         (AI资讯助手)"
echo ""
echo "这样每个飞书机器人直接绑定到一个 agent"
echo ""

read -p "是否应用新配置？(y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 取消操作"
    exit 1
fi

echo ""
echo "1️⃣  备份当前配置..."
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%Y%m%d_%H%M%S)
echo "   ✅ 已备份到: ~/.openclaw/openclaw.json.backup.$(date +%Y%m%d_%H%M%S)"

echo ""
echo "2️⃣  应用新配置..."
cp openclaw-account-bindings.json ~/.openclaw/openclaw.json
echo "   ✅ 配置已更新"

echo ""
echo "3️⃣  验证配置..."
openclaw doctor 2>&1 | grep -E "Config|valid|error" | head -5

echo ""
echo "4️⃣  重启网关..."
openclaw gateway restart

echo ""
echo "⏳ 等待网关启动..."
sleep 3

echo ""
echo "5️⃣  检查网关状态..."
openclaw gateway status 2>&1 | grep -E "Gateway:|running|active" | head -3

echo ""
echo ""
echo "✅ 配置已应用！"
echo "=================================="
echo ""
echo "📱 测试步骤："
echo ""
echo "1. 在 4 个不同的飞书机器人中分别发送消息："
echo ""
echo "   主助理 (main-assistant)      → 应使用 main-agent"
echo "   内容创作助手 (content-creator) → 应使用 content-agent"
echo "   技术开发助手 (tech-dev)        → 应使用 tech-agent"
echo "   AI资讯助手 (ai-news)          → 应使用 ainews-agent"
echo ""
echo "2. 运行监控脚本查看路由："
echo ""
echo "   openclaw logs --follow | grep -E 'Agent:|chat_id|lane=session'"
echo ""
echo "3. 如果还是不工作，查看诊断报告："
echo ""
echo "   cat BINDINGS-ISSUE-REPORT.md"
echo ""
