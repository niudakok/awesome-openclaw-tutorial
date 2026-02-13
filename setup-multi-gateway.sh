#!/bin/zsh

# OpenClaw 多 Gateway 配置脚本
# 使用 --profile 参数创建 4 个独立的 Gateway 实例

set -e  # 遇到错误立即退出

echo "🚀 OpenClaw 多 Gateway 配置脚本"
echo "=================================="
echo ""
echo "本脚本将创建 4 个独立的 Gateway 实例："
echo "  1. main-assistant  (端口 18789) - 主助理"
echo "  2. content-creator (端口 18790) - 内容创作助手"
echo "  3. tech-dev        (端口 18791) - 技术开发助手"
echo "  4. ai-news         (端口 18792) - AI资讯助手"
echo ""
echo "每个实例使用独立的 profile，互不干扰"
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
    echo "   ✅ 已备份到 ~/.openclaw/openclaw.json.backup.*"
else
    echo "   ⚠️  没有找到现有配置文件"
fi

# 定义 4 个 profile 配置
declare -A PROFILES=(
    ["main-assistant"]="18789:oc_053c93f17fc47e587df58c776f831de5:main-agent:主助理"
    ["content-creator"]="18790:oc_b59b5a7ec4f4605ef19c7381e18441dc:content-agent:内容创作助手"
    ["tech-dev"]="18791:oc_497bcc045e75228209e5030481a6fef7:tech-agent:技术开发助手"
    ["ai-news"]="18792:oc_bd1074d29ace112ebbd9cf15a2c9fc2d:ainews-agent:AI资讯助手"
)

declare -A FEISHU_ACCOUNTS=(
    ["main-assistant"]="cli_YOUR_MAIN_APP_ID:YOUR_MAIN_APP_SECRET"
    ["content-creator"]="cli_YOUR_CONTENT_APP_ID:YOUR_CONTENT_APP_SECRET"
    ["tech-dev"]="cli_YOUR_TECH_APP_ID:YOUR_TECH_APP_SECRET"
    ["ai-news"]="cli_YOUR_NEWS_APP_ID:YOUR_NEWS_APP_SECRET"
)

echo ""
echo "3️⃣  创建 Profile 配置..."
echo ""

for profile in "${!PROFILES[@]}"; do
    IFS=':' read -r port group_id agent_id bot_name <<< "${PROFILES[$profile]}"
    IFS=':' read -r app_id app_secret <<< "${FEISHU_ACCOUNTS[$profile]}"
    
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
    fi
    
    # 使用 jq 修改配置（如果安装了 jq）
    if command -v jq &> /dev/null; then
        echo "   使用 jq 修改配置..."
        
        # 读取配置
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
        
        # 设置默认 agent
        jq ".agents.defaults.id = \"$agent_id\"" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        
        # 移除 bindings（单账号模式不需要）
        jq "del(.bindings)" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        
        # 设置群组免 @ 模式
        jq ".channels.feishu.groups = {
            \"$group_id\": {
                \"requireMention\": false
            }
        }" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        
        echo "   ✅ 配置已创建"
    else
        echo "   ⚠️  未安装 jq，需要手动配置"
        echo "   请安装 jq: brew install jq"
    fi
    
    echo ""
done

echo ""
echo "4️⃣  创建管理脚本..."

# 创建启动脚本
cat > start-all-gateways.sh << 'EOF'
#!/bin/bash

# 启动所有 Gateway 实例

echo "🚀 启动所有 Gateway 实例..."
echo ""

# 定义 profiles
profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")

for profile in "${profiles[@]}"; do
    echo "启动 $profile..."
    openclaw --profile "$profile" gateway run &
    sleep 2
done

echo ""
echo "✅ 所有 Gateway 已启动"
echo ""
echo "查看状态: ./check-gateways.sh"
echo "停止所有: ./stop-all-gateways.sh"
EOF

chmod +x start-all-gateways.sh

# 创建停止脚本
cat > stop-all-gateways.sh << 'EOF'
#!/bin/bash

# 停止所有 Gateway 实例

echo "🛑 停止所有 Gateway 实例..."
echo ""

# 查找所有 openclaw gateway 进程
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
#!/bin/bash

# 检查所有 Gateway 状态

echo "📊 Gateway 状态检查"
echo "===================="
echo ""

# 定义 profiles 和端口
declare -A PROFILES=(
    ["main-assistant"]="18789"
    ["content-creator"]="18790"
    ["tech-dev"]="18791"
    ["ai-news"]="18792"
)

for profile in "${!PROFILES[@]}"; do
    port="${PROFILES[$profile]}"
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
done

echo "详细进程信息:"
ps aux | grep "openclaw.*gateway" | grep -v grep || echo "没有运行中的 Gateway"
EOF

chmod +x check-gateways.sh

# 创建单个启动脚本
for profile in "${!PROFILES[@]}"; do
    IFS=':' read -r port group_id agent_id bot_name <<< "${PROFILES[$profile]}"
    
    cat > "start-$profile.sh" << EOF
#!/bin/bash
# 启动 $profile Gateway

echo "🚀 启动 $profile Gateway..."
echo "   端口: $port"
echo "   代理: $agent_id"
echo "   机器人: $bot_name"
echo ""

openclaw --profile "$profile" gateway run
EOF
    
    chmod +x "start-$profile.sh"
done

echo "   ✅ 管理脚本已创建:"
echo "      - start-all-gateways.sh    启动所有"
echo "      - stop-all-gateways.sh     停止所有"
echo "      - check-gateways.sh        检查状态"
echo "      - start-<profile>.sh       启动单个"

echo ""
echo "=================================="
echo "✅ 配置完成！"
echo ""
echo "下一步操作："
echo ""
echo "1. 检查配置文件（可选）："
echo "   cat ~/.openclaw-main-assistant/openclaw.json"
echo ""
echo "2. 启动所有 Gateway："
echo "   ./start-all-gateways.sh"
echo ""
echo "3. 或者单独启动："
echo "   ./start-main-assistant.sh"
echo "   ./start-content-creator.sh"
echo "   ./start-tech-dev.sh"
echo "   ./start-ai-news.sh"
echo ""
echo "4. 检查状态："
echo "   ./check-gateways.sh"
echo ""
echo "5. 停止所有："
echo "   ./stop-all-gateways.sh"
echo ""
echo "⚠️  注意事项："
echo "   - 每个 Gateway 约占用 400MB 内存"
echo "   - 4 个 Gateway 总共约 1.6GB"
echo "   - 确保端口 18789-18792 未被占用"
echo "   - 建议使用 tmux 或 screen 在后台运行"
echo ""
