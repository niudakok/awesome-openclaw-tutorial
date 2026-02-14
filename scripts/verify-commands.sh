#!/bin/bash
# OpenClaw 教程命令验证脚本
# 用于检查教程中是否存在错误的命令

set -e

echo "🔍 OpenClaw 教程命令验证"
echo "=========================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 错误计数
ERROR_COUNT=0

# 检查1：错误的 models auth add 命令
echo "检查1: models auth add 命令..."
if grep -r "openclaw models auth add anthropic" docs/ 2>/dev/null; then
    echo -e "${RED}❌ 发现错误命令: openclaw models auth add anthropic${NC}"
    ERROR_COUNT=$((ERROR_COUNT + 1))
else
    echo -e "${GREEN}✅ 未发现错误命令${NC}"
fi
echo ""

# 检查2：错误的 models auth add 其他 provider
echo "检查2: models auth add 其他 provider..."
if grep -rE "openclaw models auth add (openai|google|deepseek|moonshot)" docs/ 2>/dev/null; then
    echo -e "${RED}❌ 发现错误命令: openclaw models auth add <provider>${NC}"
    ERROR_COUNT=$((ERROR_COUNT + 1))
else
    echo -e "${GREEN}✅ 未发现错误命令${NC}"
fi
echo ""

# 检查3：验证正确的命令存在
echo "检查3: 验证正确命令..."
if grep -r "openclaw models auth add" docs/ | grep -v "anthropic\|openai\|google" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ 找到正确的命令用法${NC}"
else
    echo -e "${YELLOW}⚠️  未找到 models auth add 命令（可能已被替换为其他方式）${NC}"
fi
echo ""

# 检查4：验证其他 auth 命令
echo "检查4: 验证其他 auth 命令..."
AUTH_COMMANDS=$(grep -rh "openclaw.*auth" docs/ 2>/dev/null | grep -v "^#" | sort -u)
if [ -n "$AUTH_COMMANDS" ]; then
    echo "找到的 auth 相关命令："
    echo "$AUTH_COMMANDS" | while read -r cmd; do
        echo "  - $cmd"
    done
else
    echo -e "${YELLOW}⚠️  未找到 auth 相关命令${NC}"
fi
echo ""

# 检查5：验证配置文件路径
echo "检查5: 验证配置文件路径..."
CONFIG_PATHS=$(grep -rh "~/.openclaw" docs/ 2>/dev/null | grep -v "^#" | sort -u | head -10)
if [ -n "$CONFIG_PATHS" ]; then
    echo "找到的配置文件路径："
    echo "$CONFIG_PATHS" | while read -r path; do
        echo "  - $path"
    done
else
    echo -e "${YELLOW}⚠️  未找到配置文件路径${NC}"
fi
echo ""

# 总结
echo "=========================="
if [ $ERROR_COUNT -eq 0 ]; then
    echo -e "${GREEN}✅ 验证通过！未发现错误命令。${NC}"
    exit 0
else
    echo -e "${RED}❌ 发现 $ERROR_COUNT 个错误！${NC}"
    exit 1
fi
