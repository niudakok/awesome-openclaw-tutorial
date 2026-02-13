#!/bin/zsh

# 查看所有 OpenClaw Gateway 服务状态

echo "📊 OpenClaw Gateway 服务状态"
echo "=============================="
echo ""

profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")
ports=(18789 18790 18791 18792)

for i in {1..4}; do
    profile="${profiles[$i]}"
    port="${ports[$i]}"
    
    echo "Profile: $profile (端口 $port)"
    
    # 检查 launchd 服务状态
    status=$(launchctl list | grep "com.openclaw.$profile" | awk '{print $1}')
    
    if [ -n "$status" ]; then
        if [ "$status" = "-" ]; then
            echo "  ⚠️  服务已加载但未运行"
        else
            echo "  ✅ 服务运行中 (PID: $status)"
        fi
    else
        echo "  ❌ 服务未加载"
    fi
    
    # 检查端口
    if lsof -i ":$port" > /dev/null 2>&1; then
        echo "  ✅ 端口 $port 已监听"
    else
        echo "  ❌ 端口 $port 未监听"
    fi
    
    # 检查日志文件
    stdout_log="$HOME/.openclaw-$profile/stdout.log"
    stderr_log="$HOME/.openclaw-$profile/stderr.log"
    
    if [ -f "$stdout_log" ]; then
        log_size=$(ls -lh "$stdout_log" | awk '{print $5}')
        echo "  📄 stdout 日志: $log_size"
    fi
    
    if [ -f "$stderr_log" ]; then
        log_size=$(ls -lh "$stderr_log" | awk '{print $5}')
        if [ -s "$stderr_log" ]; then
            echo "  ⚠️  stderr 日志: $log_size (有错误)"
        else
            echo "  ✅ stderr 日志: 空 (无错误)"
        fi
    fi
    
    echo ""
done

echo "=============================="
echo ""
echo "详细服务列表:"
launchctl list | grep openclaw

echo ""
echo "查看日志:"
echo "  tail -f ~/.openclaw-main-assistant/stdout.log"
echo "  tail -f ~/.openclaw-main-assistant/stderr.log"
