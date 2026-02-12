#!/usr/bin/env python3
"""
为OpenClaw教程的每个章节生成配图
使用bananapro-image-gen技能生成高质量图片（2K分辨率，适合印刷）
"""

import os
import sys
import json
import subprocess
from pathlib import Path

# 章节配置：每个章节需要生成的图片
CHAPTER_IMAGES = {
    "docs/01-basics/01-introduction.md": [
        {
            "filename": "images/ch01-openclaw-architecture.png",
            "prompt": """生成一张白板图片，手写字体风格，展示OpenClaw核心架构：

标题：OpenClaw 核心架构

三大组件（用框图表示）：
📦 Gateway 网关
• 会话管理
• 消息路由  
• 多平台连接

🤖 AI 智能体
• Claude/GPT/Gemini
• 理解指令
• 执行任务

🔧 Skills 系统
• 文件管理
• 知识管理
• 自动化工作流

工作流程（用箭头连接）：
用户消息 → Gateway → AI智能体 → Skills → 返回结果

用手写字体，添加框图、箭头、图标等手绘元素，简洁清晰"""
        },
        {
            "filename": "images/ch01-openclaw-vs-chatgpt.png",
            "prompt": """生成一张对比表格图片，清晰易读，展示OpenClaw vs ChatGPT：

标题：OpenClaw vs ChatGPT 对比

对比维度：
1. 部署方式
   OpenClaw: 本地/云端 ✓
   ChatGPT: 仅在线服务

2. 文件访问
   OpenClaw: 支持本地文件 ✓
   ChatGPT: 不支持 ✗

3. 功能扩展
   OpenClaw: Skills系统 ✓
   ChatGPT: 固定功能 ✗

4. 多平台支持
   OpenClaw: 飞书/企微/钉钉等 ✓
   ChatGPT: 仅网页/App

5. 成本
   OpenClaw: 按需付费 ✓
   ChatGPT: 订阅制

使用表格形式，清晰对比，绿色✓表示优势，红色✗表示不支持"""
        },
        {
            "filename": "images/ch01-use-cases.png",
            "prompt": """生成一张概念图，展示OpenClaw的应用场景：

标题：OpenClaw 应用场景

中心：OpenClaw

四大场景（用箭头连接）：
📝 个人效率
• 文件管理
• 知识整理
• 日程安排

💼 团队协作
• 飞书机器人
• 企微助手
• 自动化流程

🎨 创意工作
• 内容创作
• 图片生成
• 视频脚本

🚀 独立创业
• 客户服务
• 营销自动化
• 数据分析

用思维导图形式，简洁清晰，配色温暖"""
        }
    ],
    
    "docs/01-basics/02-installation.md": [
        {
            "filename": "images/ch02-installation-flow.png",
            "prompt": """生成一张流程图，展示OpenClaw安装步骤：

标题：OpenClaw 安装流程

两种方式（左右对比）：

【云端部署】（推荐）
1️⃣ 注册云服务器
2️⃣ 一键部署脚本
3️⃣ 配置API密钥
4️⃣ 完成！

【本地部署】
1️⃣ 安装Node.js
2️⃣ 克隆代码
3️⃣ 安装依赖
4️⃣ 配置文件
5️⃣ 启动服务

用流程图形式，箭头连接，简洁清晰"""
        },
        {
            "filename": "images/ch02-system-requirements.png",
            "prompt": """生成一张信息图，展示OpenClaw系统要求：

标题：系统要求

云端部署：
✅ 浏览器
✅ 20元/月
✅ 10分钟

本地部署：
💻 硬件
• CPU: 2核+
• 内存: 4GB+
• 硬盘: 10GB+

📦 软件
• Node.js 22+
• pnpm/npm

🌐 网络
• 稳定连接
• 访问GitHub

用图标和列表形式，清晰易读"""
        }
    ],
    
    "docs/01-basics/03-quick-start.md": [
        {
            "filename": "images/ch03-first-conversation.png",
            "prompt": """生成一张对话示例图，展示OpenClaw首次对话：

标题：第一次对话

对话框形式：

用户：你好，OpenClaw！
OpenClaw：你好！我是OpenClaw，你的AI助手。我可以帮你：
• 管理本地文件
• 整理知识笔记
• 安排日程
• 自动化工作流

用户：帮我找一下桌面上的PDF文件
OpenClaw：好的，正在搜索...
找到3个PDF文件：
1. 工作报告.pdf
2. 学习笔记.pdf  
3. 发票.pdf

用聊天气泡形式，简洁友好"""
        },
        {
            "filename": "images/ch03-basic-commands.png",
            "prompt": """生成一张命令卡片图，展示OpenClaw基础命令：

标题：常用命令速查

📁 文件管理
• 搜索文件：帮我找...
• 整理文件：把桌面整理一下
• 清理空间：清理重复文件

📝 知识管理
• 记笔记：帮我记录...
• 搜索笔记：找一下关于...的笔记
• 整理笔记：整理最近的笔记

📅 日程管理
• 添加日程：明天10点开会
• 查看日程：今天有什么安排
• 提醒事项：提醒我...

用卡片形式，每个命令配图标，清晰易读"""
        }
    ],
    
    "docs/02-core-features/04-file-management.md": [
        {
            "filename": "images/ch04-smart-search.png",
            "prompt": """生成一张对比图，展示传统搜索 vs OpenClaw智能搜索：

标题：智能文件搜索

【传统搜索】
❌ 只能按文件名
❌ 忘记名字就找不到
❌ 需要记住位置
❌ 耗时10-30分钟

【OpenClaw搜索】
✅ 根据内容搜索
✅ 自然语言描述
✅ 跨文件夹搜索
✅ 秒级响应

示例：
"帮我找买跑步机的发票"
→ 立即找到目标文件

用左右对比形式，清晰展示优势"""
        },
        {
            "filename": "images/ch04-file-organization.png",
            "prompt": """生成一张流程图，展示OpenClaw文件整理过程：

标题：智能文件整理

混乱的桌面
↓
OpenClaw分析
• 识别文件类型
• 理解文件内容
• 智能分类
↓
自动整理
📁 工作文档/
📁 个人文件/
📁 图片视频/
📁 下载文件/
↓
整洁的桌面 ✨

用流程图形式，箭头连接，配图标"""
        },
        {
            "filename": "images/ch04-batch-processing.png",
            "prompt": """生成一张示例图，展示OpenClaw批量处理文件：

标题：批量文件处理

场景示例：

1️⃣ 批量重命名
100张照片 → 统一格式
IMG_001.jpg → 2024-春游-001.jpg

2️⃣ 批量转换
10个Word → PDF
保持格式不变

3️⃣ 批量压缩
1GB图片 → 100MB
保持清晰度

4️⃣ 批量移动
分散文件 → 统一归档

用卡片形式，每个场景配图标和箭头"""
        }
    ],
    
    "docs/02-core-features/05-knowledge-management.md": [
        {
            "filename": "images/ch05-knowledge-system.png",
            "prompt": """生成一张架构图，展示OpenClaw知识管理系统：

标题：知识管理系统

核心功能：

📝 笔记管理
• 快速记录
• 智能分类
• 全文搜索

🔗 知识关联
• 自动链接
• 标签系统
• 知识图谱

💡 智能检索
• 语义搜索
• 相关推荐
• 快速定位

📊 知识沉淀
• 定期整理
• 知识复盘
• 持续积累

用思维导图形式，中心向外扩展"""
        },
        {
            "filename": "images/ch05-note-workflow.png",
            "prompt": """生成一张流程图，展示OpenClaw笔记工作流：

标题：笔记工作流

输入 → 处理 → 输出

【输入】
• 语音记录
• 文字输入
• 网页剪藏
• 图片识别

【处理】
• 自动分类
• 提取关键词
• 生成摘要
• 关联笔记

【输出】
• Markdown文档
• 知识卡片
• 思维导图
• 分享链接

用流程图形式，三列布局"""
        }
    ],
    
    "docs/02-core-features/06-schedule-management.md": [
        {
            "filename": "images/ch06-calendar-integration.png",
            "prompt": """生成一张集成图，展示OpenClaw日程管理：

标题：日程管理集成

OpenClaw中心
↓ ↑
多平台同步：

📱 iPhone日历
💻 Mac日历
📧 Google Calendar
📅 Outlook
🔔 飞书日历

功能：
• 自然语言添加
• 智能提醒
• 冲突检测
• 自动同步

用中心辐射形式，配图标"""
        },
        {
            "filename": "images/ch06-smart-reminder.png",
            "prompt": """生成一张示例图，展示OpenClaw智能提醒：

标题：智能提醒系统

场景示例：

⏰ 时间提醒
"明天10点开会"
→ 提前15分钟提醒

📍 位置提醒
"到公司时提醒我"
→ 到达时自动提醒

🔄 循环提醒
"每周一早会"
→ 自动重复

🎯 条件提醒
"下雨时提醒带伞"
→ 智能判断

用卡片形式，每个场景配图标"""
        }
    ],
    
    "docs/02-core-features/07-automation-workflow.md": [
        {
            "filename": "images/ch07-automation-examples.png",
            "prompt": """生成一张示例图，展示OpenClaw自动化场景：

标题：自动化工作流示例

4个场景：

1️⃣ 邮件自动分类
新邮件 → 识别类型 → 自动归档
• 工作邮件 → 工作文件夹
• 账单邮件 → 财务文件夹
• 订阅邮件 → 阅读列表

2️⃣ 文件自动备份
重要文件 → 检测变化 → 自动备份
• 每天定时
• 多地备份
• 版本管理

3️⃣ 报告自动生成
数据收集 → 分析处理 → 生成报告
• 自动统计
• 图表生成
• 定时发送

4️⃣ 社交媒体发布
内容准备 → 定时发布 → 数据追踪
• 多平台同步
• 最佳时间
• 效果分析

用流程图形式，每个场景独立展示"""
        },
        {
            "filename": "images/ch07-workflow-builder.png",
            "prompt": """生成一张界面图，展示OpenClaw工作流构建器：

标题：工作流构建器

可视化编辑：

触发器 → 条件 → 动作

【触发器】
⏰ 定时触发
📁 文件变化
📧 收到邮件
💬 收到消息

【条件】
🔍 文件类型
📊 文件大小
🏷️ 关键词
📅 时间范围

【动作】
📤 发送通知
📁 移动文件
✉️ 发送邮件
🤖 执行脚本

用流程图形式，模块化展示"""
        }
    ],
    
    "docs/03-advanced/08-skills-extension.md": [
        {
            "filename": "images/ch08-skills-ecosystem.png",
            "prompt": """生成一张生态图，展示OpenClaw Skills系统：

标题：Skills 扩展生态

中心：OpenClaw Core

Skills分类：

📁 文件管理
• 智能搜索
• 批量处理
• 自动整理

📝 知识管理
• 笔记系统
• 知识图谱
• 智能检索

🤖 AI增强
• 图片生成
• 语音识别
• 文本分析

🔗 平台集成
• 飞书
• 企微
• 钉钉

🛠️ 开发工具
• API调用
• 数据处理
• 自动化

用思维导图形式，分类清晰"""
        },
        {
            "filename": "images/ch08-skill-development.png",
            "prompt": """生成一张流程图，展示Skill开发流程：

标题：Skill 开发流程

1️⃣ 创建项目
skill-template/
├── skill.json
├── README.md
└── scripts/

2️⃣ 编写代码
• 定义功能
• 实现逻辑
• 测试调试

3️⃣ 配置文件
{
  "name": "my-skill",
  "version": "1.0.0",
  "commands": [...]
}

4️⃣ 测试发布
• 本地测试
• 打包上传
• ClawHub发布

用流程图形式，步骤清晰"""
        },
        {
            "filename": "images/ch08-clawhub.png",
            "prompt": """生成一张界面图，展示ClawHub技能市场：

标题：ClawHub 技能市场

分类浏览：

🔥 热门Skills
⭐ 精选推荐
🆕 最新上架
📊 排行榜

Skill卡片示例：
┌─────────────────┐
│ 📸 图片生成      │
│ ⭐⭐⭐⭐⭐ 4.8   │
│ 下载: 10k+      │
│ [安装] [详情]   │
└─────────────────┘

功能：
• 一键安装
• 自动更新
• 评分评论
• 使用统计

用卡片网格布局，清晰易读"""
        }
    ],
    
    "docs/03-advanced/09-multi-platform-integration.md": [
        {
            "filename": "images/ch09-platform-support.png",
            "prompt": """生成一张平台图，展示OpenClaw支持的平台：

标题：多平台支持

OpenClaw Gateway
↓
支持平台：

💼 企业平台
• 飞书 Feishu
• 企业微信 WeCom
• 钉钉 DingTalk
• Slack

💬 社交平台
• WhatsApp
• Telegram
• Discord
• QQ

📱 移动平台
• iMessage
• SMS
• 微信

🌐 Web平台
• Web界面
• API接口

用图标网格布局，清晰展示"""
        },
        {
            "filename": "images/ch09-feishu-bot.png",
            "prompt": """生成一张配置图，展示飞书机器人配置流程：

标题：飞书机器人配置

步骤：

1️⃣ 创建应用
飞书开放平台 → 创建企业自建应用

2️⃣ 配置权限
• 消息接收
• 消息发送
• 文件读写

3️⃣ 获取凭证
• App ID
• App Secret
• Verification Token

4️⃣ OpenClaw配置
openclaw.json:
{
  "feishu": {
    "appId": "...",
    "appSecret": "..."
  }
}

5️⃣ 启动测试
发送消息 → 机器人响应 ✓

用流程图形式，步骤清晰"""
        }
    ],
    
    "docs/03-advanced/10-api-integration.md": [
        {
            "filename": "images/ch10-api-architecture.png",
            "prompt": """生成一张架构图，展示OpenClaw API集成：

标题：API 集成架构

三层架构：

【应用层】
• Web应用
• 移动App
• 第三方服务

↓ HTTP/WebSocket

【API层】
• RESTful API
• WebSocket
• Webhook

↓

【核心层】
• Gateway网关
• AI智能体
• Skills系统

数据流：
请求 → 认证 → 路由 → 处理 → 响应

用分层架构图，清晰展示"""
        },
        {
            "filename": "images/ch10-api-examples.png",
            "prompt": """生成一张代码示例图，展示OpenClaw API调用：

标题：API 调用示例

场景示例：

1️⃣ 发送消息
POST /api/chat
{
  "message": "帮我搜索文件",
  "userId": "user123"
}

2️⃣ 上传文件
POST /api/files
Content-Type: multipart/form-data

3️⃣ 获取会话
GET /api/sessions/123

4️⃣ WebSocket连接
ws://localhost:18789/ws
→ 实时消息推送

响应格式：
{
  "status": "success",
  "data": {...}
}

用代码块形式，清晰易读"""
        }
    ],
    
    "docs/03-advanced/11-advanced-configuration.md": [
        {
            "filename": "images/ch11-config-structure.png",
            "prompt": """生成一张配置图，展示OpenClaw配置文件结构：

标题：配置文件结构

~/.openclaw/
├── openclaw.json      # 主配置
├── skills/            # Skills配置
├── logs/              # 日志文件
└── data/              # 数据存储

openclaw.json 结构：
{
  "gateway": {
    "port": 18789,
    "host": "127.0.0.1"
  },
  "ai": {
    "provider": "claude",
    "apiKey": "..."
  },
  "platforms": {
    "feishu": {...},
    "wechat": {...}
  },
  "skills": [...]
}

用文件树和JSON结构展示"""
        },
        {
            "filename": "images/ch11-performance-tuning.png",
            "prompt": """生成一张优化图，展示OpenClaw性能优化：

标题：性能优化建议

4个方面：

⚡ 响应速度
• 启用缓存
• 并发处理
• 连接池

💾 内存优化
• 限制会话数
• 定期清理
• 流式处理

🔋 资源管理
• CPU限制
• 内存限制
• 磁盘配额

📊 监控告警
• 性能指标
• 错误日志
• 资源使用

优化效果：
响应时间: 2s → 0.5s
内存占用: 500MB → 200MB

用卡片形式，配图标和数据"""
        }
    ],
    
    "docs/04-practical-cases/12-personal-productivity.md": [
        {
            "filename": "images/ch12-productivity-workflow.png",
            "prompt": """生成一张工作流图，展示个人效率提升：

标题：个人效率工作流

一天的工作流：

🌅 早晨 (8:00)
• 查看今日日程
• 整理待办事项
• 准备会议资料

☀️ 上午 (9:00-12:00)
• 处理重要邮件
• 专注工作时间
• 自动记录笔记

🌤️ 下午 (14:00-18:00)
• 团队协作
• 文件整理
• 进度同步

🌙 晚上 (20:00)
• 日总结
• 知识复盘
• 明日计划

OpenClaw全程辅助 ✨

用时间轴形式，配图标"""
        },
        {
            "filename": "images/ch12-gtd-system.png",
            "prompt": """生成一张GTD系统图，展示OpenClaw GTD实践：

标题：GTD 系统实践

5个步骤：

1️⃣ 收集 Capture
• 快速记录
• 语音输入
• 邮件转发

2️⃣ 整理 Clarify
• 自动分类
• 提取关键信息
• 确定下一步

3️⃣ 组织 Organize
• 项目归档
• 标签管理
• 优先级排序

4️⃣ 回顾 Reflect
• 每日回顾
• 每周复盘
• 调整计划

5️⃣ 执行 Engage
• 专注当下
• 及时提醒
• 记录进度

用流程图形式，循环展示"""
        }
    ],
    
    "docs/04-practical-cases/13-advanced-automation.md": [
        {
            "filename": "images/ch13-automation-scenarios.png",
            "prompt": """生成一张场景图，展示高级自动化应用：

标题：高级自动化场景

6个场景：

1️⃣ 智能客服
客户咨询 → AI理解 → 自动回复
• 24小时在线
• 多语言支持
• 知识库检索

2️⃣ 内容生产
主题输入 → 内容生成 → 多平台发布
• 文章写作
• 图片配图
• 定时发布

3️⃣ 数据分析
数据收集 → 自动分析 → 报告生成
• 实时监控
• 趋势预测
• 可视化展示

4️⃣ 营销自动化
用户行为 → 智能推荐 → 精准触达
• 个性化内容
• 最佳时机
• 效果追踪

5️⃣ 项目管理
任务分配 → 进度跟踪 → 自动提醒
• 甘特图
• 里程碑
• 风险预警

6️⃣ 财务管理
账单收集 → 自动记账 → 报表生成
• 分类统计
• 预算控制
• 税务提醒

用卡片网格布局"""
        },
        {
            "filename": "images/ch13-workflow-template.png",
            "prompt": """生成一张模板图，展示自动化工作流模板：

标题：工作流模板库

常用模板：

📧 邮件处理模板
触发：收到邮件
条件：包含关键词
动作：自动分类+提取信息+添加待办

📁 文件管理模板
触发：文件下载
条件：文件类型
动作：重命名+移动+备份

📊 报告生成模板
触发：每周一 9:00
条件：有新数据
动作：统计分析+生成报告+发送邮件

💬 社交媒体模板
触发：定时
条件：工作日 10:00
动作：生成内容+配图+多平台发布

用卡片形式，每个模板独立展示"""
        }
    ],
    
    "docs/04-practical-cases/14-creative-applications.md": [
        {
            "filename": "images/ch14-creative-workflow.png",
            "prompt": """生成一张创意工作流图：

标题：创意工作流

内容创作流程：

💡 灵感收集
• 随时记录
• 图片剪藏
• 语音备忘

📝 内容创作
• AI辅助写作
• 图片生成
• 视频脚本

✨ 内容优化
• 语法检查
• SEO优化
• 可读性分析

📤 多平台发布
• 格式适配
• 定时发布
• 数据追踪

📊 效果分析
• 阅读量
• 互动率
• 优化建议

用流程图形式，循环展示"""
        },
        {
            "filename": "images/ch14-content-types.png",
            "prompt": """生成一张内容类型图，展示OpenClaw支持的创意内容：

标题：创意内容类型

6种类型：

📝 文章写作
• 博客文章
• 公众号
• 小红书

🎨 图片设计
• 配图生成
• Logo设计
• 海报制作

🎬 视频内容
• 脚本创作
• 字幕生成
• 剪辑建议

🎙️ 音频内容
• 播客脚本
• 语音转文字
• 音频剪辑

📊 数据可视化
• 图表生成
• 信息图
• 数据报告

🎯 营销素材
• 广告文案
• 活动策划
• 推广方案

用图标网格布局"""
        }
    ],
    
    "docs/04-practical-cases/15-solo-entrepreneur-cases.md": [
        {
            "filename": "images/ch15-entrepreneur-system.png",
            "prompt": """生成一张系统图，展示超级个体工作系统：

标题：超级个体工作系统

OpenClaw 赋能

6大模块：

💼 业务管理
• 客户管理
• 项目跟踪
• 合同管理

💰 财务管理
• 收支记录
• 发票管理
• 税务提醒

📣 营销推广
• 内容创作
• 社交媒体
• 数据分析

🤝 客户服务
• 智能客服
• 工单系统
• 满意度调查

📚 知识管理
• 经验沉淀
• 技能提升
• 资源整理

⚡ 效率工具
• 自动化流程
• 时间管理
• 协作工具

用思维导图形式"""
        },
        {
            "filename": "images/ch15-business-automation.png",
            "prompt": """生成一张自动化图，展示业务自动化流程：

标题：业务自动化流程

3个核心流程：

1️⃣ 客户获取
引流 → 咨询 → 转化
• 自动回复
• 需求分析
• 方案推荐

2️⃣ 服务交付
接单 → 执行 → 交付
• 任务分解
• 进度跟踪
• 质量检查

3️⃣ 客户维护
回访 → 复购 → 转介绍
• 定期回访
• 优惠推送
• 口碑传播

效果：
人效提升: 3倍
响应速度: 5分钟内
客户满意度: 95%+

用流程图+数据展示"""
        },
        {
            "filename": "images/ch15-success-metrics.png",
            "prompt": """生成一张指标图，展示超级个体成功指标：

标题：成功指标看板

4个维度：

📈 业务增长
• 月收入: ¥50k → ¥150k
• 客户数: 10 → 50
• 复购率: 30% → 70%

⏱️ 时间效率
• 工作时间: 12h → 6h
• 响应时间: 2h → 5min
• 自动化率: 20% → 80%

💰 成本控制
• 人力成本: ¥0
• 工具成本: ¥200/月
• ROI: 500%

😊 生活质量
• 工作自由度: ⭐⭐⭐⭐⭐
• 收入稳定性: ⭐⭐⭐⭐⭐
• 个人成长: ⭐⭐⭐⭐⭐

用仪表盘形式，数据可视化"""
        }
    ],
    
    "docs/05-troubleshooting/16-best-practices.md": [
        {
            "filename": "images/ch16-best-practices.png",
            "prompt": """生成一张最佳实践图：

标题：OpenClaw 最佳实践

8条建议：

1️⃣ 安全第一
• 定期备份
• 权限管理
• 敏感信息加密

2️⃣ 性能优化
• 合理配置
• 定期清理
• 监控资源

3️⃣ 数据管理
• 分类整理
• 定期归档
• 版本控制

4️⃣ 自动化优先
• 重复任务自动化
• 工作流模板化
• 持续优化

5️⃣ 知识沉淀
• 记录经验
• 整理文档
• 分享交流

6️⃣ 持续学习
• 关注更新
• 学习新功能
• 参与社区

7️⃣ 合理使用
• 明确需求
• 循序渐进
• 量力而行

8️⃣ 数据安全
• 本地优先
• 加密传输
• 定期审计

用图标列表形式"""
        },
        {
            "filename": "images/ch16-troubleshooting-flow.png",
            "prompt": """生成一张故障排查流程图：

标题：故障排查流程

问题诊断：

1️⃣ 确认问题
• 具体现象
• 复现步骤
• 错误信息

2️⃣ 检查基础
• 网络连接
• 服务状态
• 配置文件

3️⃣ 查看日志
• 错误日志
• 系统日志
• API日志

4️⃣ 尝试解决
• 重启服务
• 清理缓存
• 更新配置

5️⃣ 寻求帮助
• 查看文档
• 搜索社区
• 提交Issue

6️⃣ 预防措施
• 记录问题
• 优化配置
• 定期维护

用流程图形式，决策树展示"""
        }
    ]
}


