#!/bin/bash

echo "🔍 实时监控 OpenClaw 消息路由"
echo "请在不同的飞书群组中发送消息，我会显示路由信息..."
echo ""
echo "按 Ctrl+C 停止监控"
echo "================================================"
echo ""

openclaw logs --follow | grep --line-buffered -E "chat_id|agent.*session|New session started" | while read line; do
    if [[ $line == *"chat_id"* ]]; then
        # 提取群组 ID
        group_id=$(echo "$line" | grep -oE "oc_[a-z0-9]+" | head -1)
        if [ ! -z "$group_id" ]; then
            echo "📱 群组: $group_id"
            
            # 查找对应的 agent
            case "$group_id" in
                "oc_053c93f17fc47e587df58c776f831de5")
                    echo "   → 应该使用: main-agent (Claude Opus 4.6 Thinking)"
                    ;;
                "oc_b59b5a7ec4f4605ef19c7381e18441dc")
                    echo "   → 应该使用: content-agent (Claude Sonnet 4.5)"
                    ;;
                "oc_497bcc045e75228209e5030481a6fef7")
                    echo "   → 应该使用: tech-agent (Claude Sonnet 4.5 Thinking)"
                    ;;
                "oc_bd1074d29ace112ebbd9cf15a2c9fc2d")
                    echo "   → 应该使用: ainews-agent (Gemini 2.5 Flash)"
                    ;;
                *)
                    echo "   ⚠️  未配置的群组！会使用默认 agent"
                    ;;
            esac
        fi
    elif [[ $line == *"session"* ]] && [[ $line == *"agent"* ]]; then
        # 提取实际使用的 agent
        agent=$(echo "$line" | grep -oE "agent [a-z-]+" | cut -d' ' -f2)
        if [ ! -z "$agent" ]; then
            echo "   ✅ 实际使用: $agent"
        fi
    elif [[ $line == *"New session started"* ]]; then
        # 提取模型信息
        model=$(echo "$line" | grep -oE "model: [a-z0-9/-]+" | cut -d' ' -f2)
        if [ ! -z "$model" ]; then
            echo "   🤖 模型: $model"
            echo ""
        fi
    fi
done
