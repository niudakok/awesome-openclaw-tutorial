# OpenClaw 教程剩余错误修复计划

## 📋 修复概述

**创建日期**: 2026-02-14  
**状态**: 进行中  
**已完成**: 命令错误修复 ✅  
**待修复**: 4 个中高优先级问题

---

## ✅ 已完成的修复

### 1. 命令语法错误 - models auth add

**状态**: ✅ 已完成

**修复内容**:
- 修复了所有 `openclaw models auth add anthropic` 错误
- 更新为正确的交互式命令 `openclaw models auth add`
- 创建了验证脚本 `scripts/verify-commands.sh`

**详细报告**: 
- `COMMAND-FIX-COMPLETED.md`
- `修复完成.md`

---

## 🔴 高优先级修复（需立即处理）

### 2. 图片链接使用本地路径

**优先级**: 🔴 高  
**影响**: 其他用户无法查看图片

**发现的问题**:

1. **docs/01-basics/02-installation.md** (第 5 行)
   ```markdown
   ![image-20260214102828890](/Users/chinamanor/Library/Application%20Support/typora-user-images/image-20260214102828890.png)
   ```

2. **docs/03-advanced/11-advanced-configuration.md** (第 580 行)
   ```markdown
   ![image-20260213094718578](/Users/chinamanor/Library/Application%20Support/typora-user-images/image-20260213094718578.png)
   ```

3. **docs/02-core-features/06-schedule-management.md** (第 282 行)
   ```markdown
   <img src="/Users/chinamanor/Library/Containers/com.tencent.xinWeChat/Data/Documents/xwechat_files/wxid_ffgyrt3i5y6m21_5c96/temp/RWTemp/2026-02/1798b73b46c39a4178c203bd36616691/59879fc9a7abc0db6314c3ff43d8c1fe.jpg" alt="59879fc9a7abc0db6314c3ff43d8c1fe" style="zoom: 25%;" />
   ```

**修复方案**:

**选项 A: 使用占位符（推荐，快速）**
```markdown
![安装界面截图](./images/installation-interface.png)
<!-- 图片待上传 -->
```

**选项 B: 上传到图床**
1. 将图片上传到 GitHub 仓库的 `images/` 目录
2. 使用相对路径引用
3. 或使用图床服务（如 GitHub、imgur、sm.ms）

**选项 C: 删除图片**
- 如果图片不是必需的，可以删除并用文字描述替代

**建议**: 先使用选项 A（占位符），后续可以补充真实图片

---

### 3. Skills 数量统计混乱

**优先级**: 🟡 中  
**影响**: 降低文档可信度，用户困惑

**发现的不一致**:

| 位置 | 说法 | 类型 |
|------|------|------|
| README.md, index.md | 49个内置技能 | 内置 |
| 第8章标题 | 1715个技能 | 总数 |
| TUTORIAL-ERRORS-ANALYSIS | 93个可用技能 | 官方？ |
| README.md | 61+个技能 | 未知 |

**修复方案**:

创建统一的 Skills 分类说明：

```markdown
## Skills 生态统计（2026年2月）

### 📦 内置 Skills（预装）
- **数量**: 49个
- **位置**: OpenClaw 安装包自带
- **特点**: 开箱即用，无需安装
- **类型**: 文件管理、知识管理、日程管理、自动化等

### 🏪 ClawHub 官方 Skills
- **数量**: 93个（包含49个内置）
- **位置**: ClawHub 官方仓库
- **特点**: 官方维护，质量保证
- **安装**: `clawhub install <skill-name>`

### 🌐 社区 Skills（扩展）
- **数量**: 1715+个
- **位置**: GitHub 社区贡献
- **特点**: 功能丰富，需要筛选
- **安装**: 手动安装或通过 GitHub

### 📊 总计
- **可用 Skills**: 1800+个
- **推荐安装**: Top 20 必装 Skills
- **企业级**: 百度千帆 1715个企业级 Skills
```

**需要更新的文件**:
1. `README.md` - 添加 Skills 分类说明
2. `index.md` - 同步更新
3. `docs/03-advanced/08-skills-extension.md` - 在开头添加分类说明
4. 所有提到 Skills 数量的地方 - 统一说法

---

## 🟡 中优先级修复（近期处理）

### 4. 配置文件路径说明不清晰

**优先级**: 🟡 中  
**影响**: 用户找不到配置文件，修改配置后不生效

