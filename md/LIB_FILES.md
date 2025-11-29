# Lib 文件夹结构说明

本文档详细说明了 `lib` 文件夹中各个文件的作用和功能。

## 项目结构概览

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

## 文件详细说明

### 1. 主入口文件

#### [main.dart](file://d:\anzhuo\school_life\lib\main.dart)
- **作用**: 应用程序的入口点
- **功能**:
  - 初始化 Flutter 应用
  - 初始化全局服务（如存储服务）
  - 设置应用主题和本地化
  - 指定主页为 `MainScreen`

### 2. 页面文件 (screens/)

#### [auth_screen.dart](file://d:\anzhuo\school_life\lib\screens/auth_screen.dart)
- **作用**: 认证页面（登录/注册）
- **功能**:
  - 提供用户登录和注册界面
  - 实现表单验证
  - 集成手机号验证码功能

#### [feed_screen.dart](file://d:\anzhuo\school_life\lib\screens/feed_screen.dart)
- **作用**: 动态页面
- **功能**:
  - 展示帖子列表
  - 提供刷新和加载更多功能

#### [home_screen.dart](file://d:\anzhuo\school_life\lib\screens/home_screen.dart)
- **作用**: 应用首页
- **功能**:
  - 展示欢迎信息
  - 提供主要功能的快捷入口（以网格卡片形式展示）
  - 包含到各个主要功能模块的导航

#### [main_screen.dart](file://d:\anzhuo\school_life\lib\screens/main_screen.dart)
- **作用**: 主屏幕，包含底部导航栏
- **功能**:
  - 管理底部导航栏
  - 根据导航栏选择切换不同页面
  - 整合首页、动态、市场和设置页面

#### [market_screen.dart](file://d:\anzhuo\school_life\lib\screens/market_screen.dart)
- **作用**: 市场页面
- **功能**:
  - 展示市场相关功能
  - 提供商品浏览界面

#### [post_screen.dart](file://d:\anzhuo\school_life\lib\screens/post_screen.dart)
- **作用**: 发布帖子页面
- **功能**:
  - 提供发布新帖子的界面
  - 支持文字和图片内容
  - 实现表单验证

#### [settings_screen.dart](file://d:\anzhuo\school_life\lib\screens/settings_screen.dart)
- **作用**: 设置页面
- **功能**:
  - 提供应用设置选项
  - 包含个人信息、通知设置、主题设置等功能入口
  - 提供学生认证入口

#### [student_verification_screen.dart](file://d:\anzhuo\school_life\lib\screens/student_verification_screen.dart)
- **作用**: 学生认证页面
- **功能**:
  - 提供学生身份认证界面
  - 收集学生信息并提交认证请求

### 3. 数据模型文件 (models/)

#### [post.dart](file://d:\anzhuo\school_life\lib\models\post.dart)
- **作用**: 帖子数据模型
- **功能**:
  - 定义帖子数据结构
  - 提供 JSON 序列化和反序列化方法

#### [user.dart](file://d:\anzhuo\school_life\lib\models\user.dart)
- **作用**: 用户数据模型
- **功能**:
  - 定义用户数据结构
  - 提供 JSON 序列化和反序列化方法
  - 便于数据在网络传输和本地存储中的转换

### 4. 服务文件 (services/)

#### [api_service.dart](file://d:\anzhuo\school_life\lib\services\api_service.dart)
- **作用**: API服务
- **功能**:
  - 封装所有HTTP请求
  - 处理API调用和响应
  - 提供统一的错误处理机制

#### [auth_service.dart](file://d:\anzhuo\school_life\lib\services\auth_service.dart)
- **作用**: 认证服务
- **功能**:
  - 处理用户登录、注册和认证
  - 管理JWT令牌
  - 提供验证码相关功能

#### [database_service.dart](file://d:\anzhuo\school_life\lib\services\database_service.dart)
- **作用**: 数据库服务
- **功能**:
  - 管理本地数据库操作
  - 提供数据持久化功能

#### [storage_service.dart](file://d:\anzhuo\school_life\lib\services\storage_service.dart)
- **作用**: 本地存储服务
- **功能**:
  - 封装 shared_preferences 插件
  - 提供字符串和对象的存储与读取功能
  - 简化数据持久化操作

#### [user_service.dart](file://d:\anzhuo\school_life\lib\services\user_service.dart)
- **作用**: 用户服务
- **功能**:
  - 管理当前用户状态
  - 提供用户相关操作接口

### 5. 主题文件 (theme/)

#### [header_styles.dart](file://d:\anzhuo\school_life\lib\theme\header_styles.dart)
- **作用**: 标题样式
- **功能**:
  - 定义应用中使用的标题样式
  - 提供一致的UI设计语言

### 6. 工具文件 (utils/)

#### [constants.dart](file://d:\anzhuo\school_life\lib\utils\constants.dart)
- **作用**: 应用常量定义
- **功能**:
  - 定义应用名称、版本等基本信息
  - 定义本地存储键名等常量
  - 集中管理应用中的固定值，便于维护

### 7. 自定义组件文件夹 (widgets/)

当前文件夹为空，可用于存放自定义组件。