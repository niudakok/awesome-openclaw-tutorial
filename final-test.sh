#!/bin/bash

echo "🧪 最终测试：验证 Agent 路由"
echo "=================================="
echo ""

echo "📋 当前配置："
echo "-----------------------------------"
openclaw agents list --bindings | grep -E "^- |Routing rules:|feishu peer"

echo ""
echo "=================================="
echo ""
echo "📱 测试步骤："
echo ""
echo "请在 4 个不同的飞书群组中分别发送消息："
echo ""
echo "1. 群组 oc_053c93f17fc47e587df58c776f831de5 → 发送 '测试1'"
echo "   期望: main-agent"
echo ""
echo "2. 群组 oc_b59b5a7ec4f4605ef19c7381e18441dc → 发送 '测试2'"
echo "   期望: content-agent"
echo ""
echo "3. 群组 oc_497bcc045e75228209e5030481a6fef7 → 发送 '测试3'"
echo "   期望: tech-agent"
echo ""
echo "4. 群组 oc_bd1074d29ace112ebbd9cf15a2c9fc2d → 发送 '测试4'"
echo "   期望: ainews-agent"
echo ""
echo "=================================="
echo ""

read -p "准备好了吗？按回车开始监控..."

echo ""
echo "📊 实时监控（按 Ctrl+C 停止）："
echo "=================================="
echo ""

# 监控日志，显示群组和 agent
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | grep --line-buffered "lane=session:agent" | while read line; do
    # 提取 agent 和群组 ID
    if [[ $line =~ agent:([a-z-]+):feishu:group:(oc_[a-z0-9]+) ]]; then
        agent="${BASH_REMATCH[1]}"
        group="${BASH_REMATCH[2]}"
        short_group="${group: -8}"
        
        echo "📱 群组 ...${short_group} → 🤖 ${agent}"
        
        # 检查是否正确
        case "$group" in
            "oc_053c93f17fc47e587df58c776f831de5")
                if [ "$agent" = "main-agent" ]; then
                    echo "   ✅ 正确！"
                else
                    echo "   ❌ 错误！应该是 main-agent"
                fi
                ;;
            "oc_b59b5a7ec4f4605ef19c7381e18441dc")
                if [ "$agent" = "content-agent" ]; then
                    echo "   ✅ 正确！"
                else
                    echo "   ❌ 错误！应该是 content-agent"
                fi
                ;;
            "oc_497bcc045e75228209e5030481a6fef7")
                if [ "$agent" = "tech-agent" ]; then
                    echo "   ✅ 正确！"
                else
                    echo "   ❌ 错误！应该是 tech-agent"
                fi
                ;;
            "oc_bd1074d29ace112ebbd9cf15a2c9fc2d")
                if [ "$agent" = "ainews-agent" ]; then
                    echo "   ✅ 正确！"
                else
                    echo "   ❌ 错误！应该是 ainews-agent"
                fi
                ;;
        esac
        echo ""
    fi
done
