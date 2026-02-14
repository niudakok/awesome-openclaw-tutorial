#!/bin/bash
# OpenClaw 教程链接检查脚本
# 用于验证所有Markdown文件中的链接

set -e

echo "🔍 OpenClaw 教程链接检查"
echo "========================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 统计变量
TOTAL_LINKS=0
VALID_LINKS=0
INVALID_LINKS=0
INTERNAL_LINKS=0
EXTERNAL_LINKS=0

# 临时文件
TEMP_FILE=$(mktemp)
RESULTS_FILE=$(mktemp)

# 清理函数
cleanup() {
    rm -f "$TEMP_FILE" "$RESULTS_FILE"
}
trap cleanup EXIT

echo "📝 提取所有链接..."

# 提取所有Markdown文件中的链接
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | while read -r file; do
    # 提取Markdown链接 [text](url)
    grep -oP '\[.*?\]\(\K[^)]+' "$file" 2>/dev/null | while read -r link; do
        echo "$file|$link" >> "$TEMP_FILE"
    done
done

if [ ! -f "$TEMP_FILE" ] || [ ! -s "$TEMP_FILE" ]; then
    echo "❌ 未找到任何链接"
    exit 1
fi

TOTAL_LINKS=$(wc -l < "$TEMP_FILE")
echo "✅ 找到 $TOTAL_LINKS 个链接"
echo ""

echo "🔎 开始验证链接..."
echo ""

# 验证链接
while IFS='|' read -r file link; do
    # 跳过锚点链接
    if [[ $link == \#* ]]; then
        continue
    fi
    
    # 判断是内部链接还是外部链接
    if [[ $link == http* ]]; then
        # 外部链接
        EXTERNAL_LINKS=$((EXTERNAL_LINKS + 1))
        
        # 检查HTTP状态码
        status=$(curl -o /dev/null -s -w "%{http_code}" -L --max-time 10 "$link" 2>/dev/null || echo "000")
        
        if [ "$status" -eq 200 ] || [ "$status" -eq 301 ] || [ "$status" -eq 302 ]; then
            echo -e "${GREEN}✅${NC} $link (HTTP $status)"
            VALID_LINKS=$((VALID_LINKS + 1))
            echo "$file|$link|VALID|$status" >> "$RESULTS_FILE"
        else
            echo -e "${RED}❌${NC} $link (HTTP $status)"
            echo -e "   ${YELLOW}位置:${NC} $file"
            INVALID_LINKS=$((INVALID_LINKS + 1))
            echo "$file|$link|INVALID|$status" >> "$RESULTS_FILE"
        fi
    else
        # 内部链接
        INTERNAL_LINKS=$((INTERNAL_LINKS + 1))
        
        # 获取文件所在目录
        dir=$(dirname "$file")
        
        # 构建完整路径
        if [[ $link == /* ]]; then
            # 绝对路径
            full_path=".$link"
        else
            # 相对路径
            full_path="$dir/$link"
        fi
        
        # 规范化路径
        full_path=$(realpath -m "$full_path" 2>/dev/null || echo "$full_path")
        
        # 检查文件是否存在
        if [ -f "$full_path" ] || [ -d "$full_path" ]; then
            echo -e "${GREEN}✅${NC} $link"
            VALID_LINKS=$((VALID_LINKS + 1))
            echo "$file|$link|VALID|EXISTS" >> "$RESULTS_FILE"
        else
            echo -e "${RED}❌${NC} $link"
            echo -e "   ${YELLOW}位置:${NC} $file"
            echo -e "   ${YELLOW}完整路径:${NC} $full_path"
            INVALID_LINKS=$((INVALID_LINKS + 1))
            echo "$file|$link|INVALID|NOT_FOUND" >> "$RESULTS_FILE"
        fi
    fi
done < "$TEMP_FILE"

echo ""
echo "========================"
echo "📊 验证结果统计"
echo "========================"
echo ""
echo "总链接数: $TOTAL_LINKS"
echo "  - 内部链接: $INTERNAL_LINKS"
echo "  - 外部链接: $EXTERNAL_LINKS"
echo ""
echo -e "${GREEN}有效链接: $VALID_LINKS${NC}"
echo -e "${RED}无效链接: $INVALID_LINKS${NC}"
echo ""

if [ $INVALID_LINKS -eq 0 ]; then
    echo -e "${GREEN}🎉 所有链接验证通过！${NC}"
    exit 0
else
    echo -e "${RED}⚠️  发现 $INVALID_LINKS 个无效链接${NC}"
    echo ""
    echo "详细结果已保存到: $RESULTS_FILE"
    echo "请修复这些链接后重新运行验证"
    exit 1
fi