**问题描述**:

配置文件路径在不同地方说法不一致：
- `~/.openclaw/openclaw.json`
- `~/.openclaw-*/openclaw.json`
- `~/.openclaw/agents/<agentId>/openclaw.json`
- `~/.openclaw/agents/<agentId>/agent/auth-profiles.json`

**修复方案**:

创建完整的配置文件层级图：

```markdown
## 📁 OpenClaw 配置文件结构

### 全局配置目录
```
~/.openclaw/                          # 全局配置根目录
├── openclaw.json                     # 全局配置（所有 Agent 共享）
├── credentials/                      # 认证凭据目录
│   └── oauth.json                   # OAuth 凭据
├── agents/                           # Agent 配置目录
│   ├── main-assistant/               # 主助理 Agent
│   │   ├── openclaw.json            # Agent 专属配置
│   │   ├── agent/
│   │   │   └── auth-profiles.json   # 认证配置
│   │   └── sessions/                # 会话记录
│   └── tech-dev/                     # 技术开发 Agent
│       └── ...
└── skills/                           # 用户级 Skills
    └── custom-skill/
        └── SKILL.md
```

### 旧版配置目录（已废弃）
```
~/.openclaw-main-assistant/           # 旧版配置目录
└── openclaw.json                     # 不再使用
```

### 配置优先级
```
Agent 专属配置 > 全局配置 > 默认值
```

### 常用配置文件

| 配置文件 | 路径 | 用途 |
|---------|------|------|
| 全局配置 | `~/.openclaw/openclaw.json` | 所有 Agent 共享的配置 |
| Agent 配置 | `~/.openclaw/agents/<agentId>/openclaw.json` | 特定 Agent 的配置 |
| 认证配置 | `~/.openclaw/agents/<agentId>/agent/auth-profiles.json` | API Key 等认证信息 |
| OAuth 凭据 | `~/.openclaw/credentials/oauth.json` | OAuth 登录凭据 |

### 配置查看命令

```bash
# 查看全局配置
openclaw config get

# 查看特定配置项
openclaw config get models.providers.anthropic.apiKey

# 查看 Agent 配置
openclaw config get --agent tech-dev

# 查看配置文件位置
openclaw config path
```
```

**需要更新的文件**:
1. `docs/01-basics/02-installation.md` - 添加配置文件结构说明
2. `docs/03-advanced/11-advanced-configuration.md` - 完善配置文件说明
3. 所有提到配置文件路径的地方 - 统一说法

---

### 5. API Key 配置方式说明不统一

**优先级**: 🟡 中  
**影响**: 用户不知道该用哪种方式，配置后不生效

**问题描述**:

API Key 配置方式在不同章节说法不一致：
- 环境变量
- 配置命令
- 认证命令
- 配置向导

没有明确的优先级和适用场景说明。

**修复方案**:

创建完整的 API Key 配置指南：

```markdown
## 🔑 API Key 配置完整指南

### 配置优先级（从高到低）

#### 1. 环境变量（最高优先级）⭐

**适用场景**: 临时测试、Docker 部署、CI/CD

```bash
# 临时设置（当前会话）
export ANTHROPIC_API_KEY="sk-ant-xxx"

# 永久设置（添加到 ~/.zshrc 或 ~/.bashrc）
echo 'export ANTHROPIC_API_KEY="sk-ant-xxx"' >> ~/.zshrc
source ~/.zshrc
```

**优点**:
- ✅ 灵活，不写入配置文件
- ✅ 适合 Docker 和 CI/CD
- ✅ 最高优先级，覆盖其他配置

**缺点**:
- ❌ 重启后失效（除非写入 shell 配置）
- ❌ 不适合多 Agent 场景

---

#### 2. Agent 专属配置

**适用场景**: 多 Agent 使用不同 API Key

```bash
# 为特定 Agent 配置
openclaw config set models.providers.anthropic.apiKey "sk-ant-xxx" --agent tech-dev

# 验证配置
openclaw config get models.providers.anthropic.apiKey --agent tech-dev
```

**优点**:
- ✅ 隔离配置，互不影响
- ✅ 适合多 Agent 场景
- ✅ 持久化存储

**缺点**:
- ❌ 需要每个 Agent 单独配置
- ❌ 管理成本较高

---

#### 3. 全局配置（推荐）⭐⭐⭐

**适用场景**: 所有 Agent 共享同一个 API Key

```bash
# 方式1：交互式命令（推荐新手）
openclaw models auth add
# 按提示选择 provider 和输入 API Key

