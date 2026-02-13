# OpenClaw 多 Agent 路由 - 最终诊断

## 当前状态

### ✅ 配置正确

1. **Agents 配置** - 4 个 agents 都已正确配置
   ```
   - main-agent    (Claude Opus 4.6 Thinking)
   - content-agent (Claude Sonnet 4.5)
   - tech-agent    (Claude Sonnet 4.5 Thinking)
   - ainews-agent  (Gemini 2.5 Flash)
   ```

2. **AgentDir 配置** - 所有 agents 都有 agentDir
   ```
   ~/.openclaw/agents/main-agent/agent
   ~/.openclaw/agents/content-agent/agent
   ~/.openclaw/agents/tech-agent/agent
   ~/.openclaw/agents/ainews-agent/agent
   ```

3. **Routing Rules 配置** - Bindings 已正确识别
   ```
   main-agent    → feishu peer=group:oc_053c93f17fc47e587df58c776f831de5
   content-agent → feishu peer=group:oc_b59b5a7ec4f4605ef19c7381e18441dc
   tech-agent    → feishu peer=group:oc_497bcc045e75228209e5030481a6fef7
   ainews-agent  → feishu peer=group:oc_bd1074d29ace112ebbd9cf15a2c9fc2d
   ```

### ❌ 问题

尽管配置正确，但实际运行时所有群组都使用 `main-agent`。

## 可能的原因

### 1. Default Agent 优先级问题

main-agent 被标记为 `(default)`，可能导致：
- 默认 agent 优先级高于 bindings
- Bindings 匹配失败时回退到默认 agent
- 所有未匹配的请求都使用默认 agent

### 2. Bindings 匹配逻辑问题

可能的匹配失败原因：
- 群组 ID 格式问题
- Channel 名称不匹配
- Peer kind 不匹配
- OpenClaw 版本的 bug

### 3. 会话持久化问题

从 doctor 输出可以看到：
```
Session store (main-agent): ~/.openclaw/agents/main-agent/sessions/sessions.json (10 entries)
- agent:main-agent:feishu:group:oc_053c93f17fc47e587df58c776f831de5 (5m ago)
- agent:main-agent:feishu:group:oc_b59b5a7ec4f4605ef19c7381e18441dc (6m ago)
- agent:main-agent:feishu:group:oc_497bcc045e75228209e5030481a6fef7 (6m ago)
- agent:main-agent:feishu:group:oc_bd1074d29ace112ebbd9cf15a2c9fc2d (25m ago)
```

**所有群组的会话都存储在 main-agent 的 session store 中！**

这可能意味着：
- 会话一旦创建就绑定到 main-agent
- 即使 bindings 配置正确，已存在的会话不会切换 agent
- 需要清除旧会话才能让 bindings 生效

## 解决方案

### 方案 1：清除旧会话（推荐）

```bash
# 停止网关
openclaw gateway stop

# 清除所有会话
rm -rf ~/.openclaw/agents/*/sessions/

# 重启网关
openclaw gateway install

# 测试
./final-test.sh
```

### 方案 2：手动重置会话

在每个群组中发送命令：
```
/reset
```

然后重新发送消息测试。

### 方案 3：修改默认 Agent

如果 main-agent 作为默认 agent 导致问题，可以尝试：

1. 移除 main-agent 的 default 标记
2. 或者将其他 agent 设为 default

但这可能不是根本解决方案。

## 测试步骤

1. **清除会话**
   ```bash
   openclaw gateway stop
   rm -rf ~/.openclaw/agents/*/sessions/
   openclaw gateway install
   ```

2. **在 4 个群组中发送新消息**
   - 群组 1: "测试1"
   - 群组 2: "测试2"
   - 群组 3: "测试3"
   - 群组 4: "测试4"

3. **运行监控脚本**
   ```bash
   ./final-test.sh
   ```

4. **检查结果**
   - 如果每个群组使用了正确的 agent → ✅ 问题解决
   - 如果还是都使用 main-agent → 可能是 OpenClaw 的 bug

## 如果还是不工作

### 临时解决方案

在每个群组中手动切换 agent：

```
群组 1: /agent main-agent
群组 2: /agent content-agent
群组 3: /agent tech-agent
群组 4: /agent ainews-agent
```

### 长期解决方案

1. 升级 OpenClaw 到最新版本
2. 查看 OpenClaw GitHub Issues 是否有类似问题
3. 提交 bug 报告，包含：
   - OpenClaw 版本：2026.2.9
   - 配置文件
   - 日志输出
   - 预期行为 vs 实际行为

## 参考信息

- OpenClaw 版本：2026.2.9 (33c75cb)
- 配置文件：`~/.openclaw/openclaw.json`
- 日志文件：`/tmp/openclaw/openclaw-2026-02-13.log`
- Session 存储：`~/.openclaw/agents/*/sessions/`

## 下一步

**立即尝试方案 1（清除会话）**，这是最有可能解决问题的方法。
