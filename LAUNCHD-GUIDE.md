# OpenClaw 多 Gateway 保活指南

## 什么是 launchd？

launchd 是 macOS 的系统服务管理器，类似于 Linux 的 systemd。它可以：

- ✅ 开机自动启动服务
- ✅ 进程崩溃后自动重启
- ✅ 管理日志输出
- ✅ 设置环境变量
- ✅ 控制重启间隔

## 快速开始

### 1. 配置保活服务

```bash
# 运行配置脚本
./setup-launchd.sh
```

这个脚本会：
- 为 4 个 Gateway 创建 launchd 配置文件
- 自动加载并启动所有服务
- 配置开机自启动
- 配置自动重启（崩溃后 10 秒重启）

### 2. 查看服务状态

```bash
# 使用我们的脚本
./status-launchd.sh

# 或使用 launchctl 命令
launchctl list | grep openclaw
```

### 3. 管理服务

```bash
# 停止所有服务
./stop-launchd.sh

# 重启所有服务
./restart-launchd.sh

# 卸载所有服务
./uninstall-launchd.sh
```

## 详细说明

### 配置文件位置

所有配置文件位于：
```
~/Library/LaunchAgents/com.openclaw.main-assistant.plist
~/Library/LaunchAgents/com.openclaw.content-creator.plist
~/Library/LaunchAgents/com.openclaw.tech-dev.plist
~/Library/LaunchAgents/com.openclaw.ai-news.plist
```

### 日志文件位置

每个 Gateway 的日志：
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

### 查看日志

```bash
# 实时查看标准输出
tail -f ~/.openclaw-main-assistant/stdout.log

# 实时查看错误输出
tail -f ~/.openclaw-main-assistant/stderr.log

# 查看所有日志
tail -f ~/.openclaw-*/stdout.log
```

## 单个服务管理

### 停止单个服务

```bash
launchctl unload ~/Library/LaunchAgents/com.openclaw.main-assistant.plist
```

### 启动单个服务

```bash
launchctl load ~/Library/LaunchAgents/com.openclaw.main-assistant.plist
```

### 重启单个服务

```bash
launchctl unload ~/Library/LaunchAgents/com.openclaw.main-assistant.plist
launchctl load ~/Library/LaunchAgents/com.openclaw.main-assistant.plist
```

### 查看单个服务状态

```bash
launchctl list | grep com.openclaw.main-assistant
```

## 配置说明

### RunAtLoad

```xml
<key>RunAtLoad</key>
<true/>
```

- 开机时自动启动
- 加载配置文件时立即启动

### KeepAlive

```xml
<key>KeepAlive</key>
<dict>
    <key>SuccessfulExit</key>
    <false/>
</dict>
```

- 进程退出后自动重启
- `SuccessfulExit=false` 表示即使正常退出也重启
- 如果只想在崩溃时重启，设置为 `true`

### ThrottleInterval

```xml
<key>ThrottleInterval</key>
<integer>10</integer>
```

- 重启间隔：10 秒
- 防止频繁重启消耗资源

### StandardOutPath / StandardErrorPath

```xml
<key>StandardOutPath</key>
<string>$HOME/.openclaw-main-assistant/stdout.log</string>

<key>StandardErrorPath</key>
<string>$HOME/.openclaw-main-assistant/stderr.log</string>
```

- 标准输出和错误输出的日志文件
- 自动创建和追加

## 故障排查

### 服务无法启动

**检查配置文件**：
```bash
plutil -lint ~/Library/LaunchAgents/com.openclaw.main-assistant.plist
```

**查看错误日志**：
```bash
tail -50 ~/.openclaw-main-assistant/stderr.log
```

**检查 openclaw 路径**：
```bash
which openclaw
```

### 服务频繁重启

**查看日志**：
```bash
tail -100 ~/.openclaw-main-assistant/stdout.log
tail -100 ~/.openclaw-main-assistant/stderr.log
```

**检查配置**：
```bash
jq . ~/.openclaw-main-assistant/openclaw.json
```

**运行 doctor**：
```bash
openclaw --profile main-assistant doctor
```

### 端口被占用

**查看端口占用**：
```bash
lsof -i :18789
lsof -i :18790
lsof -i :18791
lsof -i :18792
```

