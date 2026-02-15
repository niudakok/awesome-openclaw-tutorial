# 第16章：常见问题速查

> 💡 **快速解决**：遇到问题？先在这里找答案，90%的问题都能快速解决

---

## 📋 目录

- [安装配置问题](#安装配置问题)
- [API连接问题](#api连接问题)
- [Skills加载问题](#skills加载问题)
- [Gateway问题](#gateway问题)
- [多平台集成问题](#多平台集成问题)
- [文件操作问题](#文件操作问题)
- [性能问题](#性能问题)
- [权限问题](#权限问题)
- [网络问题](#网络问题)
- [端口问题](#端口问题)

---

## 🔧 安装配置问题

### 问题1：Node.js版本不对

**症状**：
```bash
Error: The engine "node" is incompatible with this module
```

**原因**：OpenClaw 需要 Node.js 22+

**解决方案**：
```bash
# 检查当前版本
node --version

# 安装 Node.js 22+
# macOS (使用 Homebrew)
brew install node@22

# 或使用 nvm
nvm install 22
nvm use 22
```

✅ **验证**：`node --version` 应显示 v22.x.x

---

### 问题2：npm install 失败

**症状**：
```bash
npm ERR! code EACCES
npm ERR! syscall access
```

**原因**：权限不足或网络问题

**解决方案**：

**方案1：修复权限**
```bash
# macOS/Linux
sudo chown -R $(whoami) ~/.npm
sudo chown -R $(whoami) /usr/local/lib/node_modules
```

**方案2：使用国内镜像**
```bash
# 使用淘宝镜像
npm config set registry https://registry.npmmirror.com

# 或使用 pnpm
npm install -g pnpm
pnpm install
```

**方案3：清除缓存重试**
```bash
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

---

### 问题3：安装脚本卡住不动

**症状**：
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
# 长时间无响应
```

**原因**：网络连接问题或下载速度慢

**解决方案**：

**方案1：使用代理**
```bash
# 设置代理
export https_proxy=http://127.0.0.1:7890
export http_proxy=http://127.0.0.1:7890

# 重新运行安装脚本
curl -fsSL https://openclaw.ai/install.sh | bash
```

**方案2：手动安装**
```bash
# 下载安装脚本
curl -fsSL https://openclaw.ai/install.sh -o install.sh

# 查看脚本内容
cat install.sh

# 手动执行
bash install.sh
```

**方案3：使用 npm 直接安装**
```bash
npm install -g openclaw
```

---

### 问题4：配置文件找不到

**症状**：
```bash
Error: Config file not found
```

**原因**：配置文件路径错误或未创建

**解决方案**：
```bash
# 检查配置文件位置
ls -la ~/.openclaw/

# 创建配置目录
mkdir -p ~/.openclaw

# 初始化配置
openclaw config init

# 或手动创建配置文件
cat > ~/.openclaw/config.json << 'EOF'
{
  "gateway": {
    "mode": "local",
    "port": 18789
  },
  "models": {
    "default": "deepseek-chat"
  }
}
EOF
```

---

## 🔌 API连接问题

### 问题5：API密钥无效

**症状**：
```bash
Error: Invalid API key
401 Unauthorized
```

**原因**：API密钥错误或已过期

**解决方案**：

**步骤1：验证API密钥**
```bash
# 查看当前配置
openclaw config get models.providers.openai.apiKey

# 重新设置API密钥
openclaw config set models.providers.openai.apiKey "sk-xxx"
```

**步骤2：测试API连接**
```bash
# 使用 curl 测试
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer YOUR_API_KEY"
```

**步骤3：检查API密钥格式**
- OpenAI: `sk-` 开头
- DeepSeek: `sk-` 开头
- Kimi: 通常是长字符串
- 确保没有多余的空格或换行符

---

### 问题6：API请求超时

**症状**：
```bash
Error: Request timeout
ETIMEDOUT
```

**原因**：网络连接慢或API服务器响应慢

**解决方案**：

**方案1：增加超时时间**
```bash
openclaw config set models.timeout 60000  # 60秒
```

**方案2：使用国内API服务**
```json
{
  "models": {
    "providers": {
      "deepseek": {
        "apiKey": "sk-xxx",
        "baseURL": "https://api.deepseek.com"
      }
    }
  }
}
```

**方案3：使用代理**
```bash
# 设置代理
openclaw config set proxy.http "http://127.0.0.1:7890"
openclaw config set proxy.https "http://127.0.0.1:7890"
```

---

### 问题7：API限流

**症状**：
```bash
Error: Rate limit exceeded
429 Too Many Requests
```

**原因**：请求频率过高

**解决方案**：

**方案1：降低请求频率**
```bash
# 配置请求间隔
openclaw config set models.rateLimit.interval 1000  # 1秒
openclaw config set models.rateLimit.maxRequests 10
```

**方案2：使用多个API密钥轮询**
```json
{
  "models": {
    "providers": {
      "openai": {
        "apiKeys": [
          "sk-key1",
          "sk-key2",
          "sk-key3"
        ],
        "rotateKeys": true
      }
    }
  }
}
```

**方案3：升级API套餐**
- 联系API服务商提升限额
- 或切换到更高级别的套餐

---

## 🧩 Skills加载问题

### 问题8：Skills安装失败

**症状**：
```bash
Error: Failed to install skill
npm ERR! 404 Not Found
```

**原因**：Skills不存在或网络问题

**解决方案**：

**步骤1：检查Skills名称**
```bash
# 搜索可用的Skills
openclaw skills search "file"

# 查看Skills详情
openclaw skills info @openclaw/skill-file-search
```

**步骤2：手动安装**
```bash
# 进入Skills目录
cd ~/.openclaw/skills

# 手动安装
npm install @openclaw/skill-file-search
```

**步骤3：从GitHub安装**
```bash
clawhub install https://github.com/openclaw/skill-file-search
```

---

### 问题9：Skills不生效

**症状**：安装了Skills但无法使用

**原因**：Skills未启用或配置错误

**解决方案**：

**步骤1：检查Skills状态**
```bash
# 列出所有Skills
openclaw skills list

# 查看Skills详情
openclaw skills info @openclaw/skill-file-search
```

**步骤2：启用Skills**
```bash
# 启用Skills
openclaw skills enable @openclaw/skill-file-search

# 重启Gateway
openclaw gateway restart
```

**步骤3：检查Skills配置**
```bash
# 查看Skills配置
cat ~/.openclaw/skills/@openclaw/skill-file-search/config.json

# 修复配置
openclaw skills configure @openclaw/skill-file-search
```

---

### 问题10：Skills版本冲突

**症状**：
```bash
Error: Skill version conflict
```

**原因**：多个Skills依赖不同版本的库

**解决方案**：

**方案1：更新所有Skills**
```bash
# 更新所有Skills
openclaw skills update --all

# 或单独更新
openclaw skills update @openclaw/skill-file-search
```

**方案2：卸载冲突的Skills**
```bash
# 卸载Skills
openclaw skills uninstall @openclaw/skill-old-version

# 重新安装
clawhub install @openclaw/skill-file-search@latest
```

**方案3：使用兼容版本**
```bash
# 安装特定版本
clawhub install @openclaw/skill-file-search@1.2.0
```

---

## 🚪 Gateway问题

### 问题11：Gateway启动失败

**症状**：
```bash
Error: Failed to start gateway
Address already in use
```

**原因**：端口被占用

**解决方案**：

**方案1：查找占用端口的进程**
```bash
# macOS/Linux
lsof -i :18789

# 或使用 ss
ss -ltnp | grep 18789

# 杀死进程
kill -9 <PID>
```

**方案2：更改端口**
```bash
# 修改配置
openclaw config set gateway.port 18790

# 重启Gateway
openclaw gateway restart --port 18790
```

**方案3：强制启动**
```bash
# 停止所有Gateway进程
pkill -9 -f openclaw-gateway

# 重新启动
openclaw gateway run --force
```

---

### 问题12：Gateway无法访问

**症状**：访问 http://localhost:18789 无响应

**原因**：Gateway未启动或防火墙阻止

**解决方案**：

**步骤1：检查Gateway状态**
```bash
# 查看Gateway状态
openclaw gateway status

# 查看日志
tail -f ~/.openclaw/logs/gateway.log
```

**步骤2：检查防火墙**
```bash
# macOS
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/local/bin/openclaw

# Linux (ufw)
sudo ufw allow 18789
```

**步骤3：检查绑定地址**
```bash
# 确保绑定到正确的地址
openclaw config set gateway.bind "0.0.0.0"  # 允许外部访问
# 或
openclaw config set gateway.bind "127.0.0.1"  # 仅本地访问
```

---

### 问题13：Gateway频繁崩溃

**症状**：Gateway运行一段时间后自动退出

**原因**：内存泄漏或未捕获的异常

**解决方案**：

**方案1：查看错误日志**
```bash
# 查看最近的错误
tail -n 100 ~/.openclaw/logs/gateway.log | grep ERROR

# 实时监控
tail -f ~/.openclaw/logs/gateway.log
```

**方案2：增加内存限制**
```bash
# 设置Node.js内存限制
export NODE_OPTIONS="--max-old-space-size=4096"

# 重启Gateway
openclaw gateway restart
```

**方案3：使用进程管理器**
```bash
# 安装 pm2
npm install -g pm2

# 使用 pm2 启动
pm2 start openclaw -- gateway run
pm2 save
pm2 startup
```

---

## 📱 多平台集成问题

### 问题14：飞书Bot不回复

**症状**：在飞书中发送消息，Bot无响应

**原因**：配置错误或权限不足

**解决方案**：

**步骤1：检查配置**
```bash
# 查看飞书配置
openclaw config get channels.feishu

# 验证配置
openclaw channels test feishu
```

**步骤2：检查权限（最常见问题）**⭐

飞书Bot需要以下三个权限才能正常工作：

| 权限标识 | 权限名称 | 是否必需 |
|---------|---------|---------|
| `im:message` | 获取与发送单聊、群组消息 | ✅ 必需 |
| `im:message:send_as_bot` | 以应用身份发消息 | ✅ 必需 |
| `contact:contact.base:readonly` | 获取通讯录基本信息 | ✅ 必需 |

**如何添加权限**：
1. 登录飞书开放平台：https://open.feishu.cn
2. 进入你的应用
3. 点击"权限管理"
4. 搜索并添加上述三个权限
5. 点击"发布版本"使权限生效

> 💡 **特别注意**：`contact:contact.base:readonly` 权限经常被遗漏！
> 
> 这个权限用于获取用户基本信息，如果缺少：
> - ❌ 机器人无法识别消息发送者
> - ❌ 无法实现访问控制
> - ❌ 无法记录对话历史
> - ❌ 机器人完全无法响应消息

**步骤3：检查事件订阅**

确保已正确配置事件订阅：
1. 在飞书开放平台进入"事件订阅"页面
2. 选择"使用长连接接收事件"（WebSocket模式）
3. 添加事件：`im.message.receive_v1`
4. 确认长连接状态显示"已连接"

**步骤4：检查应用发布状态**
```text
1. 确认应用已通过审核
2. 确认应用已发布
3. 确认应用在可用范围内
```

**步骤5：查看日志**
```bash
# 查看飞书相关日志
openclaw logs --follow | grep feishu

# 或查看完整日志
tail -f ~/.openclaw/logs/gateway.log
```

**常见错误及解决**：

| 错误信息 | 原因 | 解决方案 |
|---------|------|---------|
| `Permission denied` | 缺少权限 | 添加所有必需权限 |
| `User not found` | 缺少通讯录权限 | 添加 `contact:contact.base:readonly` |
| `Connection failed` | 网关未启动 | 运行 `openclaw gateway start` |
| `Invalid app_id` | AppID错误 | 检查配置中的 appId |
| `Invalid app_secret` | AppSecret错误 | 检查配置中的 appSecret |

---

### 问题15：企业微信Bot配置失败

**症状**：
```bash
Error: Invalid corp_id or corp_secret
```

**原因**：企业微信配置参数错误

**解决方案**：

**步骤1：获取正确的参数**
- 登录企业微信管理后台
- 应用管理 → 自建应用
- 记录：
  - Corp ID（企业ID）
  - Agent ID（应用ID）
  - Secret（应用密钥）

**步骤2：配置OpenClaw**
```bash
openclaw config set channels.wecom.corpId "ww123456"
openclaw config set channels.wecom.agentId "1000001"
openclaw config set channels.wecom.secret "xxx"
```

**步骤3：测试连接**
```bash
openclaw channels test wecom
```

---

## 📁 文件操作问题

### 问题16：无法访问文件

**症状**：
```bash
Error: Permission denied
EACCES: permission denied
```

**原因**：文件权限不足

**解决方案**：

**方案1：修改文件权限**
```bash
# 给予读写权限
chmod 644 /path/to/file

# 或递归修改目录
chmod -R 755 /path/to/directory
```

**方案2：使用sudo运行**
```bash
# 不推荐，仅在必要时使用
sudo openclaw gateway run
```

**方案3：配置工作目录**
```bash
# 设置OpenClaw工作目录为有权限的目录
openclaw config set workspace.path "~/Documents/openclaw"
```

---

### 问题17：文件搜索结果为空

**症状**：搜索文件时返回空结果

**原因**：索引未建立或搜索路径错误

**解决方案**：

**步骤1：重建索引**
```bash
# 重建文件索引
openclaw files reindex

# 或指定目录
openclaw files reindex ~/Documents
```

**步骤2：检查搜索路径**
```bash
# 查看当前搜索路径
openclaw config get files.searchPaths

# 添加搜索路径
openclaw config set files.searchPaths '["~/Documents", "~/Desktop"]'
```

**步骤3：检查文件类型过滤**
```bash
# 查看文件类型过滤
openclaw config get files.excludePatterns

# 移除不必要的过滤
openclaw config set files.excludePatterns '["node_modules", ".git"]'
```

---

## ⚡ 性能问题

### 问题18：响应速度慢

**症状**：发送消息后等待很久才收到回复

**原因**：模型响应慢或网络延迟

**解决方案**：

**方案1：切换更快的模型**
```bash
# 使用更快的模型
openclaw config set models.default "deepseek-chat"  # 快速
# 而不是
# openclaw config set models.default "gpt-4"  # 较慢
```

**方案2：启用流式输出**
```bash
# 启用流式输出，边生成边显示
openclaw config set models.streaming true
```

**方案3：优化网络**
```bash
# 使用国内API服务
openclaw config set models.providers.deepseek.baseURL "https://api.deepseek.com"

# 或使用代理
openclaw config set proxy.http "http://127.0.0.1:7890"
```

---

### 问题19：内存占用过高

**症状**：OpenClaw占用大量内存

**原因**：缓存过多或内存泄漏

**解决方案**：

**方案1：清理缓存**
```bash
# 清理对话历史
openclaw cache clear --history

# 清理文件索引
openclaw cache clear --index

# 清理所有缓存
openclaw cache clear --all
```

**方案2：限制缓存大小**
```bash
# 限制对话历史条数
openclaw config set cache.maxHistory 100

# 限制文件索引大小
openclaw config set cache.maxIndexSize 1000
```

**方案3：重启Gateway**
```bash
# 定期重启Gateway释放内存
openclaw gateway restart
```

---

## 🔐 权限问题

### 问题20：macOS权限请求

**症状**：macOS提示需要授予权限

**原因**：macOS安全机制

**解决方案**：

**步骤1：授予完全磁盘访问权限**
1. 打开"系统偏好设置" → "安全性与隐私"
2. 选择"隐私"标签
3. 选择"完全磁盘访问权限"
4. 点击"+"添加 Terminal 或 iTerm
5. 重启终端

**步骤2：授予自动化权限**
1. 系统偏好设置 → 安全性与隐私 → 隐私
2. 选择"自动化"
3. 允许 Terminal 控制其他应用

**步骤3：授予辅助功能权限**
1. 系统偏好设置 → 安全性与隐私 → 隐私
2. 选择"辅助功能"
3. 添加 Terminal

---

## 🌐 网络问题

### 问题21：无法连接到API服务

**症状**：
```bash
Error: getaddrinfo ENOTFOUND api.openai.com
```

**原因**：DNS解析失败或网络不通

**解决方案**：

**方案1：检查网络连接**
```bash
# 测试网络
ping api.openai.com

# 测试DNS
nslookup api.openai.com
```

**方案2：更换DNS**
```bash
# macOS
sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 1.1.1.1

# Linux
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

**方案3：使用代理**
```bash
# 设置代理
export https_proxy=http://127.0.0.1:7890
export http_proxy=http://127.0.0.1:7890

# 或在配置中设置
openclaw config set proxy.http "http://127.0.0.1:7890"
```

---

## 🔌 端口问题

### 问题22：端口被占用

**症状**：
```bash
Error: listen EADDRINUSE: address already in use :::18789
```

**原因**：端口已被其他程序占用

**解决方案**：

**方案1：查找并关闭占用端口的程序**
```bash
# macOS/Linux
lsof -i :18789
kill -9 <PID>

# 或使用 fuser
fuser -k 18789/tcp
```

**方案2：更换端口**
```bash
# 使用其他端口
openclaw gateway run --port 18790
```

**方案3：配置文件中修改**
```bash
openclaw config set gateway.port 18790
```

---

## 🆘 获取帮助

如果以上方案都无法解决你的问题：

### 1. 查看日志
```bash
# 查看Gateway日志
tail -f ~/.openclaw/logs/gateway.log

# 查看错误日志
grep ERROR ~/.openclaw/logs/gateway.log
```

### 2. 运行诊断工具
```bash
# 运行诊断
openclaw doctor

# 查看系统信息
openclaw info
```

### 3. 社区求助
- 📖 [GitHub Discussions](https://github.com/xianyu110/awesome-openclaw-tutorial/discussions)
- 🐛 [提交Issue](https://github.com/xianyu110/awesome-openclaw-tutorial/issues)
- 💬 [加入交流群](../README.md#交流群)

### 4. 提供信息
提问时请提供：
- OpenClaw版本：`openclaw --version`
- 操作系统：`uname -a`
- Node.js版本：`node --version`
- 错误日志：最近50行日志
- 配置信息：`openclaw config list`（隐藏敏感信息）

---

## 📚 相关资源

- [第17章：避坑指南](17-best-practices.md)
- [附录A：命令速查表](../../appendix/A-command-reference.md)
- [附录D：社区资源导航](../../appendix/D-community-resources.md)

---

**最后更新**：2026年2月14日
