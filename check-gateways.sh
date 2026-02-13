#!/bin/zsh
echo "📊 Gateway 状态检查"
echo "===================="
echo ""

check_profile() {
    local profile=$1
    local port=$2
    
    echo "Profile: $profile (端口 $port)"
    
    # 检查进程
    if ps aux | grep "openclaw.*--profile $profile" | grep -v grep > /dev/null; then
        echo "  ✅ 进程运行中"
    else
        echo "  ❌ 进程未运行"
    fi
    
    # 检查端口
    if lsof -i ":$port" > /dev/null 2>&1; then
        echo "  ✅ 端口 $port 已监听"
    else
        echo "  ❌ 端口 $port 未监听"
    fi
    
    echo ""
}

check_profile "main-assistant" 18789
check_profile "content-creator" 18790
check_profile "tech-dev" 18791
check_profile "ai-news" 18792

echo "详细进程信息:"
ps aux | grep "openclaw.*gateway" | grep -v grep || echo "没有运行中的 Gateway"
