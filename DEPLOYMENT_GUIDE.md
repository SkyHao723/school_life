# 阿里云服务器部署指南

## 概述
本指南将帮助你在阿里云服务器上部署校园生活应用的后端服务。


## 服务器信息

- 服务器IP: 8.130.28.213
- 域名: skyhao.xyz
- SSL证书: 已安装
- 管理面板: 宝塔面板

## 部署步骤

### 1. 准备工作

确保您的阿里云服务器满足以下要求：

- 宝塔面板已安装并可访问
- 操作系统: CentOS 7/8, RHEL, 或 Alibaba Cloud Linux
- Node.js 14.x 或更高版本
- Nginx已安装

### 2. 安装Node.js

您的服务器似乎是基于Red Hat的系统（如CentOS或Alibaba Cloud Linux），而不是Debian-based系统。在这种情况下，请按以下步骤安装Node.js：

#### 方法一：使用NodeSource仓库（推荐）

```bash
# 下载并执行NodeSource安装脚本
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -

# 安装Node.js
sudo yum install -y nodejs
```

#### 方法二：使用EPEL仓库

```bash
# 启用EPEL仓库
sudo yum install -y epel-release

# 安装Node.js和npm
sudo yum install -y nodejs npm
```

验证安装：
```bash
node -v
npm -v
```

### 3. 上传后端代码

将 [backend_example](file://d:\anzhuo\school_life\backend_example) 目录中的代码上传到您的服务器。您可以通过以下几种方式：

1. 使用宝塔面板的文件管理器直接上传
2. 使用SCP命令：
   ```bash
   scp -r ./backend_example root@8.130.28.213:/www/wwwroot/school-life-api
   ```
3. 使用Git克隆（如果代码已托管在代码仓库中）

### 4. 安装依赖

通过宝塔面板的终端或者SSH连接到服务器，进入后端代码目录并安装依赖：

```bash
cd /www/wwwroot/school-life-api
npm install
```

### 5. 配置环境变量

创建 `.env` 文件并配置必要的环境变量：

```bash
cp .env.example .env
nano .env
```

需要配置的变量包括：
- PORT: 服务监听端口（默认3000）
- JWT_SECRET: JWT密钥（请替换为一个强随机字符串）
- DATABASE_PATH: SQLite数据库路径

示例配置：
```
PORT=3000
JWT_SECRET=your_super_secret_key_here_make_it_long_and_random
DATABASE_PATH=./school_life.db
```

### 6. 使用PM2启动服务

宝塔面板通常已预装PM2，如果没有，请先安装：

```bash
npm install -g pm2
```

使用PM2启动服务：

```bash
pm2 start server.js --name school-life-api
pm2 startup
pm2 save
```

### 7. 配置宝塔站点

1. 登录宝塔面板
2. 进入网站管理页面
3. 添加站点：
   - 域名：skyhao.xyz
   - 根目录：/www/wwwroot/school-life-api
   - PHP版本：纯静态
4. 点击刚创建的站点，进入设置页面
5. 在「反向代理」选项卡中添加反向代理：
   - 代理名称：api
   - 目标URL：http://127.0.0.1:3000
   - 发送域名：$host
   - URL后缀：/

### 8. SSL证书配置

由于您已安装SSL证书，可以通过宝塔面板的SSL选项卡进行配置：

1. 在站点设置中找到SSL选项卡
2. 选择已安装的证书或者申请新的Let's Encrypt证书
3. 开启强制HTTPS（推荐）

## 测试部署

部署完成后，您可以通过以下方式测试API：

```bash
curl https://skyhao.xyz/api/status
```

或者在浏览器中访问 https://skyhao.xyz/api/status

## 验证码机制

当前系统使用临时验证码机制：
- 测试期间，任何验证码都会被接受
- 正式环境中应接入真实的短信服务API
- 当前预留的接口可以方便地替换为真实的短信服务

## 宝塔面板特殊说明

使用宝塔面板的优势：
1. 图形化界面简化了服务器管理
2. 内置的Nginx配置简化了反向代理设置
3. 站点管理更加直观
4. SSL证书管理更加简便
5. 文件管理更加方便

注意事项：
1. 确保防火墙开放了必要的端口（如3000）
2. 宝塔面板的安全入口可能需要特别注意
3. 日志查看可通过宝塔面板直接进行

## 后续步骤

1. 部署后端服务到您的阿里云服务器
2. 更新 [lib/services/api_service.dart](file://d:\anzhuo\school_life\lib\services\api_service.dart) 中的 [_baseUrl](file://d:\anzhuo\school_life\lib\services\api_service.dart#L32-L32) 为您的域名
3. 测试注册、登录和学生认证功能
4. 根据需要接入真实的短信服务API
