#!/bin/zsh

# 重启所有 OpenClaw Gateway 服务

echo "🔄 重启所有 OpenClaw Gateway 服务..."
echo ""

profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")

for profile in "${profiles[@]}"; do
    plist_file="$HOME/Library/LaunchAgents/com.openclaw.$profile.plist"
    
    if [ -f "$plist_file" ]; then
        echo "重启 $profile..."
        
        # 停止
        launchctl unload "$plist_file" 2>/dev/null
        sleep 1
        
        # 启动
        launchctl load "$plist_file"
        
        if [ $? -eq 0 ]; then
            echo "  ✅ 已重启"
        else
            echo "  ❌ 重启失败"
        fi
    else
        echo "  ⚠️  配置文件不存在: $plist_file"
    fi
done

echo ""
echo "✅ 所有服务已重启"
echo ""
echo "查看状态: launchctl list | grep openclaw"
