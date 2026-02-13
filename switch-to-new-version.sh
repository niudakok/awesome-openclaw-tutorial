#!/bin/zsh

echo "🔄 切换到新版本 OpenClaw Manager"
echo "=================================="
echo ""

# 检查是否有旧版本在运行
OLD_PID=$(lsof -ti :3000,3001 2>/dev/null)
if [ ! -z "$OLD_PID" ]; then
    echo "⚠️  检测到旧版本正在运行（端口 3000/3001）"
    echo "正在停止..."
    kill $OLD_PID 2>/dev/null
    sleep 2
    echo "✅ 已停止旧版本"
    echo ""
fi

# 进入新版本目录
cd openclaw-manager

# 检查是否已安装依赖
if [ ! -d "node_modules" ]; then
    echo "📦 首次运行，正在安装依赖..."
    npm install
    echo ""
fi

echo "🚀 启动新版本..."
echo ""
echo "✨ 新功能："
echo "   - ➕ 创建/编辑/删除 Gateway"
echo "   - 🎨 自定义模型配置"
echo "   - 📝 在线编辑 Agent 人格（SOUL.md）"
echo "   - 🔍 自动发现 Gateway 实例"
echo ""
echo "📖 使用指南: openclaw-manager/USAGE-GUIDE.md"
echo ""
echo "🌐 访问地址: http://localhost:3000"
echo ""
echo "按 Ctrl+C 停止服务"
echo "=================================="
echo ""

npm start
