# 校园生活应用后端API文档

## 概述

本文档详细描述了校园生活应用与后端服务器之间所有的API接口。这些接口基于Express.js框架构建，使用SQLite作为数据库，JWT进行身份验证。

## 基础信息

- **Base URL**: `https://skyhao.xyz`
- **认证方式**: JWT Token
- **Content-Type**: `application/json`

## 状态码

| 状态码 | 描述 |
|--------|------|
| 200 | 请求成功 |
| 201 | 创建成功 |
| 400 | 请求参数错误 |
| 401 | 未授权访问 |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## 认证流程

1. 用户通过 `/api/send-verification-code` 获取验证码
2. 用户通过 `/api/verify-code` 验证验证码
3. 用户通过 `/api/register` 注册账号
4. 用户通过 `/api/login` 登录获取JWT Token
5. 在需要认证的接口中，在请求头中添加 `Authorization: Bearer <token>`

## API接口详情

### 1. 状态检查

**Endpoint**: `GET /api/status`  
**Description**: 检查API服务是否正常运行  
**Authentication**: None  
**Request**: 无参数  
**Response**:
```json
{
  "success": true,
  "message": "API服务运行正常",
  "data": {
    "timestamp": "2023-01-01T00:00:00.000Z",
    "uptime": 12345.678
  }
}
```

### 2. 发送验证码

**Endpoint**: `POST /api/send-verification-code`  
**Description**: 向用户手机发送验证码（测试模式下使用固定验证码9999）  
**Authentication**: None  
**Request Body**:
```json
{
  "phone": "13800138000"
}
```
**Response Success**:
```json
{
  "success": true,
  "message": "验证码已发送（模拟）"
}
```
**Response Error**:
```json
{
  "success": false,
  "message": "手机号不能为空"
}
```

### 3. 验证验证码

**Endpoint**: `POST /api/verify-code`  
**Description**: 验证用户输入的验证码是否正确  
**Authentication**: None  
**Request Body**:
```json
{
  "phone": "13800138000",
  "verificationCode": "9999"
}
```
**Response Success**:
```json
{
  "success": true,
  "message": "验证码正确"
}
```
**Response Error**:
```json
{
  "success": false,
  "message": "验证码错误"
}
```

### 4. 用户注册

**Endpoint**: `POST /api/register`  
**Description**: 使用手机号、密码和验证码注册新用户  
**Authentication**: None  
**Request Body**:
```json
{
  "phone": "13800138000",
  "password": "password123",
  "verificationCode": "9999"
}
```
**Response Success**:
```json
{
  "success": true,
  "message": "注册成功",
  "data": {
    "user": {
      "id": 1,
      "phone": "13800138000",
      "username": "用户38000",
      "is_student": false,
      "created_at": "2023-01-01T00:00:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```
**Response Error**:
```json
{
  "success": false,
  "message": "手机号、密码和验证码不能为空"
}
```

### 5. 用户登录

**Endpoint**: `POST /api/login`  
**Description**: 使用手机号和密码登录系统  
**Authentication**: None  
**Request Body**:
```json
{
  "phone": "13800138000",
  "password": "password123"
}
```
**Response Success**:
```json
{
  "success": true,
  "message": "登录成功",
  "data": {
    "user": {
      "id": 1,
      "phone": "13800138000",
      "username": "用户38000",
      "is_student": false,
      "created_at": "2023-01-01T00:00:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```
**Response Error**:
```json
{
  "success": false,
  "message": "手机号或密码错误"
}
```

### 6. 获取用户信息

