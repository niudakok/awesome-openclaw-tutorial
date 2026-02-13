# 🎉 多 Gateway 配置成功！

## 配置概览

已成功配置 4 个独立的 OpenClaw Gateway 实例，每个实例使用独立的 profile、端口、飞书账号和 agent。

### 实例列表

| Profile | 端口 | Agent | 模型 | 飞书机器人 | 群组 ID |
|---------|------|-------|------|------------|---------|
| main-assistant | 18789 | main-agent | Claude Opus 4.6 Thinking | 主助理 | oc_YOUR_MAIN_GROUP_ID |
| content-creator | 18790 | content-agent | Claude Sonnet 4.5 | 内容创作助手 | oc_YOUR_CONTENT_GROUP_ID |
| tech-dev | 18791 | tech-agent | Claude Sonnet 4.5 Thinking | 技术开发助手 | oc_YOUR_TECH_GROUP_ID |
| ai-news | 18792 | ainews-agent | Gemini 2.5 Flash | AI资讯助手 | oc_YOUR_NEWS_GROUP_ID |

## 架构说明

### 为什么使用多 Gateway？

1. **单 Gateway 的 bindings 功能不可靠**
   - 在 OpenClaw 2026.2.9 中，bindings 的 peer.id 匹配经常失败
   - 多账号模式下，所有群组都路由到同一个 agent

2. **多 Gateway 架构的优势**
   - ✅ 每个 Gateway 独立运行，互不干扰
   - ✅ 每个群组自动使用对应的 agent 和模型
   - ✅ 不需要 `/reset` 和 `/agent` 命令切换
   - ✅ 配置清晰，易于管理和调试
   - ✅ 可以独立重启某个 Gateway 而不影响其他

3. **资源占用**
   - 每个 Gateway 约 400MB 内存
   - 4 个 Gateway 总共约 1.6GB
   - 对于 64GB 内存的机器完全可以接受

### Profile 隔离机制

使用 `--profile <name>` 参数，OpenClaw 会：
- 将配置文件隔离到 `~/.openclaw-<name>/openclaw.json`
- 将状态数据隔离到 `~/.openclaw-<name>/` 目录
- 使用独立的端口和 WebSocket 连接
- 完全独立的会话和上下文

## 配置文件位置

```
~/.openclaw-main-assistant/openclaw.json
~/.openclaw-content-creator/openclaw.json
~/.openclaw-tech-dev/openclaw.json
~/.openclaw-ai-news/openclaw.json
```

## 管理脚本

### 启动所有 Gateway
```bash
./start-all-gateways.sh
```

### 停止所有 Gateway
```bash
./stop-all-gateways.sh
```

### 检查状态
```bash
./check-gateways.sh
```

### 验证配置
```bash
./verify-setup.sh
```

### 启动单个 Gateway
```bash
./start-main-assistant.sh
./start-content-creator.sh
./start-tech-dev.sh
./start-ai-news.sh
```

## 日志文件

每个 Gateway 的日志输出到独立文件：
```bash
logs-main-assistant.log
logs-content-creator.log
logs-tech-dev.log
logs-ai-news.log
```

查看实时日志：
```bash
tail -f logs-main-assistant.log
tail -f logs-content-creator.log
tail -f logs-tech-dev.log
tail -f logs-ai-news.log
```

## 测试方法

1. **在飞书群组中测试**
   - 在"主助理"群组中 @ 主助理机器人
   - 在"内容创作"群组中 @ 内容创作助手机器人
   - 在"技术开发"群组中 @ 技术开发助手机器人
   - 在"AI资讯"群组中 @ AI资讯助手机器人

2. **验证使用的模型**
   - 发送 `/status` 命令查看当前使用的模型
   - 主助理应该显示 Claude Opus 4.6 Thinking
   - 内容创作助手应该显示 Claude Sonnet 4.5
   - 技术开发助手应该显示 Claude Sonnet 4.5 Thinking
   - AI资讯助手应该显示 Gemini 2.5 Flash

3. **观察日志**
   ```bash
   # 在一个终端中观察所有日志
   tail -f logs-*.log
   ```

## 常见操作

### 重启所有 Gateway
```bash
./stop-all-gateways.sh
sleep 2
./start-all-gateways.sh
```

### 重启单个 Gateway
```bash
# 找到进程 ID
ps aux | grep "openclaw.*--profile main-assistant"

# 停止进程
kill <PID>

# 重新启动
./start-main-assistant.sh
```

### 修改配置
```bash
# 编辑配置文件
vim ~/.openclaw-main-assistant/openclaw.json

# 重启对应的 Gateway
# (找到进程并 kill，然后重新启动)
```

### 查看端口占用
```bash
lsof -i :18789
lsof -i :18790
lsof -i :18791
lsof -i :18792
```

## 故障排查

### Gateway 启动失败
1. 检查日志文件：`tail -50 logs-<profile>.log`
2. 检查配置文件：`jq . ~/.openclaw-<profile>/openclaw.json`
3. 检查端口占用：`lsof -i :<port>`
4. 运行 doctor：`openclaw --profile <profile> doctor`

### 飞书连接失败
1. 检查日志中是否有 "WebSocket client started"
2. 验证飞书账号配置：`jq '.channels.feishu.accounts' ~/.openclaw-<profile>/openclaw.json`
3. 检查飞书应用配置（appId 和 appSecret）

### Agent 不正确
1. 检查配置：`jq '.agents.list[0].id' ~/.openclaw-<profile>/openclaw.json`
2. 确认只有一个 agent：`jq '.agents.list | length' ~/.openclaw-<profile>/openclaw.json`
3. 在群组中发送 `/status` 查看实际使用的 agent

## 性能监控

### 查看内存占用
```bash
ps aux | grep openclaw-gateway | awk '{print $4, $11}'
```

### 查看 CPU 占用
```bash
ps aux | grep openclaw-gateway | awk '{print $3, $11}'
```

### 查看所有进程详情
```bash
ps aux | grep openclaw-gateway | grep -v grep
```

## 备份和恢复

### 备份配置
```bash
# 备份所有 profile 配置
tar -czf openclaw-profiles-backup-$(date +%Y%m%d).tar.gz \
  ~/.openclaw-main-assistant \
  ~/.openclaw-content-creator \
  ~/.openclaw-tech-dev \
  ~/.openclaw-ai-news
```

### 恢复配置
```bash
# 停止所有 Gateway
./stop-all-gateways.sh

# 解压备份
tar -xzf openclaw-profiles-backup-YYYYMMDD.tar.gz -C ~/

# 重新启动
./start-all-gateways.sh
```

## 下一步优化

1. **使用 systemd/launchd 管理**
   - 配置开机自启动
   - 自动重启失败的 Gateway
   - 统一的日志管理

2. **监控和告警**
   - 监控 Gateway 健康状态
   - 内存和 CPU 使用率告警
   - 飞书连接状态监控

3. **日志轮转**
   - 配置日志文件大小限制
   - 自动归档旧日志
   - 定期清理

4. **负载均衡**
   - 如果某个 agent 负载过高
   - 可以考虑增加更多实例
   - 使用不同的群组分流

## 总结

✅ 成功配置了 4 个独立的 Gateway 实例  
✅ 每个实例使用不同的 agent 和模型  
✅ 每个飞书群组自动路由到对应的 agent  
✅ 完全解决了 bindings 不工作的问题  
✅ 配置清晰，易于管理和扩展  

这个架构比单 Gateway + bindings 更稳定、更可靠！

---

**配置完成时间**: 2026-02-13  
**OpenClaw 版本**: 2026.2.9  
**配置方式**: Profile 隔离 + 多 Gateway  
