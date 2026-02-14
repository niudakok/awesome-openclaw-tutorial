#!/bin/bash
# OpenClaw 配置备份脚本
# 自动备份OpenClaw配置文件

# 配置
OPENCLAW_DIR="$HOME/.openclaw"
BACKUP_DIR="$HOME/openclaw-backups"
RETENTION_DAYS=30

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 生成备份文件名
BACKUP_FILE="$BACKUP_DIR/openclaw-$(date +%Y%m%d-%H%M%S).tar.gz"

# 执行备份
echo "开始备份OpenClaw配置..."
tar -czf "$BACKUP_FILE" \
    --exclude="$OPENCLAW_DIR/logs" \
    --exclude="$OPENCLAW_DIR/cache" \
    "$OPENCLAW_DIR"

if [ $? -eq 0 ]; then
    echo "✅ 备份成功：$BACKUP_FILE"
    
    # 计算备份大小
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "备份大小：$SIZE"
    
    # 清理旧备份
    echo "清理超过 $RETENTION_DAYS 天的旧备份..."
    find "$BACKUP_DIR" -name "openclaw-*.tar.gz" -mtime +$RETENTION_DAYS -delete
    
    # 显示当前备份列表
    echo "当前备份列表："
    ls -lh "$BACKUP_DIR"/openclaw-*.tar.gz
else
    echo "❌ 备份失败"
    exit 1
fi
