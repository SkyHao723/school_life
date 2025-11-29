# 校园生活应用项目概览

本文档整合了项目的所有重要文档，提供对整个项目的全面了解。

## 项目结构

### 整体目录结构

```
.
├── android/              # Android原生代码
├── backend_example/      # 后端服务示例代码
├── forui/                # ForUI组件库相关文件
├── ios/                  # iOS原生代码
├── lib/                  # Flutter应用核心代码
│   ├── main.dart         # 应用入口点
│   ├── models/           # 数据模型
│   ├── screens/          # 页面组件
│   ├── services/         # 业务服务
│   ├── theme/            # 主题样式
│   ├── utils/            # 工具类
│   └── widgets/          # 自定义组件
├── md/                   # 项目文档
├── test/                 # 测试文件
└── web/                  # Web相关文件
```

### Lib目录详细结构

```
lib/
├── main.dart                      # 应用程序入口点
├── screens/                       # 页面文件夹
│   ├── auth_screen.dart           # 认证页面（登录/注册）
│   ├── feed_screen.dart           # 动态页面
│   ├── home_screen.dart           # 首页
│   ├── main_screen.dart           # 主屏幕（包含底部导航栏）
│   ├── market_screen.dart         # 市场页面
│   ├── post_screen.dart           # 发布帖子页面
│   ├── settings_screen.dart       # 设置页面
│   └── student_verification_screen.dart  # 学生认证页面
├── widgets/                       # 自定义组件文件夹（当前为空）
├── models/                        # 数据模型文件夹
│   ├── post.dart                  # 帖子数据模型
│   └── user.dart                  # 用户数据模型
├── services/                      # 服务层文件夹
│   ├── api_service.dart           # API服务
│   ├── auth_service.dart          # 认证服务
│   ├── database_service.dart      # 数据库服务
│   ├── storage_service.dart       # 本地存储服务
│   └── user_service.dart          # 用户服务
├── theme/                         # 主题文件夹
│   └── header_styles.dart         # 标题样式
└── utils/                         # 工具类文件夹
    └── constants.dart             # 应用常量定义
```

## API接口文档

### 基础信息

- **Base URL**: `https://skyhao.xyz`
- **认证方式**: JWT Token
- **Content-Type**: `application/json`

### 接口列表

1. **状态检查**
   - **Endpoint**: `GET /api/status`
   - **Description**: 检查API服务是否正常运行

2. **发送验证码**
   - **Endpoint**: `POST /api/send-verification-code`
   - **Description**: 向用户手机发送验证码

3. **验证验证码**
   - **Endpoint**: `POST /api/verify-code`
   - **Description**: 验证用户输入的验证码是否正确

4. **用户注册**
   - **Endpoint**: `POST /api/register`
   - **Description**: 使用手机号、密码和验证码注册新用户

5. **用户登录**
   - **Endpoint**: `POST /api/login`
   - **Description**: 使用手机号和密码登录系统

6. **获取用户信息**
   - **Endpoint**: `GET /api/user/profile`
   - **Description**: 获取当前登录用户的详细信息

7. **申请学生认证**
   - **Endpoint**: `POST /api/request-student-verification`
   - **Description**: 提交学生身份认证申请

8. **发布帖子**
   - **Endpoint**: `POST /api/posts`
   - **Description**: 发布新帖子（仅限认证学生）

9. **获取帖子列表**
   - **Endpoint**: `GET /api/posts`
   - **Description**: 获取帖子列表，支持分页

10. **获取单个帖子**
    - **Endpoint**: `GET /api/posts/:id`
    - **Description**: 获取指定ID的帖子详情

## 部署指南

### 服务器信息

- 服务器IP: 8.130.28.213
- 域名: skyhao.xyz
- SSL证书: 已安装
- 管理面板: 宝塔面板

### 部署步骤

1. 准备工作
2. 安装Node.js
3. 上传后端代码
4. 安装依赖
5. 配置环境变量
6. 使用PM2启动服务
7. 配置宝塔站点
8. SSL证书配置

## 数据模型

### 用户模型 (User)

- **id**: INTEGER - 主键，自增
- **phone**: TEXT - 手机号，唯一
- **password**: TEXT - 加密后的密码
- **username**: TEXT - 用户名
- **is_student**: BOOLEAN - 是否为认证学生
- **student_id**: TEXT - 学号
- **name**: TEXT - 姓名
- **college**: TEXT - 学院
- **major**: TEXT - 专业
- **enrollment_year**: INTEGER - 入学年份
- **created_at**: DATETIME - 创建时间
- **updated_at**: DATETIME - 更新时间

### 帖子模型 (Post)

- **id**: INTEGER - 主键，自增
- **user_id**: INTEGER - 用户ID，外键
- **title**: TEXT - 帖子标题
- **content**: TEXT - 帖子内容
- **is_anonymous**: BOOLEAN - 是否匿名发布
- **created_at**: DATETIME - 创建时间

### 验证码模型 (VerificationCode)

- **id**: INTEGER - 主键，自增
- **phone**: TEXT - 手机号
- **code**: TEXT - 验证码
- **expires_at**: DATETIME - 过期时间
- **created_at**: DATETIME - 创建时间

## 服务层说明

### API服务 (api_service.dart)

负责与后端API通信，封装所有HTTP请求。

### 认证服务 (auth_service.dart)

处理用户登录、注册和认证相关功能。

### 数据库服务 (database_service.dart)

管理本地数据库操作。

### 存储服务 (storage_service.dart)

封装shared_preferences插件，提供本地数据存储功能。

### 用户服务 (user_service.dart)

管理当前用户状态。

## 主要页面功能

### 认证页面 (auth_screen.dart)

提供用户登录和注册界面。

### 动态页面 (feed_screen.dart)

展示帖子列表。

### 首页 (home_screen.dart)

应用首页，提供主要功能快捷入口。

### 主屏幕 (main_screen.dart)

包含底部导航栏，整合各个主要页面。

### 市场页面 (market_screen.dart)

展示市场相关功能。

### 发布帖子页面 (post_screen.dart)

提供发布新帖子的界面。

### 设置页面 (settings_screen.dart)

提供应用设置选项。

### 学生认证页面 (student_verification_screen.dart)

提供学生身份认证界面。