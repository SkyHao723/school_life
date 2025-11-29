#!/bin/bash

# 后端服务部署脚本
# 用于在阿里云服务器上部署校园生活应用的后端服务

echo "开始部署校园生活后端服务..."

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]
  then echo "请以root权限运行此脚本"
  exit
fi

# 更新系统
echo "更新系统..."
apt update && apt upgrade -y

# 安装必要的软件包
echo "安装Node.js和Git..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs git

# 安装PM2
echo "安装PM2..."
npm install -g pm2

# 创建应用目录
echo "创建应用目录..."
mkdir -p /opt/school-life
cd /opt/school-life

# 克隆代码（如果这是首次部署）
if [ ! -d "backend" ]; then
  echo "克隆后端代码..."
  mkdir backend
fi

# 复制后端代码到服务器目录
echo "复制后端代码..."
# 这里应该是从你的代码仓库克隆代码，或者通过其他方式上传代码

# 安装依赖
echo "安装Node.js依赖..."
cd backend
npm install

# 创建环境变量文件
echo "创建环境变量文件..."
cat > .env << EOF
SECRET_KEY=your_very_secure_secret_key_here_change_this
PORT=3000
NODE_ENV=production
EOF

# 使用PM2启动服务
echo "启动后端服务..."
pm2 start server.js --name school-life-backend
pm2 startup
pm2 save

# 安装和配置Nginx
echo "安装Nginx..."
apt install -y nginx

# 创建Nginx配置
echo "创建Nginx配置..."
cat > /etc/nginx/sites-available/school-life << EOF
server {
    listen 80;
    server_name skyhao.xyz;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# 启用站点
ln -sf /etc/nginx/sites-available/school-life /etc/nginx/sites-enabled/

# 测试Nginx配置
echo "测试Nginx配置..."
nginx -t

# 重启Nginx
echo "重启Nginx..."
systemctl restart nginx

# 配置防火墙
echo "配置防火墙..."
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

echo "部署完成！"
echo "请记得:"
echo "1. 更新.env文件中的SECRET_KEY为强随机字符串"
echo "2. 配置SSL证书（如果还没有配置）"
echo "3. 检查PM2状态: pm2 status"
echo "4. 查看应用日志: pm2 logs school-life-backend"