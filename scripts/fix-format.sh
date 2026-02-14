#!/bin/bash
# OpenClaw 教程格式自动修复脚本
# 修复中英文混用格式问题

set -e

echo "🔧 OpenClaw 教程格式自动修复"
echo "============================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 统计
FIXED_FILES=0
FIXED_SPACING=0

echo "🔧 修复中英文混用格式..."
echo ""

# 查找所有 Markdown 文件
FILES=$(find docs/ -name "*.md" -type f)

for FILE in $FILES; do
    # 创建临时文件
    TEMP_FILE="${FILE}.tmp"
    MODIFIED=false
    
    # 修复常见的中英文混用问题
    # 1. 使用OpenClaw -> 使用 OpenClaw
    if grep -q "使用OpenClaw" "$FILE" 2>/dev/null; then
        sed 's/使用OpenClaw/使用 OpenClaw/g' "$FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$FILE"
        MODIFIED=true
    fi
    
    # 2. 安装OpenClaw -> 安装 OpenClaw
    if grep -q "安装OpenClaw" "$FILE" 2>/dev/null; then
        sed 's/安装OpenClaw/安装 OpenClaw/g' "$FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$FILE"
        MODIFIED=true
    fi
    
    # 3. 配置OpenClaw -> 配置 OpenClaw
    if grep -q "配置OpenClaw" "$FILE" 2>/dev/null; then
        sed 's/配置OpenClaw/配置 OpenClaw/g' "$FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$FILE"
        MODIFIED=true
    fi
    
    # 4. OpenClaw命令 -> OpenClaw 命令
    if grep -q "OpenClaw命令" "$FILE" 2>/dev/null; then
        sed 's/OpenClaw命令/OpenClaw 命令/g' "$FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$FILE"
        MODIFIED=true
    fi
    
    # 5. OpenClaw配置 -> OpenClaw 配置
    if grep -q "OpenClaw配置" "$FILE" 2>/dev/null; then
        sed 's/OpenClaw配置/OpenClaw 配置/g' "$FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$FILE"
        MODIFIED=true
    fi
    
    # 6. Skills安装 -> Skills 安装
    if grep -q "Skills安装" "$FILE" 2>/dev/null; then
        sed 's/Skills安装/Skills 安装/g' "$FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$FILE"
        MODIFIED=true
    fi
    
    # 7. Skills配置 -> Skills 配置
    if grep -q "Skills配置" "$FILE" 2>/dev/null; then
        sed 's/Skills配置/Skills 配置/g' "$FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$FILE"
        MODIFIED=true
    fi
    
    # 8. API密钥 -> API 密钥
    if grep -q "API密钥" "$FILE" 2>/dev/null; then
        sed 's/API密钥/API 密钥/g' "$FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$FILE"
        MODIFIED=true
    fi
    
    # 9. APIKey -> API Key (但要避免在代码中的 apiKey)
    if grep -q "APIKey" "$FILE" 2>/dev/null; then
        # 只替换非代码块中的 APIKey
        sed 's/\([^`]\)APIKey\([^`]\)/\1API Key\2/g' "$FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$FILE"
        MODIFIED=true
    fi
    
    if [ "$MODIFIED" = true ]; then
        echo -e "${GREEN}✅ 修复: $FILE${NC}"
        FIXED_FILES=$((FIXED_FILES + 1))
    fi
done

echo ""
echo "============================"
echo -e "${GREEN}✅ 修复完成！${NC}"
echo ""
echo "统计信息："
echo "  - 修复文件: $FIXED_FILES 个"
echo ""
echo -e "${YELLOW}💡 提示：${NC}"
echo "  1. 已修复常见的中英文混用格式问题"
echo "  2. 代码块语言标注需要手动添加"
echo "  3. 运行 check-format.sh 验证修复结果"