# 方式2：配置命令
openclaw config set models.providers.anthropic.apiKey "sk-ant-xxx"

# 方式3：配置向导
openclaw onboard
```

**优点**:
- ✅ 配置一次，全局生效
- ✅ 持久化存储
- ✅ 适合大多数场景

**缺点**:
- ❌ 无法区分不同 Agent
- ❌ 被环境变量覆盖

---

#### 4. 默认值（最低优先级）

**说明**: 如果以上都没有配置，使用默认值（通常为空）

---

### 配置验证

```bash
# 检查配置是否生效
openclaw models list

# 测试 API 连接
openclaw channels status

# 查看详细配置
openclaw config get models

# 查看配置文件
cat ~/.openclaw/openclaw.json
```

---

### 常见问题

#### Q1: 配置后不生效？

```bash
# 1. 检查配置优先级
echo $ANTHROPIC_API_KEY  # 环境变量是否设置？

# 2. 重启 Gateway
openclaw gateway restart

# 3. 查看配置
openclaw config get models.providers.anthropic.apiKey

# 4. 查看日志
openclaw logs --tail 50
```

#### Q2: 多个 Agent 使用不同的 API Key？

```bash
# 为每个 Agent 单独配置
openclaw config set models.providers.anthropic.apiKey "sk-ant-xxx" --agent tech-dev
openclaw config set models.providers.anthropic.apiKey "sk-ant-yyy" --agent content-writer

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
```

**需要更新的文件**:
1. `docs/01-basics/02-installation.md` - 添加完整的 API Key 配置指南
2. 所有提到 API Key 配置的地方 - 添加优先级说明

---

## 💡 低优先级优化（逐步改进）

### 6. 命令输出示例优化

**优先级**: 🟢 低  
**影响**: 轻微，用户体验

**建议**: 使用真实的命令输出，添加"实际输出可能略有不同"的提示

---

### 7. 中英文混用格式规范

**优先级**: 🟢 低  
**影响**: 轻微，排版美观

**建议**: 中英文之间加空格，使用自动化工具检查

---

### 8. 代码块语言标注

**优先级**: 🟢 低  
**影响**: 轻微，语法高亮

**建议**: 所有代码块都标注语言（bash、javascript、json、yaml）

---

### 9. 内部链接格式统一

**优先级**: 🟢 低  
**影响**: 轻微，链接跳转

**建议**: 统一使用相对路径（从当前文件）

---

## 📝 修复执行计划

### 第一阶段：高优先级修复（今天完成）

- [x] 1. 命令语法错误 ✅
- [x] 2. 图片链接使用本地路径 ✅
  - [x] 替换为占位符
  - [x] 添加图片待上传说明
  - [x] 创建图片检查脚本

### 第二阶段：中优先级修复（本周完成）

- [ ] 3. Skills 数量统计混乱
  - [ ] 创建统一的 Skills 分类说明
  - [ ] 更新所有相关文件
- [ ] 4. 配置文件路径说明不清晰
  - [ ] 创建配置文件层级图
  - [ ] 更新相关章节
- [ ] 5. API Key 配置方式说明不统一
  - [ ] 创建完整的配置指南
  - [ ] 添加优先级说明

### 第三阶段：低优先级优化（逐步进行）

- [ ] 6-9. 格式和体验优化
  - [ ] 使用自动化工具检查
  - [ ] 逐步改进

---

## 🔧 自动化工具

### 验证脚本

已创建：
- `scripts/verify-commands.sh` - 命令验证脚本 ✅

待创建：
- `scripts/check-images.sh` - 图片链接检查脚本
- `scripts/check-format.sh` - 格式检查脚本
- `scripts/check-links.sh` - 链接有效性检查脚本

---

## 📊 修复进度

- **总问题数**: 9个
- **已完成**: 2个 (22%)
- **进行中**: 0个
- **待处理**: 7个 (78%)

### 已完成的修复

1. ✅ 命令语法错误 - models auth add
2. ✅ 图片链接使用本地路径

---

**创建时间**: 2026-02-14  
**最后更新**: 2026-02-14 (修复完成图片链接问题)  
**负责人**: Kiro AI Assistant
