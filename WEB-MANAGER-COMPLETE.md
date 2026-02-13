# 🎉 OpenClaw Web 管理界面完成！

## 项目概览

已成功创建 React + Tailwind CSS 的现代化 Web 管理界面，用于管理 OpenClaw 的 4 个 Gateway 实例。

## 技术栈

- **前端**: React 18 + Vite
- **样式**: Tailwind CSS 3.4
- **后端**: Express.js 4.22
- **进程管理**: concurrently

## 功能特性

### 1. 实时状态监控
- ✅ 显示所有 4 个 Gateway 的运行状态
- ✅ 自动刷新（每 10 秒）
- ✅ 端口监听检测
- ✅ launchd 服务状态检测

### 2. 服务控制
- ✅ 一键启动所有服务
- ✅ 一键停止所有服务
- ✅ 一键重启所有服务
- ✅ 单个服务控制（启动/停止/重启）

### 3. 保活配置
- ✅ 一键配置 launchd 保活
- ✅ 开机自启动
- ✅ 崩溃自动重启

### 4. 日志查看
- ✅ 查看单个服务日志
- ✅ 实时日志输出
- ✅ 最近 100 行日志

### 5. 美观界面
- ✅ 现代化设计
- ✅ 响应式布局
- ✅ 渐变背景
- ✅ 卡片式服务展示
- ✅ 状态指示灯

## 快速开始

### 1. 启动应用

```bash
cd openclaw-manager-web
npm start
```

这会同时启动：
- 前端开发服务器: http://localhost:3000
- 后端 API 服务器: http://localhost:3001

### 2. 访问界面

打开浏览器访问: http://localhost:3000

### 3. 开始管理

- 查看所有服务状态
- 点击按钮控制服务
- 配置保活服务

## 界面说明

### 头部区域
- 🦞 OpenClaw 图标
- 标题和副标题
- 刷新按钮

### 操作按钮区
- ⚙️ 配置保活 - 配置 launchd 保活服务
- ▶️ 启动所有 - 启动所有 Gateway
- ⏹️ 停止所有 - 停止所有 Gateway
- 🔄 重启所有 - 重启所有 Gateway

### 服务卡片区
每个服务卡片显示：
- 服务名称（主助理、内容创作助手等）
- 服务 ID（main-assistant、content-creator 等）
- 运行状态（运行中/已停止）
- 端口号
- 使用的模型
- 快捷操作按钮（查看日志、重启）

### 系统信息区
- 总内存占用
- 运行服务数量
- 自动刷新间隔

## API 接口

### 状态查询
```
GET /api/status
```
返回所有服务的状态信息

### 批量操作
```
POST /api/start-all      # 启动所有
POST /api/stop-all       # 停止所有
POST /api/restart-all    # 重启所有
POST /api/setup-launchd  # 配置保活
```

### 单个服务操作
```
POST /api/start/:serviceId    # 启动单个
POST /api/stop/:serviceId     # 停止单个
POST /api/restart/:serviceId  # 重启单个
GET  /api/logs/:serviceId     # 获取日志
```

## 项目结构

```
openclaw-manager-web/
├── src/
│   ├── App.jsx          # 主应用组件
│   │   ├── 状态管理
│   │   ├── API 调用
│   │   ├── UI 渲染
│   │   └── 自动刷新
│   ├── main.jsx         # React 入口
│   └── index.css        # Tailwind 样式
├── server.js            # Express 后端
│   ├── API 路由
│   ├── 服务控制
│   ├── 状态检测
│   └── 日志读取
├── index.html           # HTML 模板
├── vite.config.js       # Vite 配置（代理设置）
├── tailwind.config.js   # Tailwind 配置
├── postcss.config.js    # PostCSS 配置
├── package.json         # 项目配置
└── README.md            # 项目文档
```

## 核心代码说明

### 前端 (App.jsx)

#### 状态管理
```javascript
const [services, setServices] = useState([...])  // 服务列表
const [loading, setLoading] = useState(false)    // 加载状态
const [message, setMessage] = useState('')       // 消息提示
```

#### 自动刷新
```javascript
useEffect(() => {
  checkStatus()
  const interval = setInterval(checkStatus, 10000)
  return () => clearInterval(interval)
}, [])
```

#### API 调用
```javascript
const checkStatus = async () => {
  const response = await fetch('/api/status')
  const data = await response.json()
  setServices(data.services)
}
```

### 后端 (server.js)

#### 端口检测
```javascript
async function checkPort(port) {
  const { stdout } = await execAsync(`lsof -i :${port}`)
  return stdout.trim().length > 0
}
```

#### launchd 检测
```javascript
async function checkLaunchdService(serviceId) {
  const { stdout } = await execAsync(
    `launchctl list | grep com.openclaw.${serviceId}`
  )
  return stdout.trim().length > 0
}
```

#### 脚本执行
```javascript
app.post('/api/start-all', async (req, res) => {
  const scriptPath = path.join(__dirname, '..', 'start-all-gateways.sh')
  await execAsync(`bash "${scriptPath}"`)
  res.json({ success: true })
})
```

## 配置说明

### Vite 代理配置
```javascript
// vite.config.js
export default defineConfig({
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:3001',
        changeOrigin: true,
      },
    },
  },
})
```

