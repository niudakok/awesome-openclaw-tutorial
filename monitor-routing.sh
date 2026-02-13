#!/bin/bash

echo "🔍 实时监控 OpenClaw 路由"
echo "=================================="
echo ""
echo "请在不同的飞书群组中发送消息..."
echo "按 Ctrl+C 停止监控"
echo ""

openclaw logs --follow | while read line; do
    # 提取群组 ID
    if [[ $line =~ oc_[a-z0-9]+ ]]; then
        group_id=$(echo "$line" | grep -oE "oc_[a-z0-9]+" | head -1)
        
        # 显示群组信息
        case "$group_id" in
            "oc_053c93f17fc47e587df58c776f831de5")
                echo "📱 群组 1: $group_id"
                echo "   ✅ 应使用: main-agent (Claude Opus 4.6 Thinking)"
                ;;
            "oc_b59b5a7ec4f4605ef19c7381e18441dc")
                echo "📱 群组 2: $group_id"
                echo "   ✅ 应使用: content-agent (Claude Sonnet 4.5)"
                ;;
            "oc_497bcc045e75228209e5030481a6fef7")
                echo "📱 群组 3: $group_id"
                echo "   ✅ 应使用: tech-agent (Claude Sonnet 4.5 Thinking)"
                ;;
            "oc_bd1074d29ace112ebbd9cf15a2c9fc2d")
                echo "📱 群组 4: $group_id"
                echo "   ✅ 应使用: ainews-agent (Gemini 2.5 Flash)"
                ;;
        esac
    fi
    
    # 提取实际使用的 agent
    if [[ $line =~ lane=session:agent:([a-z-]+): ]]; then
        agent=$(echo "$line" | grep -oE "lane=session:agent:[a-z-]+" | cut -d':' -f3)
        echo "   🤖 实际使用: $agent"
        echo ""
    fi
done
