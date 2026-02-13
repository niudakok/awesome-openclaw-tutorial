#!/bin/zsh
echo "🚀 启动所有 Gateway 实例..."
echo ""

profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")

for profile in "${profiles[@]}"; do
    echo "启动 $profile..."
    openclaw --profile "$profile" gateway run > "logs-$profile.log" 2>&1 &
    sleep 2
done

echo ""
echo "✅ 所有 Gateway 已启动"
echo ""
echo "查看状态: ./check-gateways.sh"
echo "停止所有: ./stop-all-gateways.sh"
echo ""
echo "查看日志:"
echo "  tail -f logs-main-assistant.log"
echo "  tail -f logs-content-creator.log"
echo "  tail -f logs-tech-dev.log"
echo "  tail -f logs-ai-news.log"
