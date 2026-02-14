#!/bin/bash
# 修复教程中的 openclaw skills install 命令错误
# 正确命令应该是 clawhub install

set -e

echo "🔧 修复 Skills 安装命令"
echo "========================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 统计
TOTAL_FILES=0
FIXED_FILES=0
TOTAL_REPLACEMENTS=0

# 查找所有包含错误命令的文件
echo "🔍 搜索包含错误命令的文件..."
FILES=$(grep -rl "openclaw skills install" docs/ 2>/dev/null || true)

if [ -z "$FILES" ]; then
    echo -e "${GREEN}✅ 未发现错误命令${NC}"
    exit 0
fi

echo -e "${YELLOW}发现以下文件包含错误命令：${NC}"
echo "$FILES"
echo ""

# 遍历每个文件
for FILE in $FILES; do
    TOTAL_FILES=$((TOTAL_FILES + 1))
    
    # 统计该文件中的错误数量
    COUNT=$(grep -c "openclaw skills install" "$FILE" 2>/dev/null || echo "0")
    
    if [ "$COUNT" -gt 0 ]; then
        echo -e "${YELLOW}修复文件: $FILE (发现 $COUNT 处错误)${NC}"
        
        # 创建备份
        cp "$FILE" "$FILE.bak"
        
        # 替换命令
        sed -i '' 's/openclaw skills install/clawhub install/g' "$FILE"
        
        # 验证替换
        NEW_COUNT=$(grep -c "openclaw skills install" "$FILE" 2>/dev/null || echo "0")
        
        if [ "$NEW_COUNT" -eq 0 ]; then
            echo -e "${GREEN}✅ 修复成功 ($COUNT 处)${NC}"
            FIXED_FILES=$((FIXED_FILES + 1))
            TOTAL_REPLACEMENTS=$((TOTAL_REPLACEMENTS + COUNT))
            
            # 删除备份
            rm "$FILE.bak"
        else
            echo -e "${RED}❌ 修复失败，恢复备份${NC}"
            mv "$FILE.bak" "$FILE"
        fi
    fi
    
    echo ""
done

# 总结
echo "========================"
echo -e "${GREEN}✅ 修复完成！${NC}"
echo ""
echo "统计信息："
echo "  - 扫描文件: $TOTAL_FILES 个"
echo "  - 修复文件: $FIXED_FILES 个"
echo "  - 替换次数: $TOTAL_REPLACEMENTS 处"
echo ""
echo -e "${YELLOW}💡 提示：${NC}"
echo "  - 错误命令: openclaw skills install <skill-name>"
echo "  - 正确命令: clawhub install <skill-name>"
echo ""
echo -e "${YELLOW}📝 下一步：${NC}"
echo "  1. 检查修复结果"
echo "  2. 运行验证脚本: ./scripts/verify-commands.sh"
echo "  3. 提交更改"
