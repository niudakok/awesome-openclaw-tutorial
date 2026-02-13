# OpenClaw 预置技能完全指南

> 💡 **核心价值**：OpenClaw 内置了 93 个精选技能，覆盖办公自动化、开发工具、智能家居、内容创作等场景，让你的 AI 助手从"能说"到"能做"。

> ⚠️ **重要提示**：本文基于 OpenClaw 2026.2.9 版本编写，包含 49 个内置技能（预装）、40 个工作区技能（可选）和 4 个额外技能，共计 93 个可用技能。

---

## 📋 目录

- [技能概览](#技能概览)
- [技能分类](#技能分类)
- [核心技能详解](#核心技能详解)
- [技能安装与管理](#技能安装与管理)
- [实战应用场景](#实战应用场景)
- [常见问题](#常见问题)

---

## 技能概览

### 什么是 OpenClaw 技能？

OpenClaw 技能（Skills）是扩展 AI 助手能力的插件系统。通过安装不同的技能，你可以让 OpenClaw：

- 🔐 管理密码和敏感信息（1Password）
- 📝 操作 Apple Notes 和 Reminders
- 🔍 实时搜索互联网（Brave Search）
- 🎨 生成和编辑图片（Nano Banana Pro）
- 📧 收发邮件（Himalaya）
- 🏠 控制智能家居（OpenHue、Eight Sleep）
- 💬 发送消息（iMessage、WhatsApp、Slack）
- 🎵 控制音乐播放（Spotify、Sonos）
- 📊 管理项目（GitHub、Notion、Trello）
- 🌐 自动化浏览器操作（Playwright）

### 技能统计

| 类别 | 数量 | 状态 |
|------|------|------|
| 内置技能 | 49 | ✅ 预装可用 |
| 工作区技能 | 40 | 📦 可选安装 |
| 额外技能 | 4 | 📦 可选安装 |
| **总计** | **93** | - |

> 💡 **说明**：
> - **内置技能**：OpenClaw 预装的 49 个核心技能，开箱即用
> - **工作区技能**：可选安装的 40 个扩展技能，按需添加
> - **额外技能**：社区贡献的 4 个特殊技能



---

## 技能分类

### 🔐 安全与认证（2个）

#### 1. 1Password
- **状态**：✅ 已安装
- **功能**：管理密码、API密钥、敏感信息
- **使用场景**：
  - 安全存储 API 密钥
  - 快速填充登录信息
  - 团队密码共享
- **命令示例**：
  ```
  你：从1Password获取GitHub的API密钥
  OpenClaw：已获取，密钥为：ghp_xxxx...
  ```

### 📝 笔记与提醒（2个）

#### 2. Apple Notes
- **状态**：✅ 已安装
- **功能**：通过 `memo` CLI 管理 macOS 备忘录
- **使用场景**：
  - 创建、查看、编辑笔记
  - 搜索笔记内容
  - 导出笔记为 Markdown
- **命令示例**：
  ```
  你：在备忘录里创建一个购物清单
  OpenClaw：已创建！内容：
  - 牛奶
  - 面包
  - 鸡蛋
  ```

#### 3. Apple Reminders
- **状态**：✅ 已安装
- **功能**：通过 `remindctl` CLI 管理 macOS 提醒事项
- **使用场景**：
  - 添加、编辑、完成提醒
  - 按日期筛选
  - 管理提醒列表
- **命令示例**：
  ```
  你：明天下午3点提醒我开会
  OpenClaw：已添加提醒：明天 15:00 - 开会
  ```

### 🔍 搜索与信息获取（3个）

#### 4. Brave Search
- **状态**：✅ 已安装
- **功能**：实时互联网搜索
- **使用场景**：
  - 查找最新资讯
  - 技术问题排查
  - 竞品调研
- **命令示例**：
  ```
  你：搜索2026年AI发展趋势
  OpenClaw：[搜索中...] 找到以下内容：
  1. AI Agent成为主流...
  2. 多模态模型普及...
  ```

#### 5. Google Places
- **状态**：⚠️ 需要API密钥
- **功能**：查询地点信息、评价、营业时间
- **使用场景**：
  - 查找附近餐厅
  - 获取地点详情
  - 查看用户评价

#### 6. Session Logs
- **状态**：✅ 已安装
- **功能**：搜索和分析历史对话记录
- **使用场景**：
  - 查找之前的对话
  - 分析使用习惯
  - 导出对话记录



### 💻 开发工具（8个）

#### 7. GitHub
- **状态**：✅ 已安装
- **功能**：通过 `gh` CLI 管理 GitHub
- **使用场景**：
  - 创建、查看 Issue 和 PR
  - 管理 CI/CD 运行
  - 查询仓库信息
- **命令示例**：
  ```
  你：列出我的GitHub仓库中未关闭的Issue
  OpenClaw：找到3个Issue：
  1. #42 - 修复登录bug
  2. #38 - 添加暗黑模式
  3. #35 - 优化性能
  ```

#### 8. Coding Agent
- **状态**：✅ 已安装
- **功能**：运行 Codex CLI、Claude Code、OpenCode 等编程助手
- **使用场景**：
  - 代码生成和重构
  - Bug 修复
  - 代码审查

#### 9. Obsidian
- **状态**：✅ 已安装
- **功能**：管理 Obsidian 笔记库
- **使用场景**：
  - 创建和编辑 Markdown 笔记
  - 管理知识图谱
  - 自动化笔记工作流

#### 10. Oracle
- **状态**：⚠️ 需要安装
- **功能**：AI 编程助手最佳实践
- **使用场景**：
  - 代码提示和补全
  - 文件打包
  - 会话管理

#### 11. Skill Creator
- **状态**：✅ 已安装
- **功能**：创建和更新 AgentSkills
- **使用场景**：
  - 设计技能结构
  - 打包技能资源
  - 发布技能到 ClawHub

#### 12. McPorter
- **状态**：⚠️ 需要安装
- **功能**：MCP 服务器管理和调用
- **使用场景**：
  - 配置 MCP 服务器
  - 调用 MCP 工具
  - 管理认证信息

### 📧 通讯与协作（5个）

#### 13. Himalaya
- **状态**：⚠️ 需要安装
- **功能**：命令行邮件客户端（IMAP/SMTP）
- **使用场景**：
  - 收发邮件
  - 搜索邮件
  - 管理邮件文件夹
- **命令示例**：
  ```
  你：查看今天收到的邮件
  OpenClaw：今天收到5封邮件：
  1. [工作] 项目进度更新
  2. [通知] 账单提醒
  ...
  ```

#### 14. iMessage (imsg)
- **状态**：⚠️ 需要安装
- **功能**：命令行发送 iMessage/SMS
- **使用场景**：
  - 发送消息
  - 查看聊天记录
  - 监控新消息

#### 15. Slack
- **状态**：⚠️ 需要配置
- **功能**：Slack 消息管理
- **使用场景**：
  - 发送消息
  - 添加表情反应
  - 固定/取消固定消息

#### 16. WhatsApp (wacli)
- **状态**：⚠️ 需要安装
- **功能**：WhatsApp 消息管理
- **使用场景**：
  - 发送消息
  - 搜索聊天记录
  - 同步消息历史

#### 17. BlueBubbles
- **状态**：⚠️ 需要配置
- **功能**：iMessage 集成（推荐方案）
- **使用场景**：
  - 发送和接收 iMessage
  - 管理群聊
  - 消息自动化



### 🎨 创意与多媒体（10个）

#### 18. Nano Banana Pro
- **状态**：⚠️ 需要 API 密钥
- **功能**：通过 Gemini 3 Pro Image 生成和编辑图片
- **使用场景**：
  - AI 绘画
  - 图片编辑
  - 创意设计
- **命令示例**：
  ```
  你：画一只可爱的橙色猫咪
  OpenClaw：[生成中...] 已生成！[发送图片]
  ```

#### 19. OpenAI Image Gen
- **状态**：⚠️ 需要 API 密钥
- **功能**：批量生成图片（OpenAI DALL-E）
- **使用场景**：
  - 批量生成图片
  - 随机提示词采样
  - 生成图片画廊

#### 20. OpenAI Whisper (本地)
- **状态**：⚠️ 需要安装
- **功能**：本地语音转文字
- **使用场景**：
  - 音频转录
  - 会议记录
  - 字幕生成

#### 21. OpenAI Whisper API
- **状态**：⚠️ 需要 API 密钥
- **功能**：云端语音转文字
- **使用场景**：
  - 高质量转录
  - 多语言支持
  - 快速处理

#### 22. Sag (ElevenLabs TTS)
- **状态**：⚠️ 需要安装和 API 密钥
- **功能**：文字转语音（类似 macOS say 命令）
- **使用场景**：
  - 生成语音
  - 有声读物
  - 语音提醒

#### 23. Sherpa-ONNX TTS
- **状态**：⚠️ 需要配置
- **功能**：本地文字转语音（离线）
- **使用场景**：
  - 离线语音生成
  - 隐私保护
  - 低延迟

#### 24. Video Frames
- **状态**：⚠️ 需要安装 ffmpeg
- **功能**：提取视频帧和片段
- **使用场景**：
  - 视频截图
  - 提取关键帧
  - 生成 GIF

#### 25. Gifgrep
- **状态**：⚠️ 需要安装
- **功能**：搜索和下载 GIF
- **使用场景**：
  - 搜索 GIF
  - 下载动图
  - 提取静态帧

#### 26. Songsee
- **状态**：⚠️ 需要安装
- **功能**：生成音频频谱图和可视化
- **使用场景**：
  - 音频分析
  - 频谱可视化
  - 音乐制作

#### 27. Camsnap
- **状态**：⚠️ 需要安装
- **功能**：从 RTSP/ONVIF 摄像头捕获画面
- **使用场景**：
  - 监控截图
  - 视频录制
  - 安防集成



### 🏠 智能家居（5个）

#### 28. OpenHue
- **状态**：⚠️ 需要安装
- **功能**：控制 Philips Hue 智能灯
- **使用场景**：
  - 开关灯光
  - 调节亮度和颜色
  - 场景切换
- **命令示例**：
  ```
  你：把客厅的灯调成暖黄色
  OpenClaw：已调整！客厅灯光已设置为暖黄色
  ```

#### 29. Eight Sleep (eightctl)
- **状态**：⚠️ 需要安装
- **功能**：控制 Eight Sleep 智能床垫
- **使用场景**：
  - 调节床温
  - 设置闹钟
  - 查看睡眠数据

#### 30. Sonos CLI
- **状态**：⚠️ 需要安装
- **功能**：控制 Sonos 音响
- **使用场景**：
  - 播放音乐
  - 调节音量
  - 分组管理

#### 31. Blucli
- **状态**：⚠️ 需要安装
- **功能**：BluOS CLI（Bluesound 音响）
- **使用场景**：
  - 设备发现
  - 播放控制
  - 音量调节

#### 32. Peekaboo
- **状态**：✅ 已安装
- **功能**：捕获和自动化 macOS UI
- **使用场景**：
  - 屏幕截图
  - UI 自动化
  - 应用控制

### 🎵 音乐与娱乐（2个）

#### 33. Spotify Player
- **状态**：⚠️ 需要配置
- **功能**：终端 Spotify 播放器
- **使用场景**：
  - 搜索音乐
  - 播放控制
  - 歌单管理
- **命令示例**：
  ```
  你：播放周杰伦的歌
  OpenClaw：正在播放：周杰伦 - 晴天
  ```

#### 34. Weather
- **状态**：✅ 已安装
- **功能**：天气查询（无需 API 密钥）
- **使用场景**：
  - 查询当前天气
  - 获取天气预报
  - 多城市对比

### 📊 办公与生产力（12个）

#### 35. Notion
- **状态**：✅ 已安装
- **功能**：Notion API 集成
- **使用场景**：
  - 创建和管理页面
  - 数据库操作
  - 内容同步

#### 36. Trello
- **状态**：⚠️ 需要 API 密钥
- **功能**：Trello 看板管理
- **使用场景**：
  - 创建卡片
  - 管理列表
  - 团队协作

#### 37. Things (macOS)
- **状态**：⚠️ 需要安装
- **功能**：Things 3 任务管理
- **使用场景**：
  - 添加任务
  - 管理项目
  - 查询待办事项

#### 38. Google Workspace (gog)
- **状态**：⚠️ 需要安装
- **功能**：Google 全家桶 CLI
- **使用场景**：
  - Gmail 邮件管理
  - Google Calendar 日程
  - Google Drive 文件
  - Google Sheets 表格

#### 39. Summarize
- **状态**：⚠️ 需要安装
- **功能**：总结和提取文本/转录
- **使用场景**：
  - URL 内容总结
  - 播客转录
  - 本地文件提取

#### 40. Nano PDF
- **状态**：⚠️ 需要安装
- **功能**：自然语言编辑 PDF
- **使用场景**：
  - PDF 文本编辑
  - 表单填写
  - 文档处理

#### 41. Model Usage
- **状态**：⚠️ 需要安装 CodexBar
- **功能**：查看模型使用统计
- **使用场景**：
  - 成本分析
  - 使用量统计
  - 模型对比

#### 42. Blogwatcher
- **状态**：⚠️ 需要安装
- **功能**：监控博客和 RSS/Atom 订阅
- **使用场景**：
  - 博客更新提醒
  - RSS 订阅管理
  - 内容聚合

#### 43. Ordercli
- **状态**：⚠️ 需要安装
- **功能**：外卖订单查询（Foodora）
- **使用场景**：
  - 查看历史订单
  - 追踪配送状态

#### 44. Tmux
- **状态**：⚠️ 需要安装
- **功能**：远程控制 tmux 会话
- **使用场景**：
  - 发送命令
  - 读取输出
  - 会话管理

#### 45. Healthcheck
- **状态**：✅ 已安装
- **功能**：主机安全加固和风险配置
- **使用场景**：
  - 安全审计
  - 防火墙配置
  - SSH 加固

#### 46. Voice Call
- **状态**：⚠️ 需要配置插件
- **功能**：启动语音通话
- **使用场景**：
  - 语音对话
  - 实时交互



### 🤖 AI 与 LLM（3个）

#### 47. Gemini
- **状态**：✅ 已安装
- **功能**：Gemini CLI 编程辅助和搜索
- **使用场景**：
  - 代码生成
  - 问题解答
  - Google 搜索

#### 48. ClawHub
- **状态**：✅ 已安装
- **功能**：ClawHub CLI 技能管理
- **使用场景**：
  - 搜索技能
  - 安装技能
  - 发布技能
- **命令示例**：
  ```
  你：从ClawHub安装brave-search技能
  OpenClaw：[安装中...] 已安装！brave-search v1.0.0
  ```

#### 49. Transcript API
- **状态**：✅ 已安装
- **功能**：抓取 YouTube 视频字幕
- **使用场景**：
  - 提取视频字幕
  - 生成时间戳
  - 内容分析

### 🌐 网络与自动化（3个）

#### 50. Bear Notes
- **状态**：✅ 已安装
- **功能**：通过 grizzly CLI 管理 Bear 笔记
- **使用场景**：
  - 创建笔记
  - 搜索内容
  - 标签管理

#### 51. Design Doc Mermaid
- **状态**：✅ 已安装（推测）
- **功能**：生成 Mermaid 图表
- **使用场景**：
  - 架构图
  - 流程图
  - 时序图

#### 52. File System Manager
- **状态**：✅ 已安装（推测）
- **功能**：本地文件系统管理
- **使用场景**：
  - 文件读写
  - 批量操作
  - 目录管理

---

## 核心技能详解

### 🌟 必装技能 Top 10

根据使用频率和实用性，以下是最推荐安装的 10 个技能：

| 排名 | 技能 | 分类 | 推荐理由 | 安装难度 |
|------|------|------|----------|----------|
| 1 | **Brave Search** | 搜索 | 实时互联网搜索，解决信息过时问题 | ⭐ 简单 |
| 2 | **GitHub** | 开发 | 开发者必备，管理代码仓库 | ⭐ 简单 |
| 3 | **Nano Banana Pro** | 创意 | AI 绘画，创意工作必备 | ⭐⭐ 中等 |
| 4 | **Apple Notes** | 笔记 | Mac 用户必备，无缝集成 | ⭐ 简单 |
| 5 | **Apple Reminders** | 提醒 | 日程管理，跨设备同步 | ⭐ 简单 |
| 6 | **Notion** | 办公 | 知识管理，团队协作 | ⭐⭐ 中等 |
| 7 | **Weather** | 工具 | 天气查询，无需 API | ⭐ 简单 |
| 8 | **Peekaboo** | 工具 | 截图和 UI 自动化 | ⭐ 简单 |
| 9 | **ClawHub** | 管理 | 技能市场，扩展能力 | ⭐ 简单 |
| 10 | **1Password** | 安全 | 密码管理，保护隐私 | ⭐⭐ 中等 |

### 🎯 场景化技能推荐

#### 场景1：内容创作者

**推荐技能组合**：
- Brave Search（资料搜索）
- Nano Banana Pro（配图生成）
- Summarize（内容总结）
- Notion（内容管理）
- Transcript API（视频字幕）

**工作流示例**：
```
1. 用 Brave Search 搜索热点话题
2. 用 Summarize 总结相关文章
3. 用 Nano Banana Pro 生成配图
4. 用 Notion 整理内容
5. 发布到各平台
```

#### 场景2：程序员

**推荐技能组合**：
- GitHub（代码管理）
- Coding Agent（代码生成）
- Obsidian（技术笔记）
- Gemini（编程辅助）
- Tmux（终端管理）

**工作流示例**：
```
1. 用 GitHub 查看 Issue
2. 用 Coding Agent 生成代码
3. 用 Obsidian 记录技术笔记
4. 用 Gemini 解决技术问题
5. 用 Tmux 管理开发环境
```

#### 场景3：知识工作者

**推荐技能组合**：
- Apple Notes（快速记录）
- Apple Reminders（任务管理）
- Notion（知识库）
- Google Workspace（办公套件）
- Things（GTD 管理）

**工作流示例**：
```
1. 用 Apple Notes 快速记录想法
2. 用 Apple Reminders 设置提醒
3. 用 Notion 整理知识库
4. 用 Google Workspace 处理邮件和日程
5. 用 Things 管理项目任务
```

#### 场景4：智能家居爱好者

**推荐技能组合**：
- OpenHue（智能灯光）
- Eight Sleep（智能床垫）
- Sonos CLI（智能音响）
- Weather（天气查询）
- Peekaboo（自动化控制）

**工作流示例**：
```
1. 早上：根据天气自动调节灯光
2. 白天：根据日程自动播放音乐
3. 晚上：自动调节床温
4. 全天：语音控制所有设备
```



---

## 技能安装与管理

### 安装方式

#### 方式1：通过 ClawHub CLI（推荐）

```bash
# 安装单个技能
npx clawhub@latest install brave-search

# 安装多个技能
npx clawhub@latest install brave-search nano-banana-pro github

# 查看已安装技能
npx clawhub@latest list

# 更新技能
npx clawhub@latest update brave-search

# 卸载技能
npx clawhub@latest uninstall brave-search
```

#### 方式2：对话式安装

直接在 OpenClaw 中对话：

```
你：安装 brave-search 技能

OpenClaw：好的，正在安装 brave-search...
[安装中...]
✅ 安装成功！brave-search v1.0.0
现在你可以使用实时搜索功能了！
```

#### 方式3：手动安装

```bash
# 1. 克隆技能仓库
git clone https://github.com/openclaw/skills

# 2. 复制到技能目录
cp -r skills/skills/<作者>/<技能名> ~/.openclaw/skills/

# 3. 重启 OpenClaw Gateway
openclaw gateway restart
```

### 技能状态说明

| 状态 | 图标 | 说明 | 操作 |
|------|------|------|------|
| 已安装 | ✅ | 技能已安装并可用 | 直接使用 |
| 可用 | 🟢 | 技能可用但未安装 | 点击安装 |
| 需要配置 | ⚠️ | 需要配置 API 密钥或环境 | 查看配置指南 |
| 需要安装依赖 | 🔧 | 需要安装外部工具 | 按提示安装 |
| 已禁用 | ⛔ | 技能已禁用 | 点击启用 |
| 缺少依赖 | ❌ | 缺少必需的工具或配置 | 安装依赖 |

### 技能配置

#### 配置 API 密钥

某些技能需要 API 密钥才能使用：

```bash
# 方式1：通过环境变量
export GEMINI_API_KEY="your-api-key"
export OPENAI_API_KEY="your-api-key"
export ELEVENLABS_API_KEY="your-api-key"

# 方式2：通过配置文件
# 编辑 ~/.openclaw/openclaw.json
{
  "env": {
    "GEMINI_API_KEY": "your-api-key",
    "OPENAI_API_KEY": "your-api-key"
  }
}

# 方式3：通过 OpenClaw Dashboard
# 访问 http://127.0.0.1:18789/
# 进入 Settings -> Skills -> 选择技能 -> API Key -> Save key
```

#### 安装外部依赖

某些技能需要安装外部工具：

```bash
# Homebrew（macOS/Linux）
brew install ffmpeg        # Video Frames
brew install himalaya      # Himalaya Email
brew install whisper       # OpenAI Whisper
brew install openhue       # OpenHue
brew install camsnap       # Camsnap

# npm（Node.js）
npm install -g @steipete/oracle  # Oracle

# uv（Python）
uv tool install nano-pdf   # Nano PDF

# Go
go install github.com/user/tool@latest
```

### 技能管理最佳实践

#### 1. 按需安装

不要一次性安装所有技能，根据实际需求逐步安装：

```
✅ 推荐：先安装核心技能（Brave Search、GitHub、Apple Notes）
❌ 不推荐：一次性安装所有技能
```

#### 2. 定期更新

定期更新技能以获取新功能和 bug 修复：

```bash
# 检查更新
npx clawhub@latest update --check

# 更新所有技能
npx clawhub@latest update --all
```

#### 3. 备份配置

定期备份技能配置：

```bash
# 备份技能目录
cp -r ~/.openclaw/skills ~/openclaw-skills-backup

# 备份配置文件
cp ~/.openclaw/openclaw.json ~/openclaw-config-backup.json
```

#### 4. 测试新技能

在测试环境中先测试新技能：

```bash
# 创建测试工作区
mkdir ~/openclaw-test
cd ~/openclaw-test

# 安装技能到测试工作区
npx clawhub@latest install <skill-name> --dir ./skills

# 测试完成后再安装到全局
npx clawhub@latest install <skill-name>
```

---

## 实战应用场景

### 场景1：自动化内容创作

**目标**：每天自动生成一篇 AI 资讯文章

**使用技能**：
- Brave Search（搜索资讯）
- Summarize（总结内容）
- Nano Banana Pro（生成配图）
- Notion（保存文章）

**工作流**：

```
1. 早上8点自动触发
2. 用 Brave Search 搜索"AI 最新资讯"
3. 用 Summarize 总结前5篇文章
4. 用 Nano Banana Pro 生成配图
5. 用 Notion 保存文章
6. 发送通知到飞书
```

**实现代码**（伪代码）：

```javascript
// 定时任务：每天早上8点执行
schedule('0 8 * * *', async () => {
  // 1. 搜索资讯
  const articles = await braveSearch('AI 最新资讯');
  
  // 2. 总结内容
  const summary = await summarize(articles.slice(0, 5));
  
  // 3. 生成配图
  const image = await nanoBananaPro('AI technology illustration');
  
  // 4. 保存到 Notion
  await notion.createPage({
    title: `AI 资讯 ${new Date().toLocaleDateString()}`,
    content: summary,
    cover: image
  });
  
  // 5. 发送通知
  await feishu.sendMessage('今日 AI 资讯已生成！');
});
```

### 场景2：智能家居自动化

**目标**：根据天气和时间自动控制家居设备

**使用技能**：
- Weather（天气查询）
- OpenHue（智能灯光）
- Eight Sleep（智能床垫）
- Sonos CLI（智能音响）

**工作流**：

```
早上7点：
- 查询天气
- 如果晴天：灯光调为明亮白色
- 如果阴天：灯光调为暖黄色
- 床温调至舒适温度
- 播放轻音乐

晚上10点：
- 灯光逐渐调暗
- 床温调至睡眠温度
- 停止音乐播放
```

### 场景3：开发工作流自动化

**目标**：自动化代码审查和部署流程

**使用技能**：
- GitHub（代码管理）
- Coding Agent（代码审查）
- Slack（团队通知）
- Tmux（终端管理）

**工作流**：

```
1. 监听 GitHub PR 事件
2. 用 Coding Agent 自动审查代码
3. 如果发现问题：
   - 在 PR 中添加评论
   - 发送 Slack 通知
4. 如果通过审查：
   - 自动合并 PR
   - 触发部署流程
   - 发送成功通知
```

### 场景4：知识管理自动化

**目标**：自动整理和归档网页文章

**使用技能**：
- Brave Search（搜索文章）
- Summarize（提取内容）
- Notion（知识库）
- Obsidian（笔记管理）

**工作流**：

```
1. 收藏网页文章
2. 用 Summarize 提取核心内容
3. 自动生成摘要和标签
4. 保存到 Notion 知识库
5. 同步到 Obsidian 笔记
6. 建立知识图谱链接
```

---

## 常见问题

### Q1：技能安装失败怎么办？

**A**：按以下步骤排查：

1. **检查网络连接**：
   ```bash
   ping github.com
   ```

2. **检查依赖**：
   ```bash
   # 检查是否安装了必需的工具
   which npm
   which git
   ```

3. **查看错误日志**：
   ```bash
   openclaw logs --skill <skill-name>
   ```

4. **手动安装**：
   ```bash
   git clone https://github.com/openclaw/skills
   cp -r skills/skills/<skill-name> ~/.openclaw/skills/
   ```

### Q2：技能需要 API 密钥，如何获取？

**A**：不同服务的 API 密钥获取方式：

| 服务 | 获取地址 | 价格 |
|------|---------|------|
| Gemini | https://makersuite.google.com/app/apikey | 免费额度 |
| OpenAI | https://platform.openai.com/api-keys | 按量付费 |
| ElevenLabs | https://elevenlabs.io/api | 免费额度 |
| Google Places | https://console.cloud.google.com/ | 免费额度 |

### Q3：技能占用太多资源怎么办？

**A**：优化建议：

1. **禁用不常用的技能**：
   ```bash
   openclaw skill disable <skill-name>
   ```

2. **限制并发数**：
   ```json
   {
     "skills": {
       "maxConcurrent": 3
     }
   }
   ```

3. **清理缓存**：
   ```bash
   openclaw cache clear
   ```

### Q4：如何开发自定义技能？

**A**：参考 [第8章：Skills扩展](08-skills-extension.md) 中的开发指南。

### Q5：技能更新后出现问题怎么办？

**A**：回滚到之前的版本：

```bash
# 查看技能版本历史
npx clawhub@latest versions <skill-name>

# 回滚到指定版本
npx clawhub@latest install <skill-name>@1.0.0
```

---

## 总结

OpenClaw 的 93 个可用技能覆盖了工作和生活的方方面面：

- 🔐 **安全认证**：1Password 保护隐私
- 📝 **笔记管理**：Apple Notes、Notion、Obsidian
- 🔍 **信息搜索**：Brave Search 实时搜索
- 💻 **开发工具**：GitHub、Coding Agent
- 📧 **通讯协作**：Slack、WhatsApp、iMessage
- 🎨 **创意多媒体**：Nano Banana Pro、Whisper
- 🏠 **智能家居**：OpenHue、Eight Sleep、Sonos
- 📊 **办公生产**：Notion、Trello、Google Workspace

**推荐安装顺序**：

1. **基础套装**（必装）：
   - Brave Search
   - Apple Notes
   - Apple Reminders
   - Weather

2. **进阶套装**（推荐）：
   - GitHub
   - Notion
   - Nano Banana Pro
   - Peekaboo

3. **专业套装**（按需）：
   - 开发者：Coding Agent、Obsidian、Gemini
   - 创作者：Summarize、Transcript API、Video Frames
   - 智能家居：OpenHue、Eight Sleep、Sonos

**下一步**：

- 📖 阅读 [第8章：Skills扩展](08-skills-extension.md) 了解更多
- 🚀 访问 [ClawHub](https://clawhub.com) 探索更多技能
- 💬 加入社区交流使用经验

---

**相关链接**：

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [ClawHub 技能市场](https://clawhub.com)
- [GitHub 技能仓库](https://github.com/openclaw/skills)
- [社区讨论区](https://github.com/openclaw/openclaw/discussions)

**最后更新**：2026年2月13日  
**适用版本**：OpenClaw 2026.2.9  
**技能总数**：93个（49个内置 + 40个工作区 + 4个额外）

