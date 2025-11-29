# ForUI 组件库学习总结

ForUI 是一个 Flutter 的现代化 UI 组件库，提供了丰富的组件用于构建美观且功能强大的用户界面。以下是基于参考代码的学习总结。

## 1. 基础组件 (Foundation)

### FCollapsible 折叠组件
- 用于在可见和隐藏状态之间进行动画切换
- 需要配合 AnimationController 和 CurvedAnimation 使用
- 通过 value 参数控制展开程度 (0.0 为折叠，1.0 为完全展开)

```dart
// 基本用法
FCollapsible(
  value: 1.0, // 0.0 for collapsed, 1.0 for expanded.
  child: const Text('child'),
);
```

## 2. 布局组件 (Layout)

### FDivider 分割线
- 用于在视觉或语义上分隔内容
- 可以水平或垂直显示
- 支持自定义样式

```dart
// 水平分割线
const FDivider()

// 垂直分割线
const FDivider(axis: Axis.vertical)
```

## 3. 导航组件 (Navigation)

### FBottomNavigationBar 底部导航栏
- 通常出现在根页面底部
- 用于在少量视图间导航（通常3-5个）
- 需要与 FScaffold 配合使用

```dart
FBottomNavigationBar(
  index: index,
  onChange: (index) => setState(() => this.index = index),
  children: [
    FBottomNavigationBarItem(
      icon: Icon(FIcons.house),
      label: const Text('Home'),
    ),
    // 更多项...
  ],
);
```

## 4. 表单组件 (Form)

### FAutocomplete 自动完成
- 根据用户输入提供候选建议列表
- 显示首个匹配项的自动补全文本
- 作为表单字段，可在表单中使用

```dart
FAutocomplete(
  label: Text('Autocomplete'),
  hint: 'What can it do?',
  items: features,
);
```

## 5. 覆盖层组件 (Overlay)

### FDialog 对话框
- 模态对话框，用于打断用户并显示重要内容
- 期望用户进行响应
- 提供多种显示方式

```dart
// 显示对话框
showFDialog(
  context: context,
  builder: (context, style, animation) => FDialog(
    style: style,
    animation: animation,
    direction: Axis.horizontal,
    title: const Text('Are you absolutely sure?'),
    body: const Text('This action cannot be undone. This will permanently delete your account and remove your data from our servers.'),
    actions: [
      FButton(style: FButtonStyle.outline(), onPress: () => Navigator.of(context).pop(), child: const Text('Cancel')),
      FButton(onPress: () => Navigator.of(context).pop(), child: const Text('Continue')),
    ],
  ),
);
```

## 6. 数据展示组件 (Data Presentation)

### FAccordion 手风琴
- 垂直堆叠的一组交互式标题
- 点击时显示相关内容部分
- 每个部分可独立展开或折叠

```dart
FAccordion(
  controller: FAccordionController(),
  children: [
    FAccordionItem(
      title: const Text('Production Information'),
      child: Text('详细内容'),
    ),
    // 更多项...
  ],
);
```

## 7. 反馈组件 (Feedback)

### FAlert 警报
- 显示引起用户注意的提示信息
- 支持不同类型（主要、破坏性等）

```dart
FAlert(
  title: const Text('Heads Up!'),
  subtitle: const Text('You can add components to your app using the cli.'),
);
```

## 8. 瓦片组件 (Tile)

### FTile 瓦片
- 专为触摸设备设计的特殊 Item
- 通常用于将相关信息组合在一起
- 可以组合在 FTileGroup 中

```dart
FTile(
  prefix: Icon(FIcons.user),
  title: const Text('Personalization'),
  suffix: Icon(FIcons.chevronRight),
  onPress: () { },
);
```

## 9. 主题和样式

ForUI 提供了丰富的主题和样式支持：

- 使用 FTheme 或 FAnimatedTheme 应用主题
- 通过 context.theme 访问当前主题数据
- 支持通过 CLI 工具生成和自定义样式

## 10. CLI 工具支持

ForUI 提供了命令行工具来帮助快速生成和自定义组件样式：

```bash
# 生成并自定义样式
dart run forui style create [component-name]
```

例如：
```bash
dart run forui style create bottom-navigation-bar
dart run forui style create dialog
dart run forui style create accordion
```

## 11. 组件使用要点

1. **事件处理**：大多数交互组件都有相应的回调函数，如 onPress、onChange 等
2. **状态管理**：复杂组件通常需要控制器（如 FAccordionController、FAccordionController）
3. **样式定制**：几乎所有组件都支持通过 style 参数进行外观定制
4. **无障碍支持**：组件内置了对辅助功能的支持
5. **动画支持**：许多组件内置了动画效果，也可以自定义动画

## 12. 最佳实践

1. 合理组织组件层级结构
2. 充分利用 ForUI 提供的主题系统保持界面一致性
3. 根据需要使用 CLI 工具生成自定义样式
4. 注意组件间的搭配使用（如 FBottomNavigationBar 与 FScaffold 的配合）
5. 充分利用组件提供的各种状态管理和事件处理机制