#!/bin/bash
# OpenClaw 教程格式检查脚本
# 检查中英文混用格式和代码块语言标注

set -e

echo "📝 OpenClaw 教程格式检查"
echo "========================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 统计
TOTAL_ISSUES=0
SPACING_ISSUES=0
CODE_BLOCK_ISSUES=0

echo "🔍 检查中英文混用格式..."
echo ""

# 检查中英文之间缺少空格的情况
# 匹配模式：中文字符后直接跟英文字母，或英文字母后直接跟中文字符
SPACING_PATTERN='[\u4e00-\u9fa5][a-zA-Z]|[a-zA-Z][\u4e00-\u9fa5]'

# 由于 grep 在 macOS 上对 Unicode 支持有限，我们使用更简单的检查
echo -e "${BLUE}检查常见的中英文混用问题...${NC}"

# 检查一些常见的错误模式
COMMON_ISSUES=$(grep -rn "使用OpenClaw\|安装OpenClaw\|配置OpenClaw\|OpenClaw命令\|OpenClaw配置\|Skills安装\|Skills配置\|API密钥\|APIKey" docs/ 2>/dev/null | grep -v "使用 OpenClaw\|安装 OpenClaw\|配置 OpenClaw\|OpenClaw 命令\|OpenClaw 配置\|Skills 安装\|Skills 配置\|API 密钥\|API Key" || true)

if [ -n "$COMMON_ISSUES" ]; then
    echo -e "${YELLOW}⚠️  发现中英文混用格式问题：${NC}"
    echo "$COMMON_ISSUES" | head -20
    SPACING_ISSUES=$(echo "$COMMON_ISSUES" | wc -l | tr -d ' ')
    echo ""
    echo -e "${YELLOW}共发现 $SPACING_ISSUES 处可能的格式问题${NC}"
else
    echo -e "${GREEN}✅ 未发现明显的中英文混用格式问题${NC}"
fi

echo ""
echo "🔍 检查代码块语言标注..."
echo ""

# 检查没有语言标注的代码块
# 匹配 ``` 后面没有语言标识的情况
CODE_BLOCKS_NO_LANG=$(grep -rn '^```$' docs/ 2>/dev/null || true)

if [ -n "$CODE_BLOCKS_NO_LANG" ]; then
    echo -e "${YELLOW}⚠️  发现未标注语言的代码块：${NC}"
    echo "$CODE_BLOCKS_NO_LANG" | head -20
    CODE_BLOCK_ISSUES=$(echo "$CODE_BLOCKS_NO_LANG" | wc -l | tr -d ' ')
    echo ""
    echo -e "${YELLOW}共发现 $CODE_BLOCK_ISSUES 处未标注语言的代码块${NC}"
else
    echo -e "${GREEN}✅ 所有代码块都已标注语言${NC}"
fi

echo ""
echo "📊 统计代码块语言使用情况..."
echo ""

# 统计各种语言的使用次数
echo "代码块语言分布："
grep -rh '^```[a-z]' docs/ 2>/dev/null | sed 's/^```//' | sort | uniq -c | sort -rn | head -10

echo ""
echo "========================"

TOTAL_ISSUES=$((SPACING_ISSUES + CODE_BLOCK_ISSUES))

if [ $TOTAL_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ 格式检查通过！${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  发现 $TOTAL_ISSUES 个格式问题${NC}"
    echo ""
    echo "问题分类："
    echo "  - 中英文混用格式: $SPACING_ISSUES 处"
    echo "  - 代码块未标注语言: $CODE_BLOCK_ISSUES 处"
    echo ""
    echo -e "${BLUE}💡 建议：${NC}"
    echo "  1. 中英文之间加空格"
    echo "  2. 为所有代码块添加语言标注"
    echo "  3. 运行 fix-format.sh 自动修复部分问题"
    exit 1
fi
