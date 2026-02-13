# 🚀 OpenClaw 保活快速开始

## 一键配置

```bash
# 1. 配置保活服务
./setup-launchd.sh

# 2. 查看状态
./status-launchd.sh
```

完成！你的 4 个 AI 助手现在会：
- ✅ 开机自动启动
- ✅ 崩溃后 10 秒自动重启
- ✅ 7×24 小时在线

## 常用命令

```bash
# 查看状态
./status-launchd.sh

# 停止所有
./stop-launchd.sh

# 重启所有
./restart-launchd.sh

# 卸载服务
./uninstall-launchd.sh

# 查看日志
tail -f ~/.openclaw-main-assistant/stdout.log
```

## 单个服务管理

```bash
# 停止
launchctl unload ~/Library/LaunchAgents/com.openclaw.main-assistant.plist

# 启动
launchctl load ~/Library/LaunchAgents/com.openclaw.main-assistant.plist

# 重启
launchctl unload ~/Library/LaunchAgents/com.openclaw.main-assistant.plist
launchctl load ~/Library/LaunchAgents/com.openclaw.main-assistant.plist
```

## 日志位置

```
~/.openclaw-main-assistant/stdout.log    # 标准输出
~/.openclaw-main-assistant/stderr.log    # 错误输出
~/.openclaw-content-creator/stdout.log
~/.openclaw-content-creator/stderr.log
~/.openclaw-tech-dev/stdout.log
~/.openclaw-tech-dev/stderr.log
~/.openclaw-ai-news/stdout.log
~/.openclaw-ai-news/stderr.log
```

## 故障排查

```bash
# 查看服务状态
launchctl list | grep openclaw

# 查看错误日志
tail -50 ~/.openclaw-main-assistant/stderr.log

# 检查端口
lsof -i :18789

# 运行诊断
openclaw --profile main-assistant doctor
```

## 完整文档

查看 `LAUNCHD-GUIDE.md` 了解详细说明。
