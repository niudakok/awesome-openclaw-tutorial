# OpenClaw Manager 图形界面使用指南

## 📦 已创建的应用

**OpenClaw Manager.app** - 原生 macOS 图形界面应用

## 🚀 安装和使用

### 方法一：直接使用

```bash
# 双击打开
open "OpenClaw Manager.app"
```

### 方法二：安装到应用程序文件夹

```bash
# 拖动到 Applications 文件夹
cp -r "OpenClaw Manager.app" /Applications/

# 或使用命令
open /Applications/
# 然后拖动 OpenClaw Manager.app 到打开的文件夹
```

### 首次运行

首次运行时，macOS 可能会提示"无法打开，因为它来自身份不明的开发者"。

**解决方法**：

1. 打开"系统偏好设置" → "安全性与隐私"
2. 在"通用"标签页底部，点击"仍要打开"
3. 或者右键点击应用 → "打开" → "打开"

## 🎨 界面功能

### 主菜单

打开应用后，会看到主菜单：

```
OpenClaw Gateway 管理器

选择操作：

[退出]  [查看状态]  [管理服务]
```

### 查看状态

显示所有 4 个 Gateway 的状态：

```
主助理 (main-assistant)
  服务: ✅ 运行中
  端口 18789: ✅

内容创作助手 (content-creator)
  服务: ✅ 运行中
  端口 18790: ✅

技术开发助手 (tech-dev)
  服务: ✅ 运行中
  端口 18791: ✅

AI资讯助手 (ai-news)
  服务: ✅ 运行中
  端口 18792: ✅

[查看日志]  [返回]
```

### 管理服务

提供以下操作：

- **配置保活** - 一键配置 launchd 保活服务
- **启动所有** - 启动所有 Gateway
- **停止所有** - 停止所有 Gateway
- **重启所有** - 重启所有 Gateway

### 查看日志

选择要查看的 Gateway 日志：

- 主助理
- 内容创作助手
- 技术开发助手
- AI资讯助手

点击后会在 Console.app 中打开对应的日志文件。

## 🔧 功能详解

### 配置保活

点击"配置保活"后：

1. 显示确认对话框，说明将要执行的操作
2. 执行 `setup-launchd.sh` 脚本
3. 创建 launchd 配置文件
4. 启动所有 Gateway
5. 配置开机自启动和自动重启
6. 显示配置结果

### 启动所有

- 加载所有 launchd 服务
- 启动所有 Gateway
- 显示启动结果

### 停止所有

- 显示确认对话框
- 卸载所有 launchd 服务
- 停止所有 Gateway
- 显示停止结果

### 重启所有

- 先停止所有服务
- 等待 1 秒
- 重新启动所有服务
- 显示重启结果

## 📝 日志查看

点击"查看日志"后：

1. 选择要查看的 Gateway
2. 在 Console.app 中打开日志文件
3. 可以实时查看日志输出

日志文件位置：
```
~/.openclaw-main-assistant/stdout.log
~/.openclaw-content-creator/stdout.log
~/.openclaw-tech-dev/stdout.log
~/.openclaw-ai-news/stdout.log
```

## 🎯 使用场景

### 场景一：首次配置

1. 打开 OpenClaw Manager
2. 点击"管理服务" → "配置保活"
3. 确认配置
4. 等待配置完成
5. 点击"查看状态"确认所有服务运行中

### 场景二：日常检查

1. 打开 OpenClaw Manager
2. 点击"查看状态"
3. 查看所有服务是否正常运行
4. 如有问题，点击"查看日志"排查

### 场景三：重启服务

1. 打开 OpenClaw Manager
2. 点击"管理服务" → "重启所有"
3. 等待重启完成
4. 点击"查看状态"确认

### 场景四：停止服务

1. 打开 OpenClaw Manager
2. 点击"管理服务" → "停止所有"
3. 确认停止
4. 服务已停止

## 🔍 故障排查

### 应用无法打开

**问题**：双击应用没有反应

**解决**：
1. 右键点击应用 → "打开"
2. 或在终端运行：`open "OpenClaw Manager.app"`

### 权限问题

**问题**：提示"无法打开，因为它来自身份不明的开发者"

**解决**：
1. 系统偏好设置 → 安全性与隐私
2. 点击"仍要打开"

### 配置失败

**问题**：点击"配置保活"后显示失败

**解决**：
1. 查看日志：`cat /tmp/openclaw-setup.log`
2. 检查 openclaw 是否已安装：`which openclaw`
3. 检查配置文件是否存在：`ls ~/.openclaw/openclaw.json`

### 服务无法启动

**问题**：点击"启动所有"后服务仍未运行

**解决**：
1. 先运行"配置保活"
2. 查看日志文件
3. 检查端口是否被占用：`lsof -i :18789`

## 🎨 自定义

### 修改应用图标

1. 准备一个 1024x1024 的 PNG 图片
2. 使用 Icon Composer 或在线工具转换为 .icns 格式
3. 替换 `OpenClaw Manager.app/Contents/Resources/AppIcon.icns`

### 修改应用名称

编辑 `OpenClaw Manager.app/Contents/Info.plist`：

```xml
<key>CFBundleName</key>
<string>你的应用名称</string>
```

### 添加更多功能

编辑 `OpenClaw-Manager.app.sh`，添加新的菜单项和功能。

## 📦 分发应用

### 打包为 DMG

```bash
# 创建 DMG 镜像
hdiutil create -volname "OpenClaw Manager" \
  -srcfolder "OpenClaw Manager.app" \
  -ov -format UDZO \
  "OpenClaw-Manager.dmg"
```

### 分享给他人

1. 将 `OpenClaw Manager.app` 压缩为 ZIP
2. 或创建 DMG 镜像
3. 分享给其他用户

**注意**：其他用户需要：
- 已安装 OpenClaw
- 已配置好 4 个 Gateway 的配置文件

## 🆚 对比命令行

| 功能 | 命令行 | 图形界面 |
|------|--------|----------|
| 易用性 | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| 功能完整性 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 学习成本 | 高 | 低 |
| 自动化 | 容易 | 困难 |
| 适合人群 | 开发者 | 所有人 |

## 💡 最佳实践

1. **首次使用**：先运行"配置保活"
2. **定期检查**：每天打开应用查看状态
3. **遇到问题**：先查看日志，再重启服务
4. **安装到 Applications**：方便快速访问
5. **添加到 Dock**：拖动到 Dock 栏固定

## 🎉 总结

OpenClaw Manager 提供了：

- ✅ 原生 macOS 图形界面
- ✅ 一键配置保活服务
- ✅ 简单的服务管理
- ✅ 实时状态查看
- ✅ 方便的日志查看
- ✅ 无需记忆命令

现在你可以用图形界面轻松管理你的 4 个 AI 助手了！