# 脚本配置
SKILL_PATH = ".claude/.skills/bananapro-image-gen/scripts/generate_image.py"
RESOLUTION = "2K"  # 2K分辨率，适合印刷（约1000dpi）
API_KEY = os.environ.get("NEXTAI_API_KEY", "")

def ensure_directory(filepath):
    """确保目录存在"""
    directory = os.path.dirname(filepath)
    if directory:
        Path(directory).mkdir(parents=True, exist_ok=True)

def generate_image(chapter_file, image_config):
    """生成单张图片"""
    filename = image_config["filename"]
    prompt = image_config["prompt"]
    
    # 确保输出目录存在
    chapter_dir = os.path.dirname(chapter_file)
    output_path = os.path.join(chapter_dir, filename)
    ensure_directory(output_path)
    
    print(f"\n{'='*80}")
    print(f"生成图片: {output_path}")
    print(f"章节: {chapter_file}")
    print(f"{'='*80}\n")
    
    # 构建命令
    cmd = [
        "python3",
        SKILL_PATH,
        "--prompt", prompt,
        "--filename", output_path,
        "--resolution", RESOLUTION,
        "--api-format", "gemini"  # 使用Gemini格式
    ]
    
    if API_KEY:
        cmd.extend(["--api-key", API_KEY])
    
    # 执行命令
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=180  # 3分钟超时
        )
        
        if result.returncode == 0:
            print(f"✅ 成功生成: {output_path}")
            return True
        else:
            print(f"❌ 生成失败: {output_path}")
            print(f"错误信息: {result.stderr}")
            return False
            
    except subprocess.TimeoutExpired:
        print(f"⏱️ 超时: {output_path}")
        return False
    except Exception as e:
        print(f"❌ 异常: {e}")
        return False