**Endpoint**: `GET /api/user/profile`  
**Description**: 获取当前登录用户的详细信息  
**Authentication**: Bearer Token  
**Headers**:
```
Authorization: Bearer <jwt_token>
```
**Request**: 无参数  
**Response Success**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "phone": "13800138000",
      "username": "用户38000",
      "is_student": false,
      "created_at": "2023-01-01T00:00:00.000Z"
    }
  }
}
```

### 7. 申请学生认证

**Endpoint**: `POST /api/request-student-verification`  
**Description**: 提交学生身份认证申请（测试模式下直接通过）  
**Authentication**: Bearer Token  
**Headers**:
```
Authorization: Bearer <jwt_token>
```
**Request Body**:
```json
{
  "studentId": "20230001",
  "name": "张三",
  "college": "计算机学院",
  "major": "计算机科学与技术",
  "enrollmentYear": 2023
}
```
**Response Success**:
```json
{
  "success": true,
  "message": "学生认证成功"
}
```
**Response Error**:
```json
{
  "success": false,
  "message": "认证信息不能为空"
}
```

### 8. 用户登出

**Endpoint**: `POST /api/auth/logout`  
**Description**: 用户登出系统  
**Authentication**: Bearer Token  
**Headers**:
```
Authorization: Bearer <jwt_token>
```
**Request**: 无参数  
**Response Success**:
```json
{
  "success": true,
  "message": "登出成功"
}
```

### 9. 发布帖子

**Endpoint**: `POST /api/posts`  
**Description**: 发布新帖子（仅限认证学生）  
**Authentication**: Bearer Token  
**Headers**:
```
Authorization: Bearer <jwt_token>
```
**Request Body**:
```json
{
  "title": "帖子标题",
  "content": "帖子内容",
  "isAnonymous": false
}
```
**Response Success**:
```json
{
  "success": true,
  "message": "帖子发布成功",
  "data": {
    "postId": 1
  }
}
```
**Response Error**:
```json
{
  "success": false,
  "message": "只有认证学生才能发布帖子"
}
```

### 10. 获取帖子列表

**Endpoint**: `GET /api/posts`  
**Description**: 获取帖子列表，支持分页  
**Authentication**: None  
**Query Parameters**:
- `page`: 页码（默认1）
- `limit`: 每页数量（默认10）

**Request Example**: `GET /api/posts?page=1&limit=10`  
**Response Success**:
```json
{
  "success": true,
  "data": {
    "posts": [
      {
        "id": 1,
        "user_id": 1,
        "title": "帖子标题",
        "content": "帖子内容",
        "is_anonymous": 0,
        "created_at": "2023-01-01T00:00:00.000Z",
        "username": "用户38000"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 10,
      "totalPosts": 100,
      "hasNextPage": true,
      "hasPrevPage": false
    }
  }
}
```

### 11. 获取单个帖子

**Endpoint**: `GET /api/posts/:id`  
**Description**: 获取指定ID的帖子详情  
**Authentication**: None  
**Request Example**: `GET /api/posts/1`  
**Response Success**:
```json
{
  "success": true,
  "data": {
    "post": {
      "id": 1,
      "user_id": 1,
      "title": "帖子标题",
      "content": "帖子内容",
      "is_anonymous": 0,
      "created_at": "2023-01-01T00:00:00.000Z",
      "username": "用户38000"
    }
  }
}
```
**Response Error**:
```json
{
  "success": false,
  "message": "帖子不存在"
}
```

## 数据库结构

### 用户表 (users)
| 字段名 | 类型 | 描述 |
|--------|------|------|
| id | INTEGER | 主键，自增 |
| phone | TEXT | 手机号，唯一 |
| password | TEXT | 加密后的密码 |
| username | TEXT | 用户名 |
| is_student | BOOLEAN | 是否为认证学生 |
| student_id | TEXT | 学号 |
| name | TEXT | 姓名 |
| college | TEXT | 学院 |
| major | TEXT | 专业 |
| enrollment_year | INTEGER | 入学年份 |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

### 验证码表 (verification_codes)
| 字段名 | 类型 | 描述 |
|--------|------|------|
| id | INTEGER | 主键，自增 |
| phone | TEXT | 手机号 |
| code | TEXT | 验证码 |
| expires_at | DATETIME | 过期时间 |
| created_at | DATETIME | 创建时间 |

### 帖子表 (posts)
| 字段名 | 类型 | 描述 |
|--------|------|------|
| id | INTEGER | 主键，自增 |
| user_id | INTEGER | 用户ID，外键 |
| title | TEXT | 帖子标题 |
| content | TEXT | 帖子内容 |
| is_anonymous | BOOLEAN | 是否匿名发布 |
| created_at | DATETIME | 创建时间 |

## 安全说明

1. 所有密码都经过bcrypt加密存储
2. 使用JWT进行身份验证，有效期24小时
3. 所有API接口都支持CORS
4. 生产环境需要使用HTTPS协议
5. 敏感信息（如JWT密钥）应通过环境变量配置

## 错误处理

所有错误响应都遵循统一格式：
```json
{
  "success": false,
  "message": "错误描述信息"
}
```

## 测试说明

在测试模式下：
1. 验证码固定为9999
2. 学生认证申请会直接通过
3. 不需要真实的短信服务

## 部署说明

1. 确保服务器已安装Node.js环境
2. 安装依赖：`npm install`
3. 配置环境变量（JWT密钥等）
4. 启动服务：`node server.js`

## 版本信息

当前文档适用于后端服务版本1.0.0