# OpenClaw 教程命令错误修复清单

## 🚨 严重错误：models auth add 命令

### 错误说明

教程中多处使用了错误的命令：
```bash
openclaw models auth add anthropic
```

这个命令会报错：
```
error: too many arguments for 'add'. Expected 0 arguments but got 1.
```

### 正确用法

```bash
# 方式1：交互式添加（推荐）
openclaw models auth add
# 然后按提示选择 provider 和输入 API Key

# 方式2：使用 login 命令
openclaw models auth login
# 支持 OAuth/API key 登录

# 方式3：直接粘贴 token
openclaw models auth paste-token
# 将 token 粘贴到 auth-profiles.json

# 方式4：使用 provider CLI
openclaw models auth setup-token
# 运行 provider CLI 创建/同步 token
```

### 需要修复的文件

#### 1. docs/01-basics/02-installation.md

**位置**: 第 509 行

**错误代码**:
```bash
# WSL2或PowerShell
openclaw models auth add anthropic

# 输入API Key: sk-ant-xxx
```

**修复为**:
```bash
# WSL2或PowerShell
openclaw models auth add
# 按提示选择 anthropic
# 输入API Key: sk-ant-xxx
```

#### 2. TUTORIAL-ERRORS-ANALYSIS-CORRECTED.md

**位置**: 第 189、223 行

**错误代码**:
```bash
# 方式3：认证命令
openclaw models auth add anthropic
```

**修复为**:
```bash
# 方式3：认证命令（交互式）
openclaw models auth add
# 按提示选择 provider
```

### 完整的 API Key 配置指南

#### 推荐方式：使用交互式命令

```bash
# 1. 运行交互式命令
openclaw models auth add

# 2. 选择 provider
? Select provider: (Use arrow keys)
❯ anthropic
  openai
  google
  deepseek
  moonshot

# 3. 输入 API Key
? Enter API Key: sk-ant-xxx

# 4. 验证配置
openclaw models list
```

#### 方式二：使用配置命令

```bash
# 直接设置 API Key
openclaw config set models.providers.anthropic.apiKey "sk-ant-xxx"

# 验证配置
openclaw config get models.providers.anthropic.apiKey
```

#### 方式三：使用环境变量

```bash
# 临时设置（当前会话）
export ANTHROPIC_API_KEY="sk-ant-xxx"

# 永久设置（添加到 ~/.zshrc 或 ~/.bashrc）
echo 'export ANTHROPIC_API_KEY="sk-ant-xxx"' >> ~/.zshrc
source ~/.zshrc
```

#### 方式四：直接编辑配置文件

```bash
# 编辑配置文件
nano ~/.openclaw/openclaw.json

# 添加以下内容
{
  "models": {
    "providers": {
      "anthropic": {
        "apiKey": "sk-ant-xxx"
      }
    }
  }
}
```

### 配置优先级

```
环境变量 > Agent 配置 > 全局配置 > 默认值
```

### 验证配置

```bash
# 检查配置是否生效
openclaw models list

# 测试 API 连接
openclaw channels status

# 查看详细配置
openclaw config get models
```

### 常见问题

#### Q1: 配置后不生效？

```bash
# 重启 Gateway
openclaw gateway restart

# 检查配置文件
openclaw config get models.providers.anthropic.apiKey

# 查看日志
openclaw logs --tail 50
```

#### Q2: 多个 Agent 使用不同的 API Key？

```bash
# 为特定 Agent 配置
openclaw config set models.providers.anthropic.apiKey "sk-ant-xxx" --agent tech-dev

# 验证
openclaw config get models.providers.anthropic.apiKey --agent tech-dev
```

#### Q3: 如何切换 provider？

```bash
# 查看当前 provider
openclaw config get models.default

# 切换 provider
openclaw config set models.default "anthropic/claude-sonnet-4-5"

# 验证
openclaw models list
```

---

## 📝 修复脚本

```bash
#!/bin/bash
# 批量修复教程中的命令错误

echo "开始修复教程中的命令错误..."

# 修复 docs/01-basics/02-installation.md
sed -i '' 's/openclaw models auth add anthropic/openclaw models auth add/g' \
  awesome-openclaw-tutorial/docs/01-basics/02-installation.md

# 修复 TUTORIAL-ERRORS-ANALYSIS-CORRECTED.md
sed -i '' 's/openclaw models auth add anthropic/openclaw models auth add/g' \
  awesome-openclaw-tutorial/TUTORIAL-ERRORS-ANALYSIS-CORRECTED.md

echo "修复完成！"
echo "请手动检查修复结果，并添加必要的说明。"
```

---

## ✅ 修复检查清单

- [ ] 修复 docs/01-basics/02-installation.md
- [ ] 修复 TUTORIAL-ERRORS-ANALYSIS-CORRECTED.md
- [ ] 添加完整的 API Key 配置指南
- [ ] 添加配置优先级说明
- [ ] 添加验证配置的方法
- [ ] 添加常见问题解答
- [ ] 测试所有命令是否正确
- [ ] 更新相关章节的链接

---

**创建时间**: 2026-02-14  
**优先级**: 🔴 高（影响用户首次配置）  
**影响范围**: 所有需要配置 API Key 的用户
