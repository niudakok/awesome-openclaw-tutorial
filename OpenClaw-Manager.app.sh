#!/bin/bash

# OpenClaw Gateway 图形管理工具
# 使用 AppleScript 创建原生 macOS 界面

# 获取脚本所在目录
if [ -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
    SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
fi

# 如果在 .app 包内运行，调整路径
if [[ "$SCRIPT_DIR" == *".app/Contents/MacOS"* ]]; then
    RESOURCES_DIR="$SCRIPT_DIR/../Resources"
else
    RESOURCES_DIR="$SCRIPT_DIR"
fi

# 主菜单函数
show_main_menu() {
    result=$(osascript 2>&1 << 'EOF'
tell application "System Events"
    activate
    try
        set theChoice to button returned of (display dialog "OpenClaw Gateway 管理器

选择操作：" buttons {"退出", "查看状态", "管理服务"} default button "查看状态" with title "OpenClaw Manager" with icon note)
        return theChoice
    on error
        return "退出"
    end try
end tell
EOF
)
    
    choice=$(echo "$result" | tail -1)
    
    case "$choice" in
        "查看状态")
            show_status
            ;;
        "管理服务")
            show_service_menu
            ;;
        *)
            exit 0
            ;;
    esac
}

# 查看状态函数
show_status() {
    # 获取状态信息
    status_text=""
    
    profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")
    ports=(18789 18790 18791 18792)
    names=("主助理" "内容创作助手" "技术开发助手" "AI资讯助手")
    
    for i in {0..3}; do
        profile="${profiles[$i]}"
        port="${ports[$i]}"
        name="${names[$i]}"
        
        # 检查服务状态
        if launchctl list | grep -q "com.openclaw.$profile"; then
            status="✅ 运行中"
        else
            status="❌ 未运行"
        fi
        
        # 检查端口
        if lsof -i ":$port" > /dev/null 2>&1; then
            port_status="✅"
        else
            port_status="❌"
        fi
        
        status_text="$status_text
$name ($profile)
  服务: $status
  端口 $port: $port_status
"
    done
    
    osascript << EOF
tell application "System Events"
    activate
    display dialog "$status_text" buttons {"查看日志", "返回"} default button "返回" with title "服务状态" with icon note
    set theChoice to button returned of result
    
    if theChoice is "查看日志" then
        return "logs"
    else
        return "back"
    end if
end tell
EOF
    
    result=$?
    if [ $result -eq 0 ]; then
        choice=$(osascript -e 'return button returned of result')
        if [ "$choice" = "查看日志" ]; then
            show_logs_menu
        else
            show_main_menu
        fi
    else
        show_main_menu
    fi
}

# 服务管理菜单
show_service_menu() {
    result=$(osascript 2>&1 << 'EOF'
tell application "System Events"
    activate
    try
        set theChoice to button returned of (display dialog "服务管理

选择操作：" buttons {"返回", "配置保活", "控制服务"} default button "控制服务" with title "服务管理" with icon note)
        return theChoice
    on error
        return "返回"
    end try
end tell
EOF
)
    
    choice=$(echo "$result" | tail -1)
    
    case "$choice" in
        "配置保活")
            setup_launchd
            ;;
        "控制服务")
            show_control_menu
            ;;
        *)
            show_main_menu
            ;;
    esac
}

# 控制服务菜单
show_control_menu() {
    result=$(osascript 2>&1 << 'EOF'
tell application "System Events"
    activate
    try
        set theChoice to button returned of (display dialog "控制服务

选择操作：" buttons {"返回", "启动所有", "停止所有", "重启所有"} default button "启动所有" with title "控制服务" with icon note)
        return theChoice
    on error
        return "返回"
    end try
end tell
EOF
)
    
    choice=$(echo "$result" | tail -1)
    
    case "$choice" in
        "启动所有")
            start_all
            ;;
        "停止所有")
            stop_all
            ;;
        "重启所有")
            restart_all
            ;;
        *)
            show_service_menu
            ;;
    esac
}