def generate_all_images(chapters=None, skip_existing=True):
    """生成所有章节的图片"""
    if chapters is None:
        chapters = list(CHAPTER_IMAGES.keys())
    
    total = 0
    success = 0
    failed = 0
    skipped = 0
    
    for chapter_file in chapters:
        if chapter_file not in CHAPTER_IMAGES:
            print(f"⚠️  未找到章节配置: {chapter_file}")
            continue
        
        images = CHAPTER_IMAGES[chapter_file]
        print(f"\n{'#'*80}")
        print(f"# 处理章节: {chapter_file}")
        print(f"# 图片数量: {len(images)}")
        print(f"{'#'*80}")
        
        for image_config in images:
            total += 1
            
            # 检查文件是否已存在
            chapter_dir = os.path.dirname(chapter_file)
            output_path = os.path.join(chapter_dir, image_config["filename"])
            
            if skip_existing and os.path.exists(output_path):
                print(f"⏭️  跳过已存在的文件: {output_path}")
                skipped += 1
                continue
            
            # 生成图片
            if generate_image(chapter_file, image_config):
                success += 1
            else:
                failed += 1
    
    # 打印统计
    print(f"\n{'='*80}")
    print(f"生成完成！")
    print(f"总计: {total} 张")
    print(f"成功: {success} 张")
    print(f"失败: {failed} 张")
    print(f"跳过: {skipped} 张")
    print(f"{'='*80}\n")
    
    return success, failed, skipped

