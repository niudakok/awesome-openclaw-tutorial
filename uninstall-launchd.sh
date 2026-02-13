#!/bin/zsh

# 卸载所有 OpenClaw Gateway 服务

echo "🗑️  卸载所有 OpenClaw Gateway 服务..."
echo ""

profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")

for profile in "${profiles[@]}"; do
    plist_file="$HOME/Library/LaunchAgents/com.openclaw.$profile.plist"
    
    if [ -f "$plist_file" ]; then
        echo "卸载 $profile..."
        
        # 停止并卸载服务
        launchctl unload "$plist_file" 2>/dev/null
        
        # 删除配置文件
        rm "$plist_file"
        
        echo "  ✅ 已卸载"
    else
        echo "  ⚠️  配置文件不存在: $plist_file"
    fi
done

echo ""
echo "✅ 所有服务已卸载"
echo ""
echo "注意: 配置文件和日志仍保留在 ~/.openclaw-<profile>/ 目录中"
echo "如需完全删除，请手动删除这些目录"
