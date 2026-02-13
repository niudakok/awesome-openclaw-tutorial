# OpenClaw 多机器人多模型 - 可行方案

## ❌ 不可行的方案

经过测试，以下方案在 OpenClaw 2026.2.9 中**不工作**：

1. ❌ **Bindings 自动路由** - bindings 配置不生效，所有群组都使用 main-agent
2. ❌ **`/agent` 命令切换** - 机器人无法识别已配置的 agents
3. ❌ **多账号自动路由** - 官方文档明确说明不支持

## ✅ 可行方案：使用 `/model` 命令

在每个飞书群组中使用 `/model` 命令切换模型：

### 步骤 1：在助理群中

```
/model local-antigravity/claude-opus-4-6-thinking
```

### 步骤 2：在内容创作群中

```
/model local-antigravity/claude-sonnet-4-5
```

### 步骤 3：在技术开发群中

```
/model local-antigravity/claude-sonnet-4-5-thinking
```

### 步骤 4：在 AI 资讯群中

```
/model local-antigravity/gemini-2.5-flash
```

## ✅ 验证

发送 `/status` 命令，应该看到：

```
🧠 Model: local-antigravity/claude-sonnet-4-5-thinking
```

## 📋 模型对应关系

| 群组 | 模型 | 特点 |
|------|------|------|
| 助理群 | claude-opus-4-6-thinking | 最强推理，适合复杂任务 |
| 内容创作群 | claude-sonnet-4-5 | 平衡性能，擅长创作 |
| 技术开发群 | claude-sonnet-4-5-thinking | 带推理，适合技术问题 |
| AI 资讯群 | gemini-2.5-flash | 快速响应，成本低 |

## ⚠️ 注意事项

1. **会话持久化**
   - 切换模型后，会话会记住这个设置
   - 下次对话会继续使用选择的模型

2. **重置会话**
   - 使用 `/reset` 后会恢复到默认模型
   - 需要重新切换

3. **新会话**
   - 每次创建新会话（如重启机器人）需要重新切换
   - 建议在群组中固定一条消息说明使用的模型

## 🎯 优点

- ✅ 简单可行，立即生效
- ✅ 不需要修改配置
- ✅ 会话会记住选择
- ✅ 每个群组可以使用不同的模型

## ❌ 缺点

- ❌ 需要手动操作一次
- ❌ 只能切换模型，不能切换 workspace
- ❌ 所有群组共享同一个 agent（main-agent）
- ❌ 重置会话后需要重新切换

## 🔧 故障排查

### 问题：切换后还是使用旧模型

**解决方案**：
```
1. /reset
2. /model local-antigravity/claude-sonnet-4-5-thinking
3. /status
```

### 问题：不知道当前使用的模型

**解决方案**：
```
/status
```

查看输出中的 `🧠 Model:` 行

### 问题：想查看所有可用模型

**解决方案**：
```bash
openclaw models list
```

## 📝 使用建议

### 建议 1：在群组中置顶说明

在每个群组中发送并置顶一条消息：

```
📌 本群使用模型：claude-sonnet-4-5-thinking
如需切换：/model local-antigravity/claude-sonnet-4-5-thinking
```

### 建议 2：创建快捷命令

如果飞书支持，可以创建快捷命令：

```
/tech → /model local-antigravity/claude-sonnet-4-5-thinking
/content → /model local-antigravity/claude-sonnet-4-5
/news → /model local-antigravity/gemini-2.5-flash
```

### 建议 3：定期检查

定期在群组中发送 `/status` 确认使用的模型正确。

## 🎉 开始使用

现在请在每个飞书群组中执行相应的 `/model` 命令！

---

## 📊 总结

经过深入测试和诊断，确认：

1. **OpenClaw 2026.2.9 不支持多账号自动路由到不同 agent**
2. **Bindings 配置虽然正确，但不生效**
3. **`/agent` 命令无法切换到其他 agents**
4. **唯一可行的方案是使用 `/model` 命令切换模型**

虽然这不是最理想的方案（无法切换 workspace 和 tools），但可以实现不同群组使用不同模型的需求。

## 🔮 未来改进

可以考虑：

1. 向 OpenClaw 官方提交 feature request
2. 等待官方支持多账号 + 多 agent 自动路由
3. 或者使用独立的 OpenClaw 实例（复杂度高）

---

**配置完成！请在每个群组中使用 `/model` 命令切换模型。** 🎉