def main():
    import argparse
    
    parser = argparse.ArgumentParser(
        description="为OpenClaw教程章节生成配图",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
使用示例:

【生成所有章节的图片】
    python generate_chapter_images.py

【生成指定章节的图片】
    python generate_chapter_images.py --chapters docs/01-basics/01-introduction.md

【强制重新生成（覆盖已存在的图片）】
    python generate_chapter_images.py --force

【查看章节列表】
    python generate_chapter_images.py --list

【配置API Key】
    export NEXTAI_API_KEY="your-api-key"
    python generate_chapter_images.py
        """
    )
    
    parser.add_argument(
        "--chapters", "-c",
        nargs="+",
        help="指定要生成图片的章节文件"
    )
    parser.add_argument(
        "--force", "-f",
        action="store_true",
        help="强制重新生成，覆盖已存在的图片"
    )
    parser.add_argument(
        "--list", "-l",
        action="store_true",
        help="列出所有章节"
    )
    
    args = parser.parse_args()
    
    # 列出章节
    if args.list:
        print("\n可用章节:")
        for i, chapter in enumerate(CHAPTER_IMAGES.keys(), 1):
            images_count = len(CHAPTER_IMAGES[chapter])
            print(f"{i:2d}. {chapter} ({images_count}张图片)")
        print()
        return
    
    # 检查API Key
    if not API_KEY:
        print("⚠️  警告: 未设置 NEXTAI_API_KEY 环境变量")
        print("请先设置: export NEXTAI_API_KEY='your-api-key'")
        response = input("是否继续？(y/N): ")
        if response.lower() != 'y':
            return
    
    # 生成图片
    generate_all_images(
        chapters=args.chapters,
        skip_existing=not args.force
    )

if __name__ == "__main__":
    main()
