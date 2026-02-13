# OpenClaw 多机器人多 Agent 解决方案

## 问题总结

**需求**：4 个飞书机器人自动使用 4 个不同的 agent

**现状**：
- OpenClaw 2026.2.9 的多账号模式不支持自动路由到不同 agent
- 所有机器人共享 `agents.defaults` 配置
- Bindings 配置虽然正确，但不生效

**官方文档说明**：
> 在多账号配置中，不需要使用 bindings 来绑定不同的 agent。所有机器人会自动共享 agents.defaults 配置。

## 可行的解决方案

### 方案 1：手动切换模型（临时方案）✅

在每个群组中使用 `/model` 命令切换模型：

```
助理群：/model local-antigravity/claude-opus-4-6-thinking
内容创作群：/model local-antigravity/claude-sonnet-4-5
技术开发群：/model local-antigravity/claude-sonnet-4-5-thinking
AI资讯群：/model local-antigravity/gemini-2.5-flash
```

**优点**：
- 立即可用
- 不需要修改配置

**缺点**：
- 需要手动操作
- 每次新会话都要重新设置
- 只能切换模型，不能切换 agent（workspace、tools 等）

### 方案 2：使用单机器人 + 群组命令（推荐）✅

只使用一个飞书机器人，在不同群组中使用命令切换 agent：

```
群组 1：/agent main-agent
群组 2：/agent content-agent
群组 3：/agent tech-agent
群组 4：/agent ainews-agent
```

**配置**：
```json
{
  "channels": {
    "feishu": {
      "accounts": {
        "main-assistant": {
          "appId": "cli_YOUR_MAIN_APP_ID",
          "appSecret": "YOUR_MAIN_APP_SECRET",
          "botName": "主助理",
          "enabled": true
        }
      }
    }
  },
  "agents": {
    "list": [
      {
        "id": "main-agent",
        "workspace": "/Users/chinamanor/clawd",
        "agentDir": "/Users/chinamanor/.openclaw/agents/main-agent/agent",
        "model": {
          "primary": "local-antigravity/claude-opus-4-6-thinking"
        }
      },
      {
        "id": "content-agent",
        "workspace": "/Users/chinamanor/clawd/content",
        "agentDir": "/Users/chinamanor/.openclaw/agents/content-agent/agent",
        "model": {
          "primary": "local-antigravity/claude-sonnet-4-5"
        }
      },
      {
        "id": "tech-agent",
        "workspace": "/Users/chinamanor/clawd/tech",
        "agentDir": "/Users/chinamanor/.openclaw/agents/tech-agent/agent",
        "model": {
          "primary": "local-antigravity/claude-sonnet-4-5-thinking"
        }
      },
      {
        "id": "ainews-agent",
        "workspace": "/Users/chinamanor/clawd/ainews",
        "agentDir": "/Users/chinamanor/.openclaw/agents/ainews-agent/agent",
        "model": {
          "primary": "local-antigravity/gemini-2.5-flash"
        }
      }
    ]
  }
}
```

**优点**：
- 可以切换完整的 agent（包括 workspace、tools）
- 配置简单
- 会话会记住 agent 选择

**缺点**：
- 需要手动操作一次
- 所有机器人显示同一个名字

### 方案 3：等待 OpenClaw 更新 ❌

OpenClaw 2026.2.9 可能不支持多账号 + 多 agent 的自动路由。

可以：
1. 提交 feature request 到 OpenClaw GitHub
2. 等待官方支持
3. 或者查看是否有更新版本

### 方案 4：使用独立的 OpenClaw 实例 ❌

为每个 agent 运行独立的 OpenClaw 实例：

```bash
# 实例 1 - 端口 18789
openclaw gateway run --port 18789 --config ~/.openclaw/config-main.json

# 实例 2 - 端口 18790
openclaw gateway run --port 18790 --config ~/.openclaw/config-content.json

# 实例 3 - 端口 18791
openclaw gateway run --port 18791 --config ~/.openclaw/config-tech.json

# 实例 4 - 端口 18792
openclaw gateway run --port 18792 --config ~/.openclaw/config-ainews.json
```

**优点**：
- 完全隔离
- 每个机器人独立配置

**缺点**：
- 复杂度高
- 资源消耗大
- 管理困难

## 推荐方案

### 立即可用：方案 1（手动切换模型）

在每个群组中发送：

```
助理群：/model local-antigravity/claude-opus-4-6-thinking
内容创作群：/model local-antigravity/claude-sonnet-4-5
技术开发群：/model local-antigravity/claude-sonnet-4-5-thinking
AI资讯群：/model local-antigravity/gemini-2.5-flash
```

### 长期方案：方案 2（单机器人 + 群组命令）

1. 禁用其他 3 个飞书机器人，只保留一个
2. 在每个群组中使用 `/agent` 命令切换
3. 会话会记住选择，不需要每次都切换

## 实施步骤（方案 1）

1. **在助理群中**：
   ```
   /model local-antigravity/claude-opus-4-6-thinking
   ```

2. **在内容创作群中**：
   ```
   /model local-antigravity/claude-sonnet-4-5
   ```

3. **在技术开发群中**：
   ```
   /model local-antigravity/claude-sonnet-4-5-thinking
   ```

4. **在 AI 资讯群中**：
   ```
   /model local-antigravity/gemini-2.5-flash
   ```

5. **验证**：
   - 在每个群组发送测试消息
   - 查看回复中的模型信息
   - 确认使用了正确的模型

## 实施步骤（方案 2）

1. **修改配置**：
   - 禁用 3 个飞书机器人（content-creator, tech-dev, ai-news）
   - 只保留 main-assistant

2. **重启网关**：
   ```bash
   openclaw gateway restart
   ```

3. **在每个群组中切换 agent**：
   ```
   群组 1：/agent main-agent
   群组 2：/agent content-agent
   群组 3：/agent tech-agent
   群组 4：/agent ainews-agent
   ```

4. **验证**：
   - 在每个群组发送测试消息
   - 查看回复确认使用了正确的 agent

## 结论

**OpenClaw 2026.2.9 不支持多账号自动路由到不同 agent**。

建议：
1. **短期**：使用方案 1（手动切换模型）
2. **长期**：使用方案 2（单机器人 + 群组命令）或等待官方支持

## 相关命令

```bash
# 查看当前 agent
/status

# 切换 agent
/agent <agent-id>

# 切换模型
/model <provider>/<model-id>

# 重置会话
/reset

# 查看可用 agents
openclaw agents list

# 查看可用模型
openclaw models list
```

## 参考

- OpenClaw 版本：2026.2.9
- 文档：docs/03-advanced/09-multi-platform-integration.md
- 配置文件：~/.openclaw/openclaw.json