### Tailwind 配置
```javascript
// tailwind.config.js
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx}",
  ],
  theme: {
    extend: {},
  },
}
```

## 开发模式

### 前端开发
```bash
npm run dev
```
- 启动 Vite 开发服务器
- 热模块替换 (HMR)
- 快速刷新

### 后端开发
```bash
npm run server
```
- 启动 Express API 服务器
- 需要手动重启以应用更改

### 同时开发
```bash
npm start
```
- 使用 concurrently 同时运行前后端
- 推荐的开发方式

## 生产部署

### 1. 构建前端
```bash
npm run build
```
生成优化的静态文件到 `dist/` 目录

### 2. 预览构建
```bash
npm run preview
```
在本地预览生产构建

### 3. 部署选项

#### 选项 A: 静态文件 + API 服务器
```bash
# 构建前端
npm run build

# 使用 nginx 或其他服务器托管 dist/
# 单独运行 API 服务器
node server.js
```

#### 选项 B: Express 托管静态文件
```javascript
// 在 server.js 中添加
import express from 'express'
const app = express()

app.use(express.static('dist'))
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'))
})
```

## 故障排查

### 问题 1: 后端无法连接
```bash
# 检查端口占用
lsof -i :3001

# 检查后端进程
ps aux | grep "node server.js"

# 查看后端日志
# (在终端中查看 npm start 的输出)
```

### 问题 2: 前端无法访问
```bash
# 检查端口占用
lsof -i :3000

# 检查 Vite 进程
ps aux | grep vite

# 清除缓存重新启动
rm -rf node_modules/.vite
npm start
```

### 问题 3: API 调用失败
```bash
# 检查代理配置
cat vite.config.js

# 测试 API 直接访问
curl http://localhost:3001/api/status

# 检查 CORS 设置
# (Express 默认允许同源请求)
```

### 问题 4: 服务控制不工作
```bash
# 检查管理脚本
ls -la ../*.sh

# 确保脚本可执行
chmod +x ../*.sh

# 手动测试脚本
bash ../start-all-gateways.sh

# 检查脚本路径
# server.js 中的 path.join(__dirname, '..', 'script.sh')
```

### 问题 5: 状态检测不准确
```bash
# 手动检查端口
lsof -i :18789
lsof -i :18790
lsof -i :18791
lsof -i :18792

# 手动检查 launchd
launchctl list | grep openclaw

# 检查 Gateway 进程
ps aux | grep openclaw-gateway
```

## 性能优化

### 前端优化
- ✅ Vite 快速构建
- ✅ React 18 并发特性
- ✅ Tailwind CSS JIT 模式
- ✅ 代码分割（自动）

### 后端优化
- ✅ 异步 API 调用
- ✅ Promise.all 并行检测
- ✅ 缓存状态（可选）

### 网络优化
- ✅ Vite 代理减少延迟
- ✅ 自动刷新间隔可配置
- ✅ 按需加载日志

## 扩展功能

### 可以添加的功能

1. **实时日志流**
   - WebSocket 连接
   - 实时日志推送
   - 日志过滤和搜索

2. **性能监控**
   - CPU 使用率
   - 内存使用率
   - 请求统计

3. **告警通知**
   - 服务崩溃通知
   - 资源使用告警
   - 邮件/飞书通知

4. **配置管理**
   - 在线编辑配置
   - 配置验证
   - 配置备份/恢复

5. **用户认证**
   - 登录系统
   - 权限管理
   - 操作日志

## 安全建议

1. **生产环境**
   - 添加身份验证
   - 使用 HTTPS
   - 限制 API 访问

2. **命令执行**
   - 验证输入参数
   - 限制可执行命令
   - 使用白名单

3. **日志访问**
   - 限制日志大小
   - 过滤敏感信息
   - 定期清理

## 测试

### 手动测试清单

- [ ] 启动应用成功
- [ ] 前端界面正常显示
- [ ] 后端 API 响应正常
- [ ] 状态检测准确
- [ ] 启动所有服务成功
- [ ] 停止所有服务成功
- [ ] 重启所有服务成功
- [ ] 配置保活成功
- [ ] 单个服务控制成功
- [ ] 日志查看正常
- [ ] 自动刷新工作
- [ ] 响应式布局正常

### API 测试

```bash
# 测试状态接口
curl http://localhost:3001/api/status

# 测试启动接口
curl -X POST http://localhost:3001/api/start-all

# 测试停止接口
curl -X POST http://localhost:3001/api/stop-all

# 测试日志接口
curl http://localhost:3001/api/logs/main-assistant
```

## 总结

✅ 成功创建 React + Tailwind Web 管理界面  
✅ 前后端分离架构  
✅ 实时状态监控和自动刷新  
✅ 完整的服务控制功能  
✅ 美观的现代化 UI  
✅ 响应式设计支持移动端  
✅ 完善的 API 接口  
✅ 详细的文档和故障排查指南  

这个 Web 界面比 AppleScript 版本更强大、更易用、更美观！

---

**创建时间**: 2026-02-13  
**技术栈**: React 18 + Vite + Tailwind CSS + Express.js  
**作者**: Maynor  
**版本**: 1.0.0  
