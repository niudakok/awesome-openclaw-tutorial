#!/bin/bash

# 创建 OpenClaw Manager 应用图标

echo "🎨 创建应用图标..."
echo ""

# 下载图标
echo "1️⃣  下载图标..."
curl -L "https://upload.maynor1024.live/file/1770975518145_252820863_副本.jpeg" -o icon.jpg

if [ ! -f icon.jpg ]; then
    echo "❌ 下载失败"
    exit 1
fi

echo "✅ 图标已下载"

# 检查图片尺寸
echo ""
echo "2️⃣  检查并调整图片尺寸..."

# 先放大到 1024x1024
sips -z 1024 1024 icon.jpg --out icon_1024.png > /dev/null 2>&1

if [ ! -f icon_1024.png ]; then
    echo "❌ 图片处理失败"
    exit 1
fi

echo "✅ 图片已调整为 1024x1024"

# 创建临时目录
ICONSET_DIR="AppIcon.iconset"
mkdir -p "$ICONSET_DIR"

echo ""
echo "3️⃣  生成不同尺寸的图标..."

# 使用 sips 命令生成不同尺寸（macOS 自带工具）
sizes=(16 32 64 128 256 512 1024)

for size in "${sizes[@]}"; do
    echo "  生成 ${size}x${size}..."
    sips -s format png -z $size $size icon_1024.png --out "$ICONSET_DIR/icon_${size}x${size}.png" > /dev/null 2>&1
    
    # 生成 @2x 版本（除了 1024）
    if [ $size -ne 1024 ]; then
        size2x=$((size * 2))
        sips -s format png -z $size2x $size2x icon_1024.png --out "$ICONSET_DIR/icon_${size}x${size}@2x.png" > /dev/null 2>&1
    fi
done

echo "✅ 所有尺寸已生成"

echo ""
echo "4️⃣  创建 .icns 文件..."

# 使用 iconutil 创建 .icns 文件（macOS 自带工具）
iconutil -c icns "$ICONSET_DIR" -o AppIcon.icns

if [ -f AppIcon.icns ]; then
    echo "✅ AppIcon.icns 已创建"
else
    echo "❌ 创建失败"
    exit 1
fi

echo ""
echo "5️⃣  复制到应用程序包..."

APP_NAME="OpenClaw Manager.app"
RESOURCES_DIR="$APP_NAME/Contents/Resources"

if [ -d "$APP_NAME" ]; then
    cp AppIcon.icns "$RESOURCES_DIR/"
    
    # 更新 Info.plist
    /usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string AppIcon" "$APP_NAME/Contents/Info.plist" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Set :CFBundleIconFile AppIcon" "$APP_NAME/Contents/Info.plist"
    
    echo "✅ 图标已复制到应用程序包"
else
    echo "⚠️  应用程序包不存在，请先运行 ./create-app.sh"
fi

echo ""
echo "6️⃣  清理临时文件..."

rm -rf "$ICONSET_DIR"
rm -f icon.jpg icon_1024.png

echo "✅ 临时文件已清理"

echo ""
echo "===================================="
echo "✅ 图标创建完成！"
echo ""
echo "📍 图标文件: AppIcon.icns"
echo ""
echo "下一步："
echo "1. 重新打开 OpenClaw Manager.app 查看新图标"
echo "2. 或重新创建应用: ./create-app.sh"
echo ""
