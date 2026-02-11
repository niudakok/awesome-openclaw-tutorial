#!/bin/bash

# 处理"OpenClaw白嫖云部署"文章的图片

ARTICLE_FILE="OpenClaw白嫖云部署！附自定义模型API和4种Skills神级用法～.md"
TEMP_DIR="images/baipiao-temp"
OUTPUT_FILE="images/baipiao-uploaded-urls.txt"

# 创建临时目录
mkdir -p "$TEMP_DIR"

# 提取所有飞书图片链接
echo "提取图片链接..."
grep -o 'https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=[^)]*' "$ARTICLE_FILE" > "$TEMP_DIR/urls.txt"

# 统计图片数量
IMAGE_COUNT=$(wc -l < "$TEMP_DIR/urls.txt")
echo "找到 $IMAGE_COUNT 张图片"

# 下载图片
echo "开始下载图片..."
cd "$TEMP_DIR"
COUNTER=1
while IFS= read -r url; do
    echo "下载图片 $COUNTER/$IMAGE_COUNT..."
    curl -s -L "$url" -o "image_${COUNTER}.jpg"
    COUNTER=$((COUNTER + 1))
done < urls.txt

cd ../..

# 上传到图床
echo "开始上传到图床..."
> "$OUTPUT_FILE"

for img in "$TEMP_DIR"/image_*.jpg; do
    if [ -f "$img" ]; then
        echo "上传: $(basename "$img")"
        RESPONSE=$(curl -s -X POST "https://upload.maynor1024.live/upload" \
            -H "Authorization: Bearer maynor1024" \
            -F "file=@$img")
        
        # 提取上传后的URL
        UPLOADED_URL=$(echo "$RESPONSE" | grep -o 'https://upload.maynor1024.live/file/[^"]*')
        
        if [ -n "$UPLOADED_URL" ]; then
            echo "$UPLOADED_URL" >> "$OUTPUT_FILE"
            echo "  ✓ $UPLOADED_URL"
        else
            echo "  ✗ 上传失败"
        fi
        
        sleep 1
    fi
done

echo "完成！上传的URL保存在: $OUTPUT_FILE"
echo "总共上传: $(wc -l < "$OUTPUT_FILE") 张图片"
