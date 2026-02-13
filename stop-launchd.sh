#!/bin/zsh

# 停止所有 OpenClaw Gateway 服务

echo "🛑 停止所有 OpenClaw Gateway 服务..."
echo ""

profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")

for profile in "${profiles[@]}"; do
    plist_file="$HOME/Library/LaunchAgents/com.openclaw.$profile.plist"
    
    if [ -f "$plist_file" ]; then
        echo "停止 $profile..."
        launchctl unload "$plist_file" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "  ✅ 已停止"
        else
            echo "  ⚠️  服务未运行或已停止"
        fi
    else
        echo "  ⚠️  配置文件不存在: $plist_file"
    fi
done

echo ""
echo "✅ 所有服务已停止"
