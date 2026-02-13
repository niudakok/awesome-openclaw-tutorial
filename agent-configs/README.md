# OpenClaw 多 Agent 配置文件

本目录包含4个 Agent 的配置文件，每个 Agent 都有独特的人格和专业领域。

## 📁 目录结构

```
agent-configs/
├── main-agent/          # 主助理
│   ├── USER.md         # 用户信息
│   └── SOUL.md         # 人格设定
├── content-agent/       # 内容创作助手
│   ├── USER.md
│   └── SOUL.md
├── tech-agent/          # 技术开发助手
│   ├── USER.md
│   └── SOUL.md
├── ainews-agent/        # AI 资讯助手
│   ├── USER.md
│   └── SOUL.md
└── README.md           # 本文件
```

## 🤖 Agent 介绍

### 1. main-agent（主助理）
- **定位**：综合助理，负责日常工作协调
- **模型**：Claude Sonnet 4.5
- **工作空间**：`/Users/chinamanor/clawd`
- **飞书群组**：oc_053c93f17fc47e587df58c776f831de5
- **特点**：
  - 高效执行任务
  - 细心周到
  - 主动积极
  - 灵活应变

### 2. content-agent（内容创作助手）
- **定位**：专注内容创作和文档编写
- **模型**：Claude Sonnet 4.5
- **工作空间**：`/Users/chinamanor/clawd/content`
- **飞书群组**：oc_b59b5a7ec4f4605ef19c7381e18441dc
- **特点**：
  - 创意丰富
  - 严谨细致
  - 善于表达
  - 追求卓越

### 3. tech-agent（技术开发助手）
- **定位**：代码开发和技术问题解决
- **模型**：Claude Sonnet 4.5
- **工作空间**：`/Users/chinamanor/clawd/tech`
- **飞书群组**：oc_497bcc045e75228209e5030481a6fef7
- **特点**：
  - 技术精湛
  - 思维严谨
  - 追求卓越
  - 实用主义

### 4. ainews-agent（AI 资讯助手）
- **定位**：AI 领域资讯收集和分析
- **模型**：Gemini 2.5 Flash
- **工作空间**：`/Users/chinamanor/clawd/ainews`
- **飞书群组**：oc_bd1074d29ace112ebbd9cf15a2c9fc2d
- **特点**：
  - 敏锐洞察
  - 客观理性
  - 深度思考
  - 高效执行

## 📋 安装步骤

### 1. 复制文件到对应位置

```bash
# main-agent
cp agent-configs/main-agent/USER.md /Users/chinamanor/clawd/.openclaw/
cp agent-configs/main-agent/SOUL.md /Users/chinamanor/clawd/.openclaw/

# content-agent
mkdir -p /Users/chinamanor/clawd/content/.openclaw
cp agent-configs/content-agent/USER.md /Users/chinamanor/clawd/content/.openclaw/
cp agent-configs/content-agent/SOUL.md /Users/chinamanor/clawd/content/.openclaw/

# tech-agent
mkdir -p /Users/chinamanor/clawd/tech/.openclaw
cp agent-configs/tech-agent/USER.md /Users/chinamanor/clawd/tech/.openclaw/
cp agent-configs/tech-agent/SOUL.md /Users/chinamanor/clawd/tech/.openclaw/

# ainews-agent
mkdir -p /Users/chinamanor/clawd/ainews/.openclaw
cp agent-configs/ainews-agent/USER.md /Users/chinamanor/clawd/ainews/.openclaw/
cp agent-configs/ainews-agent/SOUL.md /Users/chinamanor/clawd/ainews/.openclaw/
```

### 2. 或者使用一键安装脚本

