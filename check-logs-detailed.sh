#!/bin/bash

echo "🔍 查看最近的日志详情"
echo "=================================="
echo ""

# 查看最近 50 行日志，寻找关键信息
openclaw logs --tail 50 | grep -E "chat_id|lane=session|binding|agent.*session|New session" | tail -20

echo ""
echo "=================================="
echo ""
echo "💡 分析："
echo ""

# 统计使用的 agent
echo "📊 最近使用的 Agents："
openclaw logs --tail 100 | grep -oE "Agent: [a-z-]+" | sort | uniq -c

echo ""

# 查找群组信息
echo "📱 最近的群组消息："
openclaw logs --tail 100 | grep -E "oc_[a-z0-9]+" | tail -5

echo ""
echo "=================================="
echo ""
echo "🔧 问题诊断："
echo ""

# 检查是否有 binding 相关的日志
binding_logs=$(openclaw logs --tail 200 | grep -i "binding" | wc -l)
if [ "$binding_logs" -eq 0 ]; then
    echo "❌ 日志中没有找到 'binding' 相关信息"
    echo "   这可能意味着 bindings 配置没有被加载或使用"
    echo ""
    echo "   可能的原因："
    echo "   1. OpenClaw 版本不支持 bindings"
    echo "   2. bindings 配置格式错误"
    echo "   3. bindings 功能被禁用"
else
    echo "✅ 找到 $binding_logs 条 binding 相关日志"
    openclaw logs --tail 200 | grep -i "binding" | tail -5
fi

echo ""
echo "=================================="
echo ""
echo "💡 建议的解决方案："
echo ""
echo "由于所有群组都在使用 main-agent，建议尝试："
echo ""
echo "方案 1: 使用多机器人模式（每个 agent 对应一个飞书 bot）"
echo "   - 为每个 agent 创建独立的飞书应用"
echo "   - 使用 account 绑定而不是 peer.id 绑定"
echo ""
echo "方案 2: 在群组中手动切换 agent"
echo "   - 在群组中发送: /agent content-agent"
echo "   - 在群组中发送: /model local-antigravity/claude-sonnet-4-5"
echo ""
echo "方案 3: 检查 OpenClaw 版本和文档"
echo "   - 运行: openclaw --version"
echo "   - 查看官方文档确认 bindings 的正确用法"
echo ""
