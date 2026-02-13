#!/bin/zsh

echo "🔍 验证多 Gateway 配置"
echo "======================"
echo ""

echo "1️⃣  检查 Profile 目录"
for profile in main-assistant content-creator tech-dev ai-news; do
    if [ -d "$HOME/.openclaw-$profile" ]; then
        echo "  ✅ $profile"
    else
        echo "  ❌ $profile (目录不存在)"
    fi
done

echo ""
echo "2️⃣  检查配置文件"
for profile in main-assistant content-creator tech-dev ai-news; do
    config="$HOME/.openclaw-$profile/openclaw.json"
    if [ -f "$config" ]; then
        port=$(jq -r '.gateway.port' "$config")
        agent=$(jq -r '.agents.list[0].id' "$config")
        account=$(jq -r '.channels.feishu.accounts | keys[0]' "$config")
        echo "  ✅ $profile: 端口=$port, Agent=$agent, 账号=$account"
    else
        echo "  ❌ $profile (配置文件不存在)"
    fi
done

echo ""
echo "3️⃣  检查进程状态"
gateway_count=$(ps aux | grep "openclaw-gateway" | grep -v grep | wc -l | tr -d ' ')
echo "  运行中的 Gateway 进程: $gateway_count"

echo ""
echo "4️⃣  检查端口监听"
for port in 18789 18790 18791 18792; do
    if lsof -i ":$port" > /dev/null 2>&1; then
        echo "  ✅ 端口 $port 已监听"
    else
        echo "  ❌ 端口 $port 未监听"
    fi
done

echo ""
echo "5️⃣  检查日志文件"
for profile in main-assistant content-creator tech-dev ai-news; do
    log="logs-$profile.log"
    if [ -f "$log" ]; then
        size=$(ls -lh "$log" | awk '{print $5}')
        echo "  ✅ $log ($size)"
    else
        echo "  ❌ $log (不存在)"
    fi
done

echo ""
echo "6️⃣  检查飞书连接状态"
for profile in main-assistant content-creator tech-dev ai-news; do
    log="logs-$profile.log"
    if grep -q "WebSocket client started" "$log" 2>/dev/null; then
        echo "  ✅ $profile: 飞书已连接"
    else
        echo "  ❌ $profile: 飞书未连接"
    fi
done

echo ""
echo "======================"
echo "✅ 验证完成"
echo ""
echo "如果所有检查都通过，说明配置成功！"
echo ""
echo "下一步："
echo "  1. 在飞书群组中 @ 对应的机器人测试"
echo "  2. 观察日志: tail -f logs-<profile>.log"
echo "  3. 检查每个群组是否使用了正确的 agent"
echo ""
