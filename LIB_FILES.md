# Lib 文件夹结构说明

本文档详细说明了 `lib` 文件夹中各个文件的作用和功能。

## 项目结构概览

```
lib/
├── main.dart                 # 应用程序入口点
├── screens/                  # 页面文件夹
│   ├── home_screen.dart      # 首页
│   ├── main_screen.dart      # 主屏幕（包含底部导航栏）
│   ├── （已删除）schedule_screen.dart  # 课程表页面
│   ├── （已删除）grades_screen.dart    # 成绩查询页面
│   ├── settings_screen.dart  # 设置页面
│   ├── lost_and_found_screen.dart # 失物招领页面（计划中）
│   └── market_screen.dart    # 市场页面（计划中）
├── widgets/                  # 自定义组件文件夹
├── models/                   # 数据模型文件夹
│   └── user.dart             # 用户数据模型
├── services/                 # 服务层文件夹
│   └── storage_service.dart  # 本地存储服务
└── utils/                    # 工具类文件夹
    └── constants.dart        # 应用常量定义
```

## 文件详细说明

### 1. 主入口文件

#### [main.dart](lib/main.dart)
- **作用**: 应用程序的入口点
- **功能**:
  - 初始化 Flutter 应用
  - 初始化全局服务（如存储服务）
  - 设置应用主题和本地化
  - 指定主页为 `MainScreen`

### 2. 页面文件 (screens/)

#### [home_screen.dart](lib/screens/home_screen.dart)
- **作用**: 应用首页
- **功能**:
  - 展示欢迎信息
  - 提供主要功能的快捷入口（以网格卡片形式展示）
  - 包含到各个主要功能模块的导航

#### [main_screen.dart](lib/screens/main_screen.dart)
- **作用**: 主屏幕，包含底部导航栏
- **功能**:
  - 管理底部导航栏
  - 根据导航栏选择切换不同页面
  - 整合首页、失物招领、市场和设置页面

#### [（已删除）schedule_screen.dart](lib/screens/schedule_screen.dart)
- **作用**: 课程表页面
- **功能**:
  - 展示用户的课程安排
  - 提供课程详情查看功能

#### [（已删除）logrades_screen.dart](lib/screens/grades_screen.dart)
- **作用**: 成绩查询页面
- **功能**:
  - 展示用户的成绩记录
  - 提供成绩详情查看功能

#### [settings_screen.dart](lib/screens/settings_screen.dart)
- **作用**: 设置页面
- **功能**:
  - 提供应用设置选项
  - 包含个人信息、通知设置、主题设置等功能入口

### 3. 数据模型文件 (models/)

#### [user.dart](lib/models/user.dart)
- **作用**: 用户数据模型
- **功能**:
  - 定义用户数据结构
  - 提供 JSON 序列化和反序列化方法
  - 便于数据在网络传输和本地存储中的转换

### 4. 服务文件 (services/)

#### [storage_service.dart](lib/services/storage_service.dart)
- **作用**: 本地存储服务
- **功能**:
  - 封装 shared_preferences 插件
  - 提供字符串和对象的存储与读取功能
  - 简化数据持久化操作

### 5. 工具文件 (utils/)

#### [constants.dart](lib/utils/constants.dart)
- **作用**: 应用常量定义
- **功能**:
  - 定义应用名称、版本等基本信息
  - 定义本地存储键名等常量
  - 集中管理应用中的固定值，便于维护

### 6. 自定义组件文件夹 (widgets/)

当前为空文件夹，预留用于存放自定义组件。

## 设计原则

1. **分层架构**: 采用分层架构设计，将界面、业务逻辑和数据访问分离
2. **单一职责**: 每个文件都有明确的职责和功能
3. **可扩展性**: 结构设计便于后续功能扩展
4. **可维护性**: 清晰的目录结构和命名规范，便于代码维护

## 开发约定

1. **文件命名**: 使用下划线命名法（snake_case）
2. **组件命名**: 使用大驼峰命名法（PascalCase）
3. **私有成员**: 使用下划线前缀标识私有成员
4. **注释规范**: 重要逻辑需添加注释说明