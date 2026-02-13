#!/bin/bash

# 创建 OpenClaw Manager.app

echo "📦 创建 OpenClaw Manager.app..."
echo ""

# 创建应用程序包结构
APP_NAME="OpenClaw Manager.app"
APP_DIR="$APP_NAME/Contents"
MACOS_DIR="$APP_DIR/MacOS"
RESOURCES_DIR="$APP_DIR/Resources"

# 清理旧的应用
if [ -d "$APP_NAME" ]; then
    echo "删除旧的应用..."
    rm -rf "$APP_NAME"
fi

# 创建目录结构
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

echo "✅ 目录结构已创建"

# 创建 Info.plist
cat > "$APP_DIR/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>OpenClaw-Manager</string>
    <key>CFBundleIdentifier</key>
    <string>com.openclaw.manager</string>
    <key>CFBundleName</key>
    <string>OpenClaw Manager</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ Info.plist 已创建"

# 复制主脚本
cp OpenClaw-Manager.app.sh "$MACOS_DIR/OpenClaw-Manager"
chmod +x "$MACOS_DIR/OpenClaw-Manager"

echo "✅ 主脚本已复制"

# 复制依赖脚本
cp setup-launchd.sh "$RESOURCES_DIR/"
cp stop-launchd.sh "$RESOURCES_DIR/"
cp restart-launchd.sh "$RESOURCES_DIR/"
cp status-launchd.sh "$RESOURCES_DIR/"
chmod +x "$RESOURCES_DIR"/*.sh

echo "✅ 依赖脚本已复制"

# 创建图标（使用系统图标）
# 你可以替换为自定义图标
cat > "$RESOURCES_DIR/AppIcon.icns.sh" << 'EOF'
#!/bin/bash
# 使用系统图标作为临时方案
# 如果需要自定义图标，请替换此文件
EOF

echo "✅ 应用程序包已创建"
echo ""
echo "📍 位置: ./$APP_NAME"
echo ""
echo "使用方法："
echo "1. 双击打开 OpenClaw Manager.app"
echo "2. 或拖动到 /Applications 文件夹"
echo ""
echo "⚠️  首次运行可能需要："
echo "   系统偏好设置 → 安全性与隐私 → 允许运行"
echo ""
