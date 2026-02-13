# OpenClaw 多 Gateway 多 Agent 配置方案

## 架构说明

根据截图中的信息，OpenClaw 支持两种模式：

### 模式 1：单 Gateway 多 Agent（理论支持，但当前不工作）
- 1 个 Gateway 进程
- 多个 Agent
- 通过 bindings 自动路由

### 模式 2：多 Gateway 多 Agent（推荐，稳定可靠）
- 每个 Agent 一个独立的 Gateway 进程
- 完全隔离：独立进程、独立配置、独立记忆
- 每个 Gateway 绑定一个飞书机器人

## 🎯 推荐方案：多 Gateway 模式

### 优点
- ✅ 隔离彻底，一个挂了不影响别的
- ✅ 每个占 ~400MB 内存，8 个共 3GB（64GB 内存完全够）
- ✅ 配置简单，不需要复杂的 bindings
- ✅ 稳定可靠，不依赖 bindings 功能

### 缺点
- ❌ 需要管理多个进程
- ❌ 配置文件需要分开管理

## 📋 实施步骤

### 步骤 1：创建独立的配置文件

为每个 agent 创建独立的配置文件：

```bash
# 创建配置目录
mkdir -p ~/.openclaw/configs

# 复制基础配置
cp ~/.openclaw/openclaw.json ~/.openclaw/configs/main-agent.json
cp ~/.openclaw/openclaw.json ~/.openclaw/configs/content-agent.json
cp ~/.openclaw/openclaw.json ~/.openclaw/configs/tech-agent.json
cp ~/.openclaw/openclaw.json ~/.openclaw/configs/ainews-agent.json
```

### 步骤 2：修改每个配置文件

#### main-agent.json

```json
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "lan"
  },
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
    "defaults": {
      "model": {
        "primary": "local-antigravity/claude-opus-4-6-thinking"
      },
      "workspace": "/Users/chinamanor/clawd"
    }
  }
}
```

#### content-agent.json

```json
{
  "gateway": {
    "port": 18790,  // 不同的端口
    "mode": "local",
    "bind": "lan"
  },
  "channels": {
    "feishu": {
      "accounts": {
        "content-creator": {
          "appId": "cli_YOUR_CONTENT_APP_ID",
          "appSecret": "YOUR_CONTENT_APP_SECRET",
          "botName": "内容创作助手",
          "enabled": true
        }
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "local-antigravity/claude-sonnet-4-5"
      },
      "workspace": "/Users/chinamanor/clawd/content"
    }
  }
}
```

#### tech-agent.json

```json
{
  "gateway": {
    "port": 18791,  // 不同的端口
    "mode": "local",
    "bind": "lan"
  },
  "channels": {
    "feishu": {
      "accounts": {
        "tech-dev": {
          "appId": "cli_YOUR_TECH_APP_ID",
          "appSecret": "YOUR_TECH_APP_SECRET",
          "botName": "技术开发助手",
          "enabled": true
        }
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "local-antigravity/claude-sonnet-4-5-thinking"
      },
      "workspace": "/Users/chinamanor/clawd/tech"
    }
  }
}
```

#### ainews-agent.json

```json
{
  "gateway": {
    "port": 18792,  // 不同的端口
    "mode": "local",
    "bind": "lan"
  },
  "channels": {
    "feishu": {
      "accounts": {
        "ai-news": {
          "appId": "cli_YOUR_NEWS_APP_ID",
          "appSecret": "YOUR_NEWS_APP_SECRET",
          "botName": "AI资讯助手",
          "enabled": true
        }
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "local-antigravity/gemini-2.5-flash"
      },
      "workspace": "/Users/chinamanor/clawd/ainews"
    }
  }
}
```

### 步骤 3：启动多个 Gateway

```bash
# 停止当前的 Gateway
openclaw gateway stop

# 启动 4 个独立的 Gateway（使用不同的配置文件）
# 注意：OpenClaw 可能不直接支持 --config 参数
# 需要使用环境变量或其他方式指定配置文件

# 方案 A：使用环境变量
OPENCLAW_CONFIG=~/.openclaw/configs/main-agent.json openclaw gateway run --port 18789 &
OPENCLAW_CONFIG=~/.openclaw/configs/content-agent.json openclaw gateway run --port 18790 &
OPENCLAW_CONFIG=~/.openclaw/configs/tech-agent.json openclaw gateway run --port 18791 &
OPENCLAW_CONFIG=~/.openclaw/configs/ainews-agent.json openclaw gateway run --port 18792 &

# 方案 B：使用不同的工作目录
# 为每个 agent 创建独立的工作目录和配置
```

### 步骤 4：验证

```bash
# 检查所有 Gateway 是否运行
ps aux | grep openclaw

# 应该看到 4 个进程，分别监听不同的端口
```

## ⚠️ 注意事项

### 1. OpenClaw 可能不支持多实例

OpenClaw 可能设计为单实例运行，需要确认：
- 是否支持 `--config` 参数
- 是否支持环境变量指定配置文件
- 是否支持多个 Gateway 同时运行

### 2. 替代方案：使用 Docker

如果 OpenClaw 不支持多实例，可以使用 Docker：

```bash
# 为每个 agent 创建独立的 Docker 容器
docker run -d --name openclaw-main -p 18789:18789 -v ~/.openclaw/configs/main-agent.json:/config.json openclaw
docker run -d --name openclaw-content -p 18790:18789 -v ~/.openclaw/configs/content-agent.json:/config.json openclaw
docker run -d --name openclaw-tech -p 18791:18789 -v ~/.openclaw/configs/tech-agent.json:/config.json openclaw
docker run -d --name openclaw-ainews -p 18792:18789 -v ~/.openclaw/configs/ainews-agent.json:/config.json openclaw
```

## 🔍 检查 OpenClaw 是否支持多实例

```bash
# 查看帮助
openclaw gateway run --help

# 查看是否支持配置文件参数
openclaw --help | grep config

# 查看环境变量
openclaw gateway run --help | grep -i env
```

## 📊 资源占用

根据截图信息：
- 每个 Gateway: ~400MB 内存
- 4 个 Gateway: ~1.6GB 内存
- 你的机器: 64GB 内存
- **结论：完全够用**

## 🎉 优势

使用多 Gateway 模式：
1. **完全隔离**：每个机器人独立运行
2. **稳定可靠**：一个挂了不影响其他
3. **配置简单**：不需要复杂的 bindings
4. **易于管理**：每个 Gateway 独立管理

---

**下一步：检查 OpenClaw 是否支持多实例运行**
