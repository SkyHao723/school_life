# 后端API设计文档

## 概述
为校园生活应用设计的后端API接口文档，用于支持用户注册、登录、认证等功能。

## 技术栈建议
考虑到用户不会后端开发，推荐使用简单易学的技术栈：

1. **Node.js + Express** - 轻量级Web框架，易于学习和部署
2. **SQLite** - 轻量级数据库，无需复杂配置
3. **JWT** - 用于用户身份验证
4. **阿里云ECS** - 服务器部署环境

## API接口设计

### 1. 用户注册
**URL**: `/api/auth/register`  
**方法**: POST  
**描述**: 用户使用手机号注册账户  

**请求参数**:
```json
{
  "phone": "string",           // 手机号
  "password": "string",        // 密码
  "verificationCode": "string" // 短信验证码
}
```

**响应**:
```json
{
  "success": true,
  "message": "注册成功",
  "data": {
    "user": {
      "id": "string",
      "phone": "string",
      "username": "string",
      "isStudent": false,
      "createdAt": "ISO时间戳"
    },
    "token": "JWT令牌"
  }
}
```

### 2. 用户登录
**URL**: `/api/auth/login`  
**方法**: POST  
**描述**: 用户使用手机号和密码登录  

**请求参数**:
```json
{
  "phone": "string",    // 手机号
  "password": "string"  // 密码
}
```

**响应**:
```json
{
  "success": true,
  "message": "登录成功",
  "data": {
    "user": {
      "id": "string",
      "phone": "string",
      "username": "string",
      "isStudent": "boolean",
      "createdAt": "ISO时间戳"
    },
    "token": "JWT令牌"
  }
}
```

### 3. 发送验证码
**URL**: `/api/auth/send-code`  
**方法**: POST  
**描述**: 向指定手机号发送短信验证码  

**请求参数**:
```json
{
  "phone": "string"  // 手机号
}
```

**响应**:
```json
{
  "success": true,
  "message": "验证码已发送"
}
```

### 4. 用户登出
**URL**: `/api/auth/logout`  
**方法**: POST  
**描述**: 用户登出系统  

**请求头**:
```
Authorization: Bearer <token>
```

**响应**:
```json
{
  "success": true,
  "message": "登出成功"
}
```

### 5. 获取当前用户信息
**URL**: `/api/user/profile`  
**方法**: GET  
**描述**: 获取当前登录用户的信息  

**请求头**:
```
Authorization: Bearer <token>
```

**响应**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "string",
      "phone": "string",
      "username": "string",
      "isStudent": "boolean",
      "createdAt": "ISO时间戳"
    }
  }
}
```

### 6. 申请学生认证
**URL**: `/api/user/verify-student`  
**方法**: POST  
**描述**: 用户申请学生身份认证  

**请求头**:
```
Authorization: Bearer <token>
```

**请求参数**:
```json
{
  "studentId": "string",     // 学号
  "name": "string",          // 姓名
  "college": "string",       // 学院
  "major": "string",         // 专业
  "enrollmentYear": "number" // 入学年份
}
```

**响应**:
```json
{
  "success": true,
  "message": "认证申请已提交，等待审核"
}
```

## 错误响应格式
所有API接口在出现错误时，均返回以下格式：

```json
{
  "success": false,
  "message": "错误描述",
  "errorCode": "错误代码"
}
```

## 部署建议

### 1. 阿里云服务器环境配置
- 操作系统：Ubuntu 20.04 LTS 或 CentOS 8
- 安装Node.js运行环境
- 安装Nginx作为反向代理
- 配置SSL证书启用HTTPS
- 配置防火墙规则

### 2. 域名和SSL证书
- 申请域名并解析到阿里云服务器IP
- 使用Let's Encrypt免费SSL证书
- 配置Nginx支持HTTPS

### 3. 数据库设计
用户表(users):
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  phone VARCHAR(20) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  username VARCHAR(50),
  is_student BOOLEAN DEFAULT FALSE,
  student_id VARCHAR(50),
  name VARCHAR(50),
  college VARCHAR(100),
  major VARCHAR(100),
  enrollment_year INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

验证码表(verification_codes):
```sql
CREATE TABLE verification_codes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  phone VARCHAR(20) NOT NULL,
  code VARCHAR(10) NOT NULL,
  expires_at DATETIME NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 短信服务集成
建议使用阿里云短信服务：
1. 注册阿里云账号并开通短信服务
2. 申请短信签名和模板
3. 获取AccessKey用于API调用
4. 在后端集成短信发送功能

## 安全考虑
1. 所有密码需使用bcrypt等算法加密存储
2. 使用HTTPS保护数据传输安全
3. 实施JWT令牌过期机制
4. 限制短信验证码发送频率
5. 实施登录失败次数限制
6. 对敏感操作进行二次验证