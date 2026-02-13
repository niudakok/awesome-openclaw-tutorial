#!/bin/zsh

# OpenClaw 多 Gateway 配置脚本
# 使用 --profile 参数创建 4 个独立的 Gateway 实例

echo "🚀 OpenClaw 多 Gateway 配置脚本"
echo "=================================="
echo ""
echo "本脚本将创建 4 个独立的 Gateway 实例："
echo "  1. main-assistant  (端口 18789) - 主助理"
echo "  2. content-creator (端口 18790) - 内容创作助手"
echo "  3. tech-dev        (端口 18791) - 技术开发助手"
echo "  4. ai-news         (端口 18792) - AI资讯助手"
echo ""

# 停止当前的 Gateway
echo "1️⃣  停止当前 Gateway..."
openclaw gateway stop 2>/dev/null || echo "   没有运行中的 Gateway"
sleep 2

# 备份当前配置
echo ""
echo "2️⃣  备份当前配置..."
if [ -f ~/.openclaw/openclaw.json ]; then
    cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%Y%m%d_%H%M%S)
    echo "   ✅ 已备份"
fi

echo ""
echo "3️⃣  创建 Profile 配置..."
echo ""

# 函数：创建单个 profile 配置
create_profile() {
    local profile=$1
    local port=$2
    local group_id=$3
    local agent_id=$4
    local bot_name=$5
    local app_id=$6
    local app_secret=$7
    
    echo "📝 配置 Profile: $profile"
    echo "   端口: $port"
    echo "   群组: $group_id"
    echo "   代理: $agent_id"
    echo "   机器人: $bot_name"
    
    # 创建 profile 目录
    profile_dir="$HOME/.openclaw-$profile"
    mkdir -p "$profile_dir"
    
    # 复制基础配置
    if [ -f ~/.openclaw/openclaw.json ]; then
        cp ~/.openclaw/openclaw.json "$profile_dir/openclaw.json"
        
        config_file="$profile_dir/openclaw.json"
        
        # 修改端口
        jq ".gateway.port = $port" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        
        # 只保留当前 profile 对应的飞书账号
        jq ".channels.feishu.accounts = {
            \"$profile\": {
                \"appId\": \"$app_id\",
                \"appSecret\": \"$app_secret\",
                \"botName\": \"$bot_name\",
                \"enabled\": true
            }
        }" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        
        # 移除 bindings（单账号模式不需要）
        jq "del(.bindings)" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        
        # 设置群组免 @ 模式
        jq ".channels.feishu.groups = {
            \"$group_id\": {
                \"requireMention\": false
            }
        }" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        
        # 只保留对应的 agent
        jq ".agents.list = [.agents.list[] | select(.id == \"$agent_id\")]" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        
        echo "   ✅ 配置已创建"
    fi
    
    echo ""
}

# 创建 4 个 profiles（请替换为你的实际 App ID 和 Secret）
create_profile "main-assistant" 18789 "oc_YOUR_MAIN_GROUP_ID" "main-agent" "主助理" "cli_YOUR_MAIN_APP_ID" "YOUR_MAIN_APP_SECRET"
create_profile "content-creator" 18790 "oc_YOUR_CONTENT_GROUP_ID" "content-agent" "内容创作助手" "cli_YOUR_CONTENT_APP_ID" "YOUR_CONTENT_APP_SECRET"
create_profile "tech-dev" 18791 "oc_YOUR_TECH_GROUP_ID" "tech-agent" "技术开发助手" "cli_YOUR_TECH_APP_ID" "YOUR_TECH_APP_SECRET"
create_profile "ai-news" 18792 "oc_YOUR_NEWS_GROUP_ID" "ainews-agent" "AI资讯助手" "cli_YOUR_NEWS_APP_ID" "YOUR_NEWS_APP_SECRET"

echo ""
echo "4️⃣  创建管理脚本..."

# 创建启动所有脚本
cat > start-all-gateways.sh << 'EOF'
#!/bin/zsh
echo "🚀 启动所有 Gateway 实例..."
echo ""

profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")

for profile in "${profiles[@]}"; do
    echo "启动 $profile..."
    openclaw --profile "$profile" gateway run > "logs-$profile.log" 2>&1 &
    sleep 2
done

echo ""
echo "✅ 所有 Gateway 已启动"
echo ""
echo "查看状态: ./check-gateways.sh"
echo "停止所有: ./stop-all-gateways.sh"
echo ""
echo "查看日志:"
echo "  tail -f logs-main-assistant.log"
echo "  tail -f logs-content-creator.log"
echo "  tail -f logs-tech-dev.log"
echo "  tail -f logs-ai-news.log"
EOF

chmod +x start-all-gateways.sh

# 创建停止所有脚本
cat > stop-all-gateways.sh << 'EOF'
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
EOF

chmod +x stop-all-gateways.sh

# 创建状态检查脚本
cat > check-gateways.sh << 'EOF'
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
EOF

chmod +x check-gateways.sh

# 创建单个启动脚本
cat > start-main-assistant.sh << 'EOF'
#!/bin/zsh
echo "🚀 启动 main-assistant Gateway..."
openclaw --profile "main-assistant" gateway run
EOF
chmod +x start-main-assistant.sh

cat > start-content-creator.sh << 'EOF'
#!/bin/zsh
echo "🚀 启动 content-creator Gateway..."
openclaw --profile "content-creator" gateway run
EOF
chmod +x start-content-creator.sh

cat > start-tech-dev.sh << 'EOF'
#!/bin/zsh
echo "🚀 启动 tech-dev Gateway..."
openclaw --profile "tech-dev" gateway run
EOF
chmod +x start-tech-dev.sh

cat > start-ai-news.sh << 'EOF'
#!/bin/zsh
echo "🚀 启动 ai-news Gateway..."
openclaw --profile "ai-news" gateway run
EOF
chmod +x start-ai-news.sh

echo "   ✅ 管理脚本已创建"

echo ""
echo "=================================="
echo "✅ 配置完成！"
echo ""
echo "下一步操作："
echo ""
echo "1. 启动所有 Gateway："
echo "   ./start-all-gateways.sh"
echo ""
echo "2. 检查状态："
echo "   ./check-gateways.sh"
echo ""
echo "3. 查看日志："
echo "   tail -f logs-main-assistant.log"
echo ""
echo "4. 停止所有："
echo "   ./stop-all-gateways.sh"
echo ""