# 配置保活
setup_launchd() {
    osascript << EOF
tell application "System Events"
    activate
    display dialog "正在配置保活服务...

这将：
• 创建 launchd 配置文件
• 启动所有 Gateway
• 配置开机自启动
• 配置自动重启

是否继续？" buttons {"取消", "继续"} default button "继续" with title "配置保活" with icon caution
    set theChoice to button returned of result
    return theChoice
end tell
EOF
    
    if [ $? -eq 0 ]; then
        # 执行配置
        if [ -f "$RESOURCES_DIR/setup-launchd.sh" ]; then
            cd "$RESOURCES_DIR"
            bash setup-launchd.sh > /tmp/openclaw-setup.log 2>&1
        else
            cd "$SCRIPT_DIR"
            bash setup-launchd.sh > /tmp/openclaw-setup.log 2>&1
        fi
        
        if [ $? -eq 0 ]; then
            osascript -e 'tell application "System Events" to display dialog "✅ 配置成功！

所有 Gateway 已启动并配置为：
• 开机自动启动
• 崩溃后自动重启

日志位置：
~/.openclaw-<profile>/stdout.log" buttons {"确定"} default button "确定" with title "配置成功" with icon note'
        else
            osascript -e 'tell application "System Events" to display dialog "❌ 配置失败

请查看日志：
/tmp/openclaw-setup.log" buttons {"确定"} default button "确定" with title "配置失败" with icon stop'
        fi
    fi
    
    show_main_menu
}

# 启动所有服务
start_all() {
    osascript -e 'tell application "System Events" to display dialog "正在启动所有服务..." buttons {} giving up after 1 with title "启动中" with icon note'
    
    profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")
    
    for profile in "${profiles[@]}"; do
        plist_file="$HOME/Library/LaunchAgents/com.openclaw.$profile.plist"
        if [ -f "$plist_file" ]; then
            launchctl load "$plist_file" 2>/dev/null
        fi
    done
    
    sleep 2
    
    osascript -e 'tell application "System Events" to display dialog "✅ 所有服务已启动" buttons {"确定"} default button "确定" with title "启动完成" with icon note'
    
    show_main_menu
}

# 停止所有服务
stop_all() {
    osascript << EOF
tell application "System Events"
    activate
    display dialog "确定要停止所有服务吗？" buttons {"取消", "停止"} default button "取消" with title "停止服务" with icon caution
    set theChoice to button returned of result
    return theChoice
end tell
EOF
    
    if [ $? -eq 0 ]; then
        profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")
        
        for profile in "${profiles[@]}"; do
            plist_file="$HOME/Library/LaunchAgents/com.openclaw.$profile.plist"
            if [ -f "$plist_file" ]; then
                launchctl unload "$plist_file" 2>/dev/null
            fi
        done
        
        osascript -e 'tell application "System Events" to display dialog "✅ 所有服务已停止" buttons {"确定"} default button "确定" with title "停止完成" with icon note'
    fi
    
    show_main_menu
}

# 重启所有服务
restart_all() {
    osascript -e 'tell application "System Events" to display dialog "正在重启所有服务..." buttons {} giving up after 1 with title "重启中" with icon note'
    
    profiles=("main-assistant" "content-creator" "tech-dev" "ai-news")
    
    for profile in "${profiles[@]}"; do
        plist_file="$HOME/Library/LaunchAgents/com.openclaw.$profile.plist"
        if [ -f "$plist_file" ]; then
            launchctl unload "$plist_file" 2>/dev/null
            sleep 1
            launchctl load "$plist_file" 2>/dev/null
        fi
    done
    
    sleep 2
    
    osascript -e 'tell application "System Events" to display dialog "✅ 所有服务已重启" buttons {"确定"} default button "确定" with title "重启完成" with icon note'
    
    show_main_menu
}

# 日志查看菜单
show_logs_menu() {
    choice=$(osascript << EOF
tell application "System Events"
    activate
    set theChoice to button returned of (display dialog "选择要查看的日志：" buttons {"返回", "主助理", "内容创作", "技术开发", "AI资讯"} default button "主助理" with title "查看日志" with icon note)
    return theChoice
end tell
EOF
)

    case "$choice" in
        "主助理")
            open_log "main-assistant"
            ;;
        "内容创作")
            open_log "content-creator"
            ;;
        "技术开发")
            open_log "tech-dev"
            ;;
        "AI资讯")
            open_log "ai-news"
            ;;
        "返回")
            show_main_menu
            ;;
    esac
}

# 打开日志
open_log() {
    profile=$1
    log_file="$HOME/.openclaw-$profile/stdout.log"
    
    if [ -f "$log_file" ]; then
        open -a Console "$log_file"
    else
        osascript -e "tell application \"System Events\" to display dialog \"日志文件不存在：
$log_file\" buttons {\"确定\"} default button \"确定\" with title \"日志不存在\" with icon stop"
    fi
    
    show_logs_menu
}

# 启动主菜单
show_main_menu
