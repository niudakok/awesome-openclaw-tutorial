#!/bin/bash
# OpenClaw 网站监控脚本
# 监控指定网站的内容变化，发现更新时通知

# 配置
WEBSITE_URL="https://www.anthropic.com/news"
CACHE_FILE="$HOME/.openclaw/cache/website-monitor.txt"
OPENCLAW_BIN="openclaw"
CHANNEL="telegram"

# 创建缓存目录
mkdir -p "$(dirname "$CACHE_FILE")"

# 获取网站内容
CURRENT_CONTENT=$(curl -s "$WEBSITE_URL" | grep -oP '<h2.*?</h2>' | head -n 1)

# 检查是否有缓存
if [ -f "$CACHE_FILE" ]; then
    CACHED_CONTENT=$(cat "$CACHE_FILE")
    
    # 比较内容
    if [ "$CURRENT_CONTENT" != "$CACHED_CONTENT" ]; then
        echo "发现更新！"
        
        # 提取标题
        TITLE=$(echo "$CURRENT_CONTENT" | sed 's/<[^>]*>//g')
        
        # 发送通知
        MESSAGE="🔔 网站更新通知

网站：$WEBSITE_URL
最新内容：$TITLE

请访问网站查看详情。"
        
        $OPENCLAW_BIN message send --channel "$CHANNEL" --message "$MESSAGE"
        
        # 更新缓存
        echo "$CURRENT_CONTENT" > "$CACHE_FILE"
    else
        echo "无更新"
    fi
else
    # 首次运行，创建缓存
    echo "$CURRENT_CONTENT" > "$CACHE_FILE"
    echo "初始化缓存"
fi
