#!/bin/bash

# 批量上传图片到图床的脚本
# API: https://upload.maynor1024.live/upload
# POST参数名: file
# JSON路径: 0.src
# URL前缀: https://upload.maynor1024.live

IMAGE_DIR="images/openclaw-guide"
OUTPUT_FILE="image_urls.txt"
API_URL="https://upload.maynor1024.live/upload"
URL_PREFIX="https://upload.maynor1024.live"

# 清空输出文件
> "$OUTPUT_FILE"

echo "开始上传图片..."
echo "图片目录: $IMAGE_DIR"
echo "输出文件: $OUTPUT_FILE"
echo ""

# 计数器
count=0
success=0
failed=0

# 遍历所有图片文件
for img in "$IMAGE_DIR"/*.{png,jpg,jpeg,gif,bmp}; do
    # 检查文件是否存在
    if [ ! -f "$img" ]; then
        continue
    fi
    
    count=$((count + 1))
    filename=$(basename "$img")
    
    echo "[$count] 上传: $filename"
    
    # 上传图片
    response=$(curl -s -X POST "$API_URL" \
        -F "file=@$img" \
        -H "Accept: application/json")
    
    # 检查响应
    if [ $? -eq 0 ]; then
        # 提取URL（假设返回JSON格式：[{"src": "url"}]）
        url=$(echo "$response" | grep -o '"src":"[^"]*"' | cut -d'"' -f4)
        
        if [ -n "$url" ]; then
            # 如果URL不是完整的，添加前缀
            if [[ ! "$url" =~ ^http ]]; then
                url="${URL_PREFIX}${url}"
            fi
            
            echo "  ✓ 成功: $url"
            echo "$filename|$url" >> "$OUTPUT_FILE"
            success=$((success + 1))
        else
            echo "  ✗ 失败: 无法解析URL"
            echo "  响应: $response"
            failed=$((failed + 1))
        fi
    else
        echo "  ✗ 失败: 上传错误"
        failed=$((failed + 1))
    fi
    
    # 避免请求过快
    sleep 0.5
done

echo ""
echo "上传完成！"
echo "总计: $count 张"
echo "成功: $success 张"
echo "失败: $failed 张"
echo "结果保存在: $OUTPUT_FILE"
