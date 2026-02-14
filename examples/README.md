# OpenClaw 示例集合

> 📦 **开箱即用**：这里包含了各种配置文件、脚本和Skills示例

---

## 📁 目录结构

```
examples/
├── configs/              # 配置文件示例
│   ├── basic-config.json
│   ├── multi-model-config.json
│   ├── multi-agent-config.json
│   └── feishu-config.json
├── automation/           # 自动化脚本
│   ├── daily-report.sh
│   ├── backup-config.sh
│   ├── batch-process-files.sh
│   └── website-monitor.sh
├── skills/              # Skills开发示例
│   ├── custom-skill-template.js
│   ├── weather-skill-example.js
│   └── package.json
└── README.md           # 本文件
```

---

## 🎯 配置文件示例

### 1. 基础配置 (basic-config.json)

**适用场景**：新手入门，最小化配置

**使用方法**：
```bash
# 复制到配置目录
cp examples/configs/basic-config.json ~/.openclaw/config.json

# 编辑API密钥
nano ~/.openclaw/config.json

# 启动Gateway
openclaw gateway run
```

---

### 2. 多模型配置 (multi-model-config.json)

**适用场景**：需要使用多个AI模型

**特点**：
- 支持DeepSeek、Kimi、GPT-4等多个模型
- 根据任务类型自动选择模型
- 优化成本和性能

**使用方法**：
```bash
cp examples/configs/multi-model-config.json ~/.openclaw/config.json
# 编辑所有API密钥
nano ~/.openclaw/config.json
```

---

### 3. 多Agent配置 (multi-agent-config.json)

**适用场景**：需要不同的AI助手处理不同类型的任务

**特点**：
- 工作助手：处理工作任务
- 个人助手：处理生活问题
- 代码助手：专注编程

**使用方法**：
```bash
cp examples/configs/multi-agent-config.json ~/.openclaw/config.json
# 根据需要调整配置
nano ~/.openclaw/config.json
```

---

### 4. 飞书Bot配置 (feishu-config.json)

**适用场景**：接入飞书平台

**使用方法**：
```bash
# 合并到主配置
jq -s '.[0] * .[1]' ~/.openclaw/config.json examples/configs/feishu-config.json > ~/.openclaw/config.json.new
mv ~/.openclaw/config.json.new ~/.openclaw/config.json
```

---

## 🤖 自动化脚本

### 1. 每日AI日报 (daily-report.sh)

**功能**：每天自动生成并推送AI行业日报

**使用方法**：
```bash
# 赋予执行权限
chmod +x examples/automation/daily-report.sh

# 测试运行
./examples/automation/daily-report.sh

# 添加到crontab（每天9点执行）
crontab -e
# 添加：0 9 * * * ~/awesome-openclaw-tutorial/examples/automation/daily-report.sh
```

---

### 2. 配置备份 (backup-config.sh)

**功能**：自动备份OpenClaw配置文件

**使用方法**：
```bash
chmod +x examples/automation/backup-config.sh

# 手动备份
./examples/automation/backup-config.sh

# 自动备份（每天凌晨2点）
crontab -e
# 添加：0 2 * * * ~/awesome-openclaw-tutorial/examples/automation/backup-config.sh
```

---

### 3. 批量文件处理 (batch-process-files.sh)

**功能**：批量处理指定目录下的文件

**使用方法**：
```bash
chmod +x examples/automation/batch-process-files.sh

# 修改脚本中的目录路径
nano examples/automation/batch-process-files.sh

# 运行
./examples/automation/batch-process-files.sh
```

---

### 4. 网站监控 (website-monitor.sh)

**功能**：监控网站内容变化，发现更新时通知

**使用方法**：
```bash
chmod +x examples/automation/website-monitor.sh

# 修改监控的网站URL
nano examples/automation/website-monitor.sh

# 定时检查（每小时）
crontab -e
# 添加：0 * * * * ~/awesome-openclaw-tutorial/examples/automation/website-monitor.sh
```

---

## 🧩 Skills开发示例

### 1. 自定义Skill模板 (custom-skill-template.js)

**功能**：展示如何创建自定义Skill

**使用方法**：
```bash
# 复制模板
cp examples/skills/custom-skill-template.js ~/.openclaw/skills/my-skill.js

# 编辑实现你的功能
nano ~/.openclaw/skills/my-skill.js

# 重启Gateway加载Skill
openclaw gateway restart
```

---

### 2. 天气查询Skill (weather-skill-example.js)

**功能**：查询天气信息的完整示例

**使用方法**：
```bash
# 安装依赖
cd examples/skills
npm install

# 复制到Skills目录
cp -r examples/skills ~/.openclaw/skills/weather-skill

# 配置API密钥
openclaw config set skills.weather-skill.apiKey "YOUR_API_KEY"

# 重启Gateway
openclaw gateway restart

# 测试
openclaw message send --message "查询北京天气"
```

---

## 📚 相关文档

- [第2章：环境搭建](../docs/01-basics/02-installation.md)
- [第8章：Skills扩展](../docs/03-advanced/08-skills-extension.md)
- [第11章：高级配置](../docs/03-advanced/11-advanced-configuration.md)
- [附录H：配置文件模板](../appendix/H-config-templates.md)

---

## 🤝 贡献示例

欢迎贡献你的配置和脚本！

1. Fork本仓库
2. 添加你的示例到相应目录
3. 更新本README
4. 提交Pull Request

---

## 📝 许可证

MIT License

---

**最后更新**：2026年2月14日
