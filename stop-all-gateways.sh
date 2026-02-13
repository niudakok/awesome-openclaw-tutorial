#!/bin/zsh
echo "🛑 停止所有 Gateway 实例..."
echo ""

pids=$(ps aux | grep "openclaw.*gateway" | grep -v grep | awk '{print $2}')

if [ -z "$pids" ]; then
    echo "没有运行中的 Gateway"
else
    echo "找到以下进程:"
    ps aux | grep "openclaw.*gateway" | grep -v grep
    echo ""
    echo "正在停止..."
    echo "$pids" | xargs kill
    sleep 2
    echo "✅ 已停止"
fi
