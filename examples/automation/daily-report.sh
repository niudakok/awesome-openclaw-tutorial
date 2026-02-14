#!/bin/bash
# OpenClaw 每日AI日报自动推送脚本
# 使用方法：添加到crontab: 0 9 * * * ~/daily-report.sh

# 配置
OPENCLAW_BIN="openclaw"
CHANNEL="feishu"  # 或 telegram, wecom, dingtalk
LOG_FILE="$HOME/.openclaw/logs/daily-report.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 开始执行
log "开始生成每日AI日报"

# 生成日报内容
PROMPT="请生成今天的AI行业日报，包括：
1. 最新的AI技术动态（3-5条）
2. 重要的产品发布或更新
3. 行业趋势分析
4. 值得关注的研究论文

请用简洁的格式呈现，每条新闻包含标题、简介和链接。"

# 发送消息
if $OPENCLAW_BIN message send --channel "$CHANNEL" --message "$PROMPT"; then
    log "✅ 日报推送成功"
else
    log "❌ 日报推送失败"
    exit 1
fi

log "完成"
