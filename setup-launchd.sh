#!/bin/zsh

# OpenClaw 多 Gateway 保活配置脚本
# 使用 macOS launchd 实现开机自启动和自动重启

echo "🚀 配置 OpenClaw 多 Gateway 保活"
echo "===================================="
echo ""

# 检查 openclaw 路径
OPENCLAW_PATH=$(which openclaw)
if [ -z "$OPENCLAW_PATH" ]; then
    echo "❌ 未找到 openclaw 命令"
    echo "请先安装 OpenClaw"
    exit 1
fi

echo "✅ OpenClaw 路径: $OPENCLAW_PATH"
echo ""

# 定义 4 个 profiles
profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")
ports=(18789 18790 18791 18792)

# 创建 LaunchAgents 目录
mkdir -p ~/Library/LaunchAgents

echo "📝 创建 launchd 配置文件..."
echo ""

for i in {1..4}; do
    profile="${profiles[$i]}"
    port="${ports[$i]}"
    
    plist_file="$HOME/Library/LaunchAgents/com.openclaw.$profile.plist"
    
    echo "创建 $profile 配置..."
    
    cat > "$plist_file" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.openclaw.$profile</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>$OPENCLAW_PATH</string>
        <string>--profile</string>
        <string>$profile</string>
        <string>gateway</string>
        <string>run</string>
        <string>--port</string>
        <string>$port</string>
    </array>
    
    <key>RunAtLoad</key>
    <true/>
    
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
    </dict>
    
    <key>StandardOutPath</key>
    <string>$HOME/.openclaw-$profile/stdout.log</string>
    
    <key>StandardErrorPath</key>
    <string>$HOME/.openclaw-$profile/stderr.log</string>
    
    <key>WorkingDirectory</key>
    <string>$HOME</string>
    
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
    
    <key>ThrottleInterval</key>
    <integer>10</integer>
</dict>
</plist>
EOF
    
    echo "  ✅ 已创建 $plist_file"
done

echo ""
echo "🔧 加载 launchd 服务..."
echo ""

for profile in "${profiles[@]}"; do
    plist_file="$HOME/Library/LaunchAgents/com.openclaw.$profile.plist"
    
    # 先卸载（如果已存在）
    launchctl unload "$plist_file" 2>/dev/null
    
    # 加载服务
    launchctl load "$plist_file"
    
    if [ $? -eq 0 ]; then
        echo "  ✅ $profile 服务已加载"
    else
        echo "  ❌ $profile 服务加载失败"
    fi
done

echo ""
echo "===================================="
echo "✅ 配置完成！"
echo ""
echo "📋 服务说明："
echo ""
echo "1. 开机自启动：所有 Gateway 会在开机时自动启动"
echo "2. 自动重启：如果进程崩溃，会在 10 秒后自动重启"
echo "3. 日志位置："
echo "   - stdout: ~/.openclaw-<profile>/stdout.log"
echo "   - stderr: ~/.openclaw-<profile>/stderr.log"
echo ""
echo "📝 管理命令："
echo ""
echo "# 查看服务状态"
echo "launchctl list | grep openclaw"
echo ""
echo "# 停止某个服务"
echo "launchctl unload ~/Library/LaunchAgents/com.openclaw.main-assistant.plist"
echo ""
echo "# 启动某个服务"
echo "launchctl load ~/Library/LaunchAgents/com.openclaw.main-assistant.plist"
echo ""
echo "# 重启某个服务"
echo "launchctl unload ~/Library/LaunchAgents/com.openclaw.main-assistant.plist"
echo "launchctl load ~/Library/LaunchAgents/com.openclaw.main-assistant.plist"
echo ""
echo "# 停止所有服务"
echo "./stop-launchd.sh"
echo ""
echo "# 查看日志"
echo "tail -f ~/.openclaw-main-assistant/stdout.log"
echo ""
