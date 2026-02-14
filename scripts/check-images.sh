#!/bin/bash
# OpenClaw 教程图片链接检查脚本
# 用于检查教程中是否存在本地路径的图片

set -e

echo "🖼️  OpenClaw 教程图片链接检查"
echo "=============================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 错误计数
ERROR_COUNT=0

# 检查1：本地绝对路径（/Users/）
echo "检查1: 本地绝对路径（/Users/）..."
LOCAL_PATHS=$(grep -rn "/Users/" docs/ 2>/dev/null | grep -E "\.(png|jpg|jpeg|gif|svg)" || true)
if [ -n "$LOCAL_PATHS" ]; then
    echo -e "${RED}❌ 发现本地路径图片：${NC}"
    echo "$LOCAL_PATHS"
    ERROR_COUNT=$((ERROR_COUNT + 1))
else
    echo -e "${GREEN}✅ 未发现本地路径图片${NC}"
fi
echo ""

# 检查2：Typora 临时路径
echo "检查2: Typora 临时路径..."
TYPORA_PATHS=$(grep -rn "typora-user-images" docs/ 2>/dev/null || true)
if [ -n "$TYPORA_PATHS" ]; then
    echo -e "${RED}❌ 发现 Typora 临时图片：${NC}"
    echo "$TYPORA_PATHS"
    ERROR_COUNT=$((ERROR_COUNT + 1))
else
    echo -e "${GREEN}✅ 未发现 Typora 临时图片${NC}"
fi
echo ""

# 检查3：微信临时路径
echo "检查3: 微信临时路径..."
WECHAT_PATHS=$(grep -rn "xinWeChat" docs/ 2>/dev/null || true)
if [ -n "$WECHAT_PATHS" ]; then
    echo -e "${RED}❌ 发现微信临时图片：${NC}"
    echo "$WECHAT_PATHS"
    ERROR_COUNT=$((ERROR_COUNT + 1))
else
    echo -e "${GREEN}✅ 未发现微信临时图片${NC}"
fi
echo ""

# 检查4：统计图片使用情况
echo "检查4: 图片使用统计..."
echo ""
echo "📊 图片链接类型统计："

# 相对路径图片
RELATIVE_COUNT=$(grep -rh "!\[.*\](\./" docs/ 2>/dev/null | wc -l | tr -d ' ')
echo "  - 相对路径: $RELATIVE_COUNT 个"

# HTTP/HTTPS 图片
HTTP_COUNT=$(grep -rh "!\[.*\](http" docs/ 2>/dev/null | wc -l | tr -d ' ')
echo "  - HTTP/HTTPS: $HTTP_COUNT 个"

# 待上传图片（TODO 标记）
TODO_COUNT=$(grep -rh "TODO.*图片" docs/ 2>/dev/null | wc -l | tr -d ' ')
echo "  - 待上传（TODO）: $TODO_COUNT 个"

echo ""

# 检查5：图片文件是否存在
echo "检查5: 检查相对路径图片文件是否存在..."
MISSING_IMAGES=0
while IFS= read -r line; do
    # 提取图片路径
    IMAGE_PATH=$(echo "$line" | sed -n 's/.*!\[.*\](\(\.\/[^)]*\)).*/\1/p')
    if [ -n "$IMAGE_PATH" ]; then
        # 转换为实际路径
        ACTUAL_PATH="docs/${IMAGE_PATH#./}"
        if [ ! -f "$ACTUAL_PATH" ]; then
            if [ $MISSING_IMAGES -eq 0 ]; then
                echo -e "${YELLOW}⚠️  以下图片文件不存在：${NC}"
            fi
            echo "  - $ACTUAL_PATH"
            MISSING_IMAGES=$((MISSING_IMAGES + 1))
        fi
    fi
done < <(grep -rh "!\[.*\](\./" docs/ 2>/dev/null || true)

if [ $MISSING_IMAGES -eq 0 ]; then
    echo -e "${GREEN}✅ 所有相对路径图片文件都存在${NC}"
else
    echo -e "${YELLOW}⚠️  发现 $MISSING_IMAGES 个图片文件不存在（可能是待上传）${NC}"
fi
echo ""

# 总结
echo "=============================="
if [ $ERROR_COUNT -eq 0 ]; then
    echo -e "${GREEN}✅ 验证通过！未发现本地路径图片。${NC}"
    if [ $MISSING_IMAGES -gt 0 ]; then
        echo -e "${YELLOW}⚠️  但有 $MISSING_IMAGES 个图片文件待上传。${NC}"
    fi
    exit 0
else
    echo -e "${RED}❌ 发现 $ERROR_COUNT 类错误！${NC}"
    exit 1
fi
