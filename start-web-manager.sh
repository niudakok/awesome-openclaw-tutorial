#!/bin/zsh

# OpenClaw Web 管理界面启动脚本

echo "🦞 OpenClaw Web 管理界面"
echo "========================"
echo ""

# 检查 node_modules
if [ ! -d "openclaw-manager-web/node_modules" ]; then
    echo "📦 首次运行，正在安装依赖..."
    cd openclaw-manager-web
    npm install
    cd ..
    echo ""
fi

echo "🚀 启动 Web 管理界面..."
echo ""
echo "前端: http://localhost:3000"
echo "后端: http://localhost:3001"
echo ""
echo "按 Ctrl+C 停止服务"
echo ""

cd openclaw-manager-web
npm start
