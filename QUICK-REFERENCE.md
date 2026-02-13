# 🚀 多 Gateway 快速参考

## 常用命令

### 启动和停止
```bash
./start-all-gateways.sh      # 启动所有
./stop-all-gateways.sh       # 停止所有
./check-gateways.sh          # 检查状态
./verify-setup.sh            # 验证配置
```

### 单个 Gateway
```bash
./start-main-assistant.sh    # 启动主助理
./start-content-creator.sh   # 启动内容创作助手
./start-tech-dev.sh          # 启动技术开发助手
./start-ai-news.sh           # 启动AI资讯助手
```

### 查看日志
```bash
tail -f logs-main-assistant.log
tail -f logs-content-creator.log
tail -f logs-tech-dev.log
tail -f logs-ai-news.log
tail -f logs-*.log           # 查看所有
```

## 配置映射

| 群组 | 机器人 | Agent | 模型 | 端口 |
|------|--------|-------|------|------|
| 主助理群 | 主助理 | main-agent | Claude Opus 4.6 | 18789 |
| 内容创作群 | 内容创作助手 | content-agent | Claude Sonnet 4.5 | 18790 |
| 技术开发群 | 技术开发助手 | tech-agent | Claude Sonnet 4.5 Thinking | 18791 |
| AI资讯群 | AI资讯助手 | ainews-agent | Gemini 2.5 Flash | 18792 |

## 配置文件位置

```
~/.openclaw-main-assistant/openclaw.json
~/.openclaw-content-creator/openclaw.json
~/.openclaw-tech-dev/openclaw.json
~/.openclaw-ai-news/openclaw.json
```

## 测试命令

在飞书群组中发送：
- `/status` - 查看当前 agent 和模型
- `/help` - 查看帮助信息
- `@机器人 你好` - 测试基本对话

## 故障排查

```bash
# 检查进程
ps aux | grep openclaw-gateway

# 检查端口
lsof -i :18789
lsof -i :18790
lsof -i :18791
lsof -i :18792

# 查看最新日志
tail -20 logs-main-assistant.log

# 运行 doctor
openclaw --profile main-assistant doctor
```

## 重启流程

```bash
# 1. 停止所有
./stop-all-gateways.sh

# 2. 等待 2 秒
sleep 2

# 3. 启动所有
./start-all-gateways.sh

# 4. 检查状态
./check-gateways.sh
```

## 内存占用

- 单个 Gateway: ~400MB
- 4 个 Gateway: ~1.6GB
- 总系统内存: 64GB
- 占用比例: ~2.5%

## 关键特性

✅ 每个群组自动使用对应的 agent  
✅ 不需要 `/reset` 和 `/agent` 命令  
✅ 完全独立，互不干扰  
✅ 配置清晰，易于管理  
✅ 可以独立重启某个 Gateway  

---

**更多详情**: 查看 `MULTI-GATEWAY-SUCCESS.md`
