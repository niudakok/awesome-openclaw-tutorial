# OpenClaw 多 Agent 正确使用方法

## ✅ 好消息

经过测试确认，`/agent` 命令**是可以工作的**！

从日志可以看到：
```
lane=session:agent:ainews-agent:main
```

这说明 ainews-agent 已经成功启动。

## 🎯 正确的使用步骤

### 步骤 1：重置会话

在群组中先发送：
```
/reset
```

这会清除当前会话，让系统重新识别 agents。

### 步骤 2：切换 Agent

然后立即发送：
```
/agent tech-agent
```

或者其他 agent：
```
/agent content-agent
/agent ainews-agent
/agent main-agent
```

### 步骤 3：验证

发送测试消息或 `/status` 确认 agent 已切换。

## 📋 完整操作流程

### 助理群（使用 main-agent）

```
/reset
/agent main-agent
/status
```

### 内容创作群（使用 content-agent）

```
/reset
/agent content-agent
/status
```

### 技术开发群（使用 tech-agent）

```
/reset
/agent tech-agent
/status
```

### AI 资讯群（使用 ainews-agent）

```
/reset
/agent ainews-agent
/status
```

## ⚠️ 重要提示

1. **必须先 `/reset`**
   - 如果直接使用 `/agent` 可能会提示"未配置"
   - 这是因为当前会话已经绑定到了 main-agent
   - `/reset` 会清除会话，让系统重新识别

2. **会话持久化**
   - 切换成功后，会话会记住选择的 agent
   - 下次对话会继续使用这个 agent
   - 除非再次 `/reset`

3. **验证切换**
   - 使用 `/status` 查看当前 agent
   - 应该看到正确的 agent ID 和模型

## 🔍 故障排查

### 问题：提示"未配置"

**原因**：当前会话已绑定到 main-agent

**解决**：
```
/reset
/agent tech-agent
```

### 问题：切换后还是旧 agent

**原因**：没有先 `/reset`

**解决**：
```
/reset
/agent tech-agent
/status
```

### 问题：不确定当前 agent

**解决**：
```
/status
```

查看输出中的 `Session:` 行，应该显示：
```
Session: agent:tech-agent:feishu:group:oc_xxx
```

## ✅ 成功标志

切换成功后，`/status` 应该显示：

```
🧵 Session: agent:tech-agent:feishu:group:oc_497bcc045e75228209e5030481a6fef7
🧠 Model: local-antigravity/claude-sonnet-4-5-thinking
```

注意 Session 中的 agent ID 应该是 `tech-agent` 而不是 `main-agent`。

## 🎉 开始使用

现在请在每个飞书群组中执行：

1. `/reset`
2. `/agent <agent-id>`
3. `/status` （验证）
4. 发送测试消息

---

## 📊 Agent 对应关系

| 群组 | Agent ID | 模型 | 特点 |
|------|----------|------|------|
| 助理群 | main-agent | claude-opus-4-6-thinking | 最强推理 |
| 内容创作群 | content-agent | claude-sonnet-4-5 | 擅长创作 |
| 技术开发群 | tech-agent | claude-sonnet-4-5-thinking | 技术专家 |
| AI 资讯群 | ainews-agent | gemini-2.5-flash | 快速响应 |

---

**配置完成！`/agent` 命令是可以工作的，只需要先 `/reset` 清除旧会话。** 🎉