```bash
# 创建安装脚本
cat > install-agents.sh << 'EOF'
#!/bin/bash

BASE_DIR="/Users/chinamanor/clawd"

# 安装 main-agent
echo "安装 main-agent..."
cp agent-configs/main-agent/USER.md "$BASE_DIR/.openclaw/"
cp agent-configs/main-agent/SOUL.md "$BASE_DIR/.openclaw/"

# 安装 content-agent
echo "安装 content-agent..."
mkdir -p "$BASE_DIR/content/.openclaw"
cp agent-configs/content-agent/USER.md "$BASE_DIR/content/.openclaw/"
cp agent-configs/content-agent/SOUL.md "$BASE_DIR/content/.openclaw/"

# 安装 tech-agent
echo "安装 tech-agent..."
mkdir -p "$BASE_DIR/tech/.openclaw"
cp agent-configs/tech-agent/USER.md "$BASE_DIR/tech/.openclaw/"
cp agent-configs/tech-agent/SOUL.md "$BASE_DIR/tech/.openclaw/"

# 安装 ainews-agent
echo "安装 ainews-agent..."
mkdir -p "$BASE_DIR/ainews/.openclaw"
cp agent-configs/ainews-agent/USER.md "$BASE_DIR/ainews/.openclaw/"
cp agent-configs/ainews-agent/SOUL.md "$BASE_DIR/ainews/.openclaw/"

echo "✅ 所有 Agent 配置文件安装完成！"
EOF

# 添加执行权限
chmod +x install-agents.sh

# 执行安装
./install-agents.sh
```

### 3. 重启 Gateway

```bash
openclaw gateway restart
```

### 4. 验证配置

```bash
# 检查配置
openclaw doctor

# 查看日志
openclaw logs --follow
```

## 🧪 测试 Agent

在对应的飞书群组中发送消息测试：

### 测试 main-agent
```
群组：oc_053c93f17fc47e587df58c776f831de5
消息：你好，请介绍一下你自己
预期：主助理的自我介绍
```

### 测试 content-agent
```
群组：oc_b59b5a7ec4f4605ef19c7381e18441dc
消息：帮我写一篇关于 OpenClaw 的介绍文章
预期：专业的内容创作回复
```

### 测试 tech-agent
```
群组：oc_497bcc045e75228209e5030481a6fef7
消息：帮我写一个 Python 脚本，实现文件批量重命名
预期：完整的代码实现
```

### 测试 ainews-agent
```
群组：oc_bd1074d29ace112ebbd9cf15a2c9fc2d
消息：今天有什么重要的 AI 新闻？
预期：AI 资讯汇总
```

## 📝 自定义配置

你可以根据需要修改 `USER.md` 和 `SOUL.md` 文件：

### USER.md
- 用户基本信息
- 工作习惯和偏好
- 技能水平
- 当前项目
- 注意事项

### SOUL.md
- Agent 人格定位
- 性格特征
- 工作原则
- 交互风格
- 专业能力
- 边界意识

## 🔄 更新配置

修改配置文件后，需要重启 Gateway：

```bash
# 修改配置文件
nano /Users/chinamanor/clawd/.openclaw/USER.md

# 重启 Gateway
openclaw gateway restart
```

## ⚠️ 注意事项

1. **文件路径**：确保文件路径正确，与 `openclaw.json` 中的 `workspace` 配置一致
2. **文件权限**：确保 OpenClaw 有读取配置文件的权限
3. **配置生效**：修改配置后需要重启 Gateway
4. **备份配置**：修改前建议备份原配置文件

## 🆘 故障排查

### 问题1：Agent 没有使用配置文件
```bash
# 检查文件是否存在
ls -la /Users/chinamanor/clawd/.openclaw/

# 检查文件权限
chmod 644 /Users/chinamanor/clawd/.openclaw/*.md

# 重启 Gateway
openclaw gateway restart
```

### 问题2：配置文件路径错误
```bash
# 检查 openclaw.json 中的 workspace 配置
cat ~/.openclaw/openclaw.json | grep workspace

# 确保配置文件在正确的位置
```

### 问题3：Agent 行为异常
```bash
# 查看日志
openclaw logs --follow

# 检查配置文件内容
cat /Users/chinamanor/clawd/.openclaw/SOUL.md
```

## 📚 相关文档

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [多 Agent 配置指南](../docs/03-advanced/09-multi-platform-integration.md)
- [Agent 人格设定最佳实践](../docs/03-advanced/11-advanced-configuration.md)

## 🤝 贡献

如果你有更好的配置建议，欢迎提交 PR 或 Issue！

---

**最后更新**：2026年2月13日  
**版本**：v1.0  
**作者**：Maynor
