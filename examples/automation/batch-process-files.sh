#!/bin/bash
# OpenClaw 批量文件处理脚本
# 批量处理指定目录下的文件

# 配置
SOURCE_DIR="$HOME/Documents/ToProcess"
OUTPUT_DIR="$HOME/Documents/Processed"
OPENCLAW_BIN="openclaw"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 统计
TOTAL=0
SUCCESS=0
FAILED=0

echo "开始批量处理文件..."
echo "源目录：$SOURCE_DIR"
echo "输出目录：$OUTPUT_DIR"
echo "---"

# 遍历文件
for file in "$SOURCE_DIR"/*; do
    if [ -f "$file" ]; then
        TOTAL=$((TOTAL + 1))
        filename=$(basename "$file")
        
        echo "处理文件 $TOTAL: $filename"
        
        # 使用OpenClaw处理文件
        # 示例：提取文件摘要
        PROMPT="请分析这个文件并生成摘要：$file"
        
        if $OPENCLAW_BIN message send --message "$PROMPT" > "$OUTPUT_DIR/${filename}.summary.txt"; then
            SUCCESS=$((SUCCESS + 1))
            echo "✅ 成功"
        else
            FAILED=$((FAILED + 1))
            echo "❌ 失败"
        fi
    fi
done

# 输出统计
echo "---"
echo "处理完成！"
echo "总计：$TOTAL 个文件"
echo "成功：$SUCCESS 个"
echo "失败：$FAILED 个"