**停止占用进程**：
```bash
kill <PID>
```

### 日志文件过大

**清理日志**：
```bash
# 清空日志
> ~/.openclaw-main-assistant/stdout.log
> ~/.openclaw-main-assistant/stderr.log

# 或删除日志
rm ~/.openclaw-main-assistant/*.log
```

**配置日志轮转**（可选）：
```bash
# 创建日志轮转脚本
cat > ~/rotate-openclaw-logs.sh << 'EOF'
#!/bin/zsh
for log in ~/.openclaw-*/stdout.log ~/.openclaw-*/stderr.log; do
    if [ -f "$log" ] && [ $(stat -f%z "$log") -gt 10485760 ]; then
        mv "$log" "$log.$(date +%Y%m%d_%H%M%S)"
        touch "$log"
    fi
done
EOF

chmod +x ~/rotate-openclaw-logs.sh

# 添加到 crontab（每小时执行）
crontab -e
# 添加：0 * * * * ~/rotate-openclaw-logs.sh
```

## 高级配置

### 修改重启间隔

编辑配置文件，修改 `ThrottleInterval` 值：

```xml
<key>ThrottleInterval</key>
<integer>30</integer>  <!-- 改为 30 秒 -->
```

然后重新加载：
```bash
launchctl unload ~/Library/LaunchAgents/com.openclaw.main-assistant.plist
launchctl load ~/Library/LaunchAgents/com.openclaw.main-assistant.plist
```

### 只在崩溃时重启

修改 `KeepAlive` 配置：

```xml
<key>KeepAlive</key>
<dict>
    <key>SuccessfulExit</key>
    <true/>  <!-- 改为 true -->
</dict>
```

### 添加环境变量

在配置文件中添加：

```xml
<key>EnvironmentVariables</key>
<dict>
    <key>PATH</key>
    <string>/usr/local/bin:/usr/bin:/bin</string>
    <key>OPENCLAW_LOG_LEVEL</key>
    <string>debug</string>
</dict>
```

### 设置工作目录

```xml
<key>WorkingDirectory</key>
<string>/Users/yourusername/openclaw</string>
```

## 对比其他方案

### vs 手动启动

| 特性 | 手动启动 | launchd |
|------|----------|---------|
| 开机自启 | ❌ | ✅ |
| 自动重启 | ❌ | ✅ |
| 日志管理 | 手动 | 自动 |
| 管理复杂度 | 简单 | 中等 |

### vs tmux/screen

| 特性 | tmux/screen | launchd |
|------|-------------|---------|
| 开机自启 | ❌ | ✅ |
| 自动重启 | ❌ | ✅ |
| 后台运行 | ✅ | ✅ |
| 系统集成 | ❌ | ✅ |

### vs Docker

| 特性 | Docker | launchd |
|------|--------|---------|
| 隔离性 | ✅ | ❌ |
| 资源占用 | 高 | 低 |
| 配置复杂度 | 高 | 中等 |
| macOS 原生 | ❌ | ✅ |

## 最佳实践

1. **定期检查日志**
   ```bash
   ./status-launchd.sh
   ```

2. **监控资源占用**
   ```bash
   ps aux | grep openclaw-gateway
   ```

3. **定期清理日志**
   ```bash
   # 每周清理一次
   > ~/.openclaw-*/stdout.log
   > ~/.openclaw-*/stderr.log
   ```

4. **备份配置**
   ```bash
   tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz \
     ~/.openclaw-* \
     ~/Library/LaunchAgents/com.openclaw.*.plist
   ```

5. **测试重启**
   ```bash
   # 定期测试自动重启功能
   kill $(launchctl list | grep com.openclaw.main-assistant | awk '{print $1}')
   sleep 15
   ./status-launchd.sh
   ```

## 总结

使用 launchd 管理 OpenClaw 多 Gateway 的优势：

- ✅ 开机自动启动，无需手动操作
- ✅ 进程崩溃自动重启，保证服务可用性
- ✅ 统一的日志管理，方便排查问题
- ✅ macOS 原生支持，稳定可靠
- ✅ 简单的管理脚本，易于使用

现在你的 4 个 AI 助手会 7×24 小时在线，随时为你服务！
