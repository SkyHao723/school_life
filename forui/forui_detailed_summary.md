# ForUI 组件库详细学习总结

ForUI 是一个 Flutter 组件库，提供了丰富的 UI 组件用于构建现代化的应用程序界面。以下是对 ForUI 各个组件模块的详细学习总结。

## 1. 基础组件 (Foundation)

### 1.1 FCollapsible 折叠组件

FCollapsible 是一个可折叠的动画组件，可以在可见和隐藏状态之间切换。

**基本用法：**
```dart
FCollapsible(
  value: 1.0, // 0.0 表示折叠，1.0 表示展开
  child: const Text('child'),
);
```

**完整示例：**
```dart
class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
    _controller.toggle();
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FButton(onPress: _toggle, child: Text(_expanded ? 'Collapse' : 'Expand')),
      const SizedBox(height: 16),
      AnimatedBuilder(
        animation: _animation,
        builder:
            (context, child) => FCollapsible(
              value: _animation.value,
              child: FCard(
                title: const Text('Lorem ipsum'),
                child: const Text(
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
                  'accusantium doloremque laudantium, totam rem aperiam, eaque ipsa '
                  'quae ab illo inventore veritatis et quasi architecto beatae vitae '
                  'dicta sunt explicabo.',
                ),
              ),
            ),
      ),
    ],
  );
}
```

### 1.2 FFocusedOutline 焦点轮廓

FFocusedOutline 为获得焦点的组件添加轮廓，不影响布局。

**基本用法：**
```dart
FFocusedOutline(
  focused: true,
  child: Container(
    decoration: BoxDecoration(
      color: context.theme.colors.primary,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
    child: Text(
      'Focused',
      style: context.theme.typography.base.copyWith(
        color: context.theme.colors.primaryForeground,
      ),
    ),
  ),
);
```

### 1.3 FPortal 门户组件

FPortal 在子组件上方"浮动"渲染内容，常用于创建弹出层。

**基本用法：**
```dart
FPortal(
  controller: OverlayPortalController(),
  spacing: FPortalSpacing.zero,
  shift: FPortalShift.flip,
  offset: Offset.zero,
  portalConstraints: const FAutoWidthPortalConstraints(),
  portalAnchor: Alignment.topCenter,
  childAnchor: Alignment.bottomCenter,
  viewInsets: EdgeInsets.zero,
  barrier: Container(color: Colors.blue),
  portalBuilder: (context, controller) => const Text('portal'),
  builder: (context, controller, child) => child!,
  child: const Text('child'),
);
```

**完整示例：**
```dart
class PortalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FPortal(
    spacing: const FPortalSpacing(8),
    viewInsets: const EdgeInsets.all(5),
    portalBuilder: (context, _) => Container(
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border.all(color: context.theme.colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.only(left: 20, top: 14, right: 20, bottom: 10),
      child: SizedBox(
        width: 288,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dimensions', style: context.theme.typography.base),
            const SizedBox(height: 7),
            Text(
              'Set the dimensions for the layer.',
              style: context.theme.typography.sm.copyWith(
                color: context.theme.colors.mutedForeground,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 15),
            for (final (label, value) in [('Width', '100%'), ('Max. Width', '300px')]) ...[
              Row(
                children: [
                  Expanded(child: Text(label, style: context.theme.typography.sm)),
                  Expanded(flex: 2, child: FTextField(initialText: value)),
                ],
              ),
              const SizedBox(height: 7),
            ],
          ],
        ),
      ),
    ),
    builder: (context, controller, _) => FButton(onPress: controller.toggle, child: const Text('Portal')),
  );
}
```

### 1.4 FTappable 可点击区域

FTappable 是一个响应触摸的区域，常用于创建自定义可点击组件。

**基本用法：**
```dart
const FTappable(
  style: FTappableStyle(),
  semanticsLabel: 'Label',
  excludeSemantics: false,
  selected: false,
  autofocus: false,
  focusNode: FocusNode(),
  onFocusChange: (focused) {},
  onHoverChange: (hovered) {},
  onStateChange: (delta) {},
  behavior: HitTestBehavior.translucent,
  onPress: () {},
  onLongPress: () {},
  onSecondaryPress: () {},
  onSecondaryLongPress: () {},
  shortcuts: { SingleActivator(LogicalKeyboardKey.enter): ActivateIntent() },
  actions: { ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {}) },
  builder: (context, state, child) => child!,
  child: const Text('Tappable'),
);
```

**静态版本（无动画）：**
```dart
FTappable.static(
  style: FTappableStyle(),
  semanticsLabel: 'Label',
  excludeSemantics: false,
  selected: false,
  autofocus: false,
  focusNode: FocusNode(),
  onFocusChange: (focused) {},
  onHoverChange: (hovered) {},
  onStateChange: (delta) {},
  behavior: HitTestBehavior.translucent,
  onPress: () {},
  onLongPress: () {},
  onSecondaryPress: () {},
  onSecondaryLongPress: () {},
  shortcuts: { SingleActivator(LogicalKeyboardKey.enter): ActivateIntent() },
  actions: { ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {}) },
  builder: (context, state, child) => child!,
  child: const Text('Tappable'),
);
```

## 2. 布局组件 (Layout)

### 2.1 FDivider 分割线

FDivider 用于在内容之间创建视觉或语义上的分隔。

**基本用法：**
```dart
const FDivider(
  style: FDividerStyle(...),
  axis : Axis.vertical,
);
```

**完整示例：**
```dart
final theme = context.theme;
final colors = theme.colors;
final typography = theme.typography;

Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Flutter Forui',
        style: typography.xl2.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        'An open-source widget library.',
        style: typography.sm.copyWith(color: colors.mutedForeground),
      ),
      const FDivider(),
      SizedBox(
        height: 30,
        child: Row(
          children: [
            Text(
              'Blog',
              style: typography.sm.copyWith(color: colors.foreground),
            ),
            const FDivider(axis : Axis.vertical),
            Text(
              'Docs',
              style: typography.sm.copyWith(color: colors.foreground),
            ),
            const FDivider(axis : Axis.vertical),
            Text(
              'Source',
              style: typography.sm.copyWith(color: colors.foreground),
            ),
          ],
        ),
      ),
    ],
  ),
);
```

### 2.2 FResizable 可调整大小组件

FResizable 允许其子组件沿水平或垂直主轴调整大小。

**基本用法：**
```dart
FResizable(
  controller: FResizableController.cascade(
    onResizeUpdate: (regions) => print(regions),
    onResizeEnd: (regions) => print(regions),
  ),
  style: FResizableStyle(...),
  axis: Axis.vertical,
  divider: FResizableDivider.dividerWithThumb,
  crossAxisExtent: 400,
  onChange: (regions) => print('Regions changed: $regions'),
  children: [
    FResizableRegion(
      initialExtent: 200,
      minExtent: 100,
      builder: (context, data, child) => child!,
      child: const Placeholder(),
    ),
  ],
);
```

**完整示例：**
```dart
class TimeOfDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: context.theme.colors.border),
      borderRadius: BorderRadius.circular(8),
    ),
    child: FResizable(
      axis: Axis.vertical,
      crossAxisExtent: 300,
      children: [
        FResizableRegion(
          initialExtent: 250,
          minExtent: 100,
          builder: (_, data, __) => Label(data: data, icon: FIcons.sunrise, label: 'Morning'),
        ),
        FResizableRegion(
          initialExtent: 100,
          minExtent: 100,
          builder: (_, data, __) => Label(data: data, icon: FIcons.sun, label: 'Afternoon'),
        ),
        FResizableRegion(
          initialExtent: 250,
          minExtent: 100,
          builder: (_, data, __) => Label(data: data, icon: FIcons.sunset, label: 'Evening'),
        ),
      ],
    ),
  );
}

class Label extends StatelessWidget {
  static final DateFormat format = DateFormat.jm(); // Requires package:intl

  final FResizableRegionData data;
  final IconData icon;
  final String label;

  const Label({required this.data, required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    final FThemeData(:colors, :typography) = context.theme;
    final start = DateTime.fromMillisecondsSinceEpoch(
      (data.offsetPercentage.min * Duration.millisecondsPerDay).round(),
      isUtc: true,
    );

    final end = DateTime.fromMillisecondsSinceEpoch(
      (data.offsetPercentage.max * Duration.millisecondsPerDay).round(),
      isUtc: true,
    );

    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: colors.foreground),
              const SizedBox(width: 3),
              Text(label, style: typography.sm.copyWith(color: colors.foreground)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${format.format(start)} - ${format.format(end)}',
            style: typography.sm.copyWith(color: colors.foreground),
          ),
        ],
      ),
    );
  }
}
```

### 2.3 FScaffold 脚手架

FScaffold 为 Forui 组件创建视觉框架。

**基本用法：**
```dart
FScaffold(
  scaffoldStyle: FScaffoldStyle(...),
  toasterStyle: FToasterStyle(...),
  systemOverlayStyle: SystemUiOverlayStyle(...),
  header: FHeader(
    title: const Text('Settings'),
    suffixes: [
      FHeaderAction(
        icon: Icon(FIcons.ellipsis),
        onPress: () {},
      ),
    ],
  ),
  childPad: true,
  child: Column(
    children: [
      FCard(
        title: const Text('Notification'),
        subtitle: const Text('You have 3 unread messages.'),
        child: FButton(onPress: () {}, child: const Text('Read messages')),
      ),
    ],
  ),
  sidebar: FSidebar(children: const []),
  footer: FBottomNavigationBar(children: const []),
);
```

## 3. 表单组件 (Form)

### 3.1 FAutocomplete 自动完成

FAutocomplete 根据用户输入提供建议列表，并显示第一个匹配项的自动完成文本。

**基本用法：**
```dart
FAutocomplete(
  controller: FAutocompleteController(vsync: this),
  style: (style) => style,
  label: const Text('Country'),
  description: const Text('Select your country of residence'),
  hint: 'Type to search countries',
  onChange: (value) => print('Selected country: $value'),
  onSaved: (value) => print('Saved country: $value'),
  onReset: () => print('Reset'),
  autovalidateMode: AutovalidateMode.onUserInteraction,
  builder: (context, styles, child) => child!,
  prefixBuilder: (context, style, states) => Icon(FIcons.globe),
  suffixBuilder: (context, style, states) => Icon(FIcons.search),
  popoverConstraints: const FAutoWidthPortalConstraints(maxHeight: 400),
  clearable: (value) => value.text.isNotEmpty,
  rightArrowToComplete: true,
  initialText: 'Canada',
  items: [
    'United States',
    'Canada', 
    'Japan',
    'United Kingdom',
    'Germany',
    'France',
    'Australia',
  ],
);
```

**构建器版本：**
```dart
FAutocomplete.builder(
  filter: (text) async {
    const countries = ['United States', 'Canada', 'Japan'];
    return countries.where((country) => country.toLowerCase().contains(query.toLowerCase()));
  },
  contentBuilder: (context, text, suggestions) => [
    for (final suggestion in suggestions) FAutocompleteItem(value: suggestion)
  ],
  controller: FAutocompleteController(vsync: this),
  style: (style) => style,
  label: const Text('Country'),
  description: const Text('Select your country of residence'),
  hint: 'Type to search countries',
  onChange: (value) => print('Selected country: $value'),
  onSaved: (value) => print('Saved country: $value'),
  onReset: () => print('Reset'),
  autovalidateMode: AutovalidateMode.onUserInteraction,
  builder: (context, styles, child) => child!,
  prefixBuilder: (context, style, states) => Icon(FIcons.globe),
  suffixBuilder: (context, style, states) => Icon(FIcons.search),
  popoverConstraints: const FAutoWidthPortalConstraints(maxHeight: 300),
  rightArrowToComplete: true,
  clearable: (value) => value.text.isNotEmpty,
);
```

### 3.2 FButton 按钮

FButton 是一个通用按钮组件。

**基本用法：**
```dart
FButton(
  style: FButtonStyle(...),
  mainAxisSize: MainAxisSize.min,
  onPress: () {},
  onSecondaryPress: () {},
  onSecondaryLongPress: () {},
  shortcuts: { SingleActivator(LogicalKeyboardKey.enter): ActivateIntent() },
  actions: { ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {}) },
  child: const Text('Button'),
);
```

**原始版本：**
```dart
FButton.raw(
  style: FButtonStyle(...),
  onPress: () {},
  onSecondaryPress: () {},
  onSecondaryLongPress: () {},
  shortcuts: { SingleActivator(LogicalKeyboardKey.enter): ActivateIntent() },
  actions: { ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {}) },
  child: const Text('Button'),
);
```

### 3.3 FCheckbox 复选框

FCheckbox 允许用户在选中和未选中之间切换。

**基本用法：**
```dart
class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => PageState();
}

class PageState extends State<Page> {
  bool state = false;

  @override
  Widget build(BuildContext context) => FCheckbox(
    label: const Text('Accept terms and conditions'),
    description: const Text('You agree to our terms and conditions.'),
    semanticsLabel: 'Accept terms and conditions',
    value: state,
    onChange: (value) => setState(() => state = value),
  );
}
```

### 3.4 FDateField 日期字段

FDateField 允许从日历或输入字段中选择日期。

**基本用法：**
```dart
FDateField(
  controller: FDateFieldController(
    vsync: this,
    initialDate: DateTime(2024, 1, 1),
    validator: (date) => date?.isBefore(DateTime.now()) ?? false ? 'Date must be in the future' : null,
  ),
  style: FDateFieldStyle(...),
  initialDate: DateTime(2024, 1, 1),
  textAlign: TextAlign.start,
  textAlignVertical: TextAlignVertical.center,
  autofocus: false,
  expands: false,
  onEditingComplete: () => print('Editing complete'),
  onSubmit: (date) => print('Date submitted: $date'),
  mouseCursor: SystemMouseCursors.text,
  canRequestFocus: true,
  baselineInputYear: 2000,
  builder: (context, style, states, child) => child!,
  prefixBuilder: (context, style, states) => Icon(Icons.calendar_today),
  suffixBuilder: (context, style, states) => Icon(Icons.calendar_today),
  clearable: true,
  calendar: FDateFieldCalendarProperties(),
  label: Text('Select Date'),
  description: Text('Choose a date from the calendar or input field'),
  enabled: true,
  onChange: (date) => print('Date changed: $date'),
  onSaved: (date) => print('Date saved: $date'),
  onReset: () => print('Reset'),
  autovalidateMode: AutovalidateMode.onUnfocus,
  forceErrorText: null,
  errorBuilder: (context, error) => Text(error, style: TextStyle(color: Colors.red)),
);
```

**日历版本：**
```dart
FDateField.calendar(
  controller: FDateFieldController(
    vsync: this,
    initialDate: DateTime(2024, 1, 1),
  ),
  style: FDateFieldStyle(...),
  initialDate: DateTime(2024, 1, 1),
  format: DateFormat('d MMM y'),
  textAlign: TextAlign.start,
  textAlignVertical: TextAlignVertical.center,
  expands: false,
  mouseCursor: SystemMouseCursors.text,
  canRequestFocus: true,
  clearable: true,
  onChange: (date) => print('Date changed: $date'),
  hint: 'Select a date',
  start: DateTime(2024),
  end: DateTime(2025),
  today: DateTime.now(),
  initialType: FCalendarPickerType.yearMonth,
  autoHide: true,
  anchor: Alignment.topLeft,
  inputAnchor: Alignment.bottomLeft,
  spacing: FPortalSpacing(4),
  shift: FPortalShift.flip,
  offset: Offset.zero,
  hideRegion: FPopoverHideRegion.none,
  label: Text('Calendar Date'),
  description: Text('Select a date from the calendar'),
  builder: (context, style, states, child) => child!,
  prefixBuilder: (context, style, states) => Icon(Icons.calendar_today),
  suffixBuilder: (context, style, states) => Icon(Icons.calendar_today),
  forceErrorText: null,
  errorBuilder: (context, error) => Text(error, style: TextStyle(color: Colors.red)),
);
```

### 3.5 FLabel 标签

FLabel 用标签、描述和错误消息（如果有）描述表单字段。

**基本用法：**
```dart
FLabel(
  style: FLabelStyle(...),
  axis: Axis.horizontal,
  label: const Text('Accept terms and conditions'),
  description: const Text('You agree to our terms and conditions.'),
  error: const Text('Please accept the terms and conditions.'),
  states: { WidgetState.error },
  child: const Placeholder(),
);
```

### 3.6 FMultiSelect 多选

FMultiSelect 显示一个下拉选项列表供用户选择。

**基本用法：**
```dart
FMultiSelect<Locale>(
  items: {
    'United States': Locale('en', 'US'),
    'Canada': Locale('en', 'CA'),
    'Japan': Locale('ja', 'JP'),
  },
  controller: FMultiSelectController<Locale>(vsync: this, min: 1, max: 2),
  style: FMultiSelectStyle.inherit(...),
  label: const Text('Country'),
  description: const Text('Select your country of residence'),
  hint: Text('Choose a country'),
  keepHint: true,
  format: (value) => Text(value.toUpperCase()),
  sort: (a, b) => a.compareTo(b),
  onChange: (value) => print('Selected country: $value'),
  onSaved: (value) => print('Saved country: $value'),
  onReset: () => print('Reset'),
  autovalidateMode: AutovalidateMode.onUserInteraction,
  prefixBuilder: (context, styles) => Icon(FIcons.globe),
  suffixBuilder: (context, styles) => Icon(FIcons.arrowDown),
  tagBuilder: (context, controller, styles, value, label) => FMultiSelectTag(label: label),
  popoverConstraints: const FAutoWidthPortalConstraints(maxHeight: 400),
  clearable: true,
  contentScrollHandles: true,
  min: 1,
  max: 2,
  initialValue: {Locale('en', 'US')},
);
```

### 3.7 FPicker 选择器

FPicker 是一个通用选择器，允许选择项目。由一个或多个轮子组成，轮子之间可选地有分隔符。

**基本用法：**
```dart
const FPicker(
  controller: FPickerController(initialIndexes: []),
  style: FPickerStyle(...),
  onChange: (indexes) {},
  children: [
    FPickerWheel(
      flex: 2,
      loop: true,
      itemExtent: 20,
      autofocus: true,
      focusNode: FocusNode(),
      onFocusChange: (focused) {},
      children: [
        Text('1'),
        Text('2'),
      ],
    ),
    FPickerWheel.builder(
      flex: 2,
      itemExtent: 20,
      autofocus: true,
      focusNode: FocusNode(),
      onFocusChange: (focused) {},
      builder: (context, index) => Text('$index'),
    ),
  ],
);
```

### 3.8 FRadio 单选按钮

FRadio 允许用户从预定义选项集中选择一个选项。

**基本用法：**
```dart
FRadio(
  style: FRadioStyle(...),
  label: const Text('Default'),
  description: const Text('The description of the default option.'),
  error: const Text('Please select the default option.'),
  semanticsLabel: 'Default',
  value: true,
  onChange: (value) {},
  enabled: true,
  autofocus: true,
);
```

### 3.9 FSelect 选择

FSelect 显示一个下拉选项列表供用户选择。

**基本用法：**
```dart
FSelect<Locale>(
  items: {
    'United States': Locale('en', 'US'),
    'Canada': Locale('en', 'CA'),
    'Japan': Locale('ja', 'JP'),
  },
  controller: FSelectController<Locale>(vsync: this),
  style: FSelectStyle.inherit(...),
  label: const Text('Country'),
  description: const Text('Select your country of residence'),
  hint: 'Choose a country',
  format: (value) => value.toUpperCase(),
  onChange: (value) => print('Selected country: $value'),
  onSaved: (value) => print('Saved country: $value'),
  onReset: () => print('Reset'),
  autovalidateMode: AutovalidateMode.onUserInteraction,
  builder: (context, style, state, child) => child,
  prefixBuilder: (context, style, states) => Icon(FIcons.globe),
  suffixBuilder: (context, style, states) => Icon(FIcons.arrowDown),
  popoverConstraints: const FAutoWidthPortalConstraints(maxHeight: 400),
  clearable: true,
  contentScrollHandles: true,
);
```

### 3.10 FSelectGroup 选择组

FSelectGroup 是一组允许用户从选项集中进行选择的项目。

**基本用法：**
```dart
FSelectGroup<Value>(
  controller: FSelectGroupController(), // or FSelectGroupController.radio()
  style: FSelectGroupStyle(...),
  label: const Text('Sidebar'),
  description: const Text('Select the items you want to display in the sidebar.'),
  onChange: (all) => print(all),
  onSelect: (selection) => print(selection),
  children: [
    FCheckbox.grouped(
      value: Value.checkbox,
      label: const Text('Checkbox'),
    ),
    // or
    FRadio.grouped(
      value: Value.radio,
      label: const Text('Radio'),
    ),
  ],
);
```

### 3.11 FSlider 滑块

FSlider 是一个滑动输入组件，允许用户通过拖动滑块或点击轨道在指定范围内选择值。

**基本用法：**
```dart
FSlider(
  style: FSliderStyle(...),
  layout: FLayout.rtl,
  tooltipBuilder: (style, value) => Text('${value.toStringAsFixed(2)}%'),
  controller: FContinuousSliderController(
    allowedInteraction: FSliderInteraction.tap,
    selection: FSliderSelection(max: 0.75, extent: (min: 0, max: 0.8)),
  ),
  onChange: (selection) {},
  marks: const [
    FSliderMark(value: 0, label: Text('0%')),
    FSliderMark(value: 0.5, label: Text('50%')),
    FSliderMark(value: 1, label: Text('100%')),
  ],
);
```

### 3.12 FSwitch 开关

FSwitch 是一个切换开关组件，允许用户通过滑动动作启用或禁用设置。

**基本用法：**
```dart
FSwitch(
  style: FSwitchStyle(...),
  label: const Text('Airplane Mode'),
  description: const Text('Turn on airplane mode to disable all wireless connections.'),
  error: const Text('Please turn on airplane mode.'),
  semanticsLabel: 'Airplane Mode',
  value: true,
  onChange: (value) {},
  enabled: true,
  autofocus: true,
);
```

### 3.13 FTextField 文本字段

FTextField 允许用户通过硬件键盘或屏幕键盘输入文本。

**基本用法：**
```dart
FTextField(
  controller: _controller, // TextEditingController
  style: FTextFieldStyle(...),
  clearable: (value) => value.text.isNotEmpty,
  enabled: true,
  label: const Text('Email'),
  hint: 'john@doe.com',
  description: const Text('Enter your email associated with your Forui account.'),
  error: const Text('Error'),
  keyboardType: TextInputType.emailAddress,
  textCapitalization: TextCapitalization.none,
  maxLines: 1,
);
```

### 3.14 FTextFormField 表单文本字段

FTextFormField 是可以在表单中使用的文本字段。

**基本用法：**
```dart
FTextFormField(
  controller: _controller, // TextEditingController
  style: FTextFieldStyle(...),
  clearable: (value) => value.text.isNotEmpty,
  enabled: true,
  onSaved: (value) {},
  onReset: () => print('Reset'),
  validator: (value) => true,
  label: const Text('Email'),
  hint: 'john@doe.com',
  description: const Text('Enter your email associated with your Forui account.'),
  forceErrorText: 'Error'
  errorBuilder: (context, error) => const Text(error),
  keyboardType: TextInputType.emailAddress,
  textCapitalization: TextCapitalization.none,
  maxLines: 1,
);
```

### 3.15 FTimeField 时间字段

FTimeField 允许从选择器或输入字段中选择时间。

**基本用法：**
```dart
FTimeField(
  controller: FTimeFieldController(
    vsync: this,
    initialTime: FTime(12, 30),
    validator: (time) => time != null && time < const FTime(14, 30) ? 'Time must be in the future' : null,
  ),
  style: FTimeFieldStyle(...),
  initialTime: FTime(12, 30),
  textAlign: TextAlign.start,
  textAlignVertical: TextAlignVertical.center,
  autofocus: false,
  expands: false,
  onEditingComplete: () => print('Editing complete'),
  onSubmit: (time) => print('Time submitted: $time'),
  mouseCursor: SystemMouseCursors.text,
  canRequestFocus: true,
  builder: (context, styles, child) => child!,
  prefixBuilder: (context, styles, child) => Icon(FIcons.clock2),
  suffixBuilder: null,
  label: Text('Select Time'),
  description: Text('Choose a time'),
  enabled: true,
  onChange: (time) => print('Time changed: $time'),
  onSaved: (time) => print('Time saved: $time'),
  onReset: () => print('Reset'),
  autovalidateMode: AutovalidateMode.onUnfocus,
);
```

### 3.16 FTimePicker 时间选择器

FTimePicker 是一个允许选择时间的选择器。

**基本用法：**
```dart
const FTimePicker(
  controller: FTimePickerController(),
  style: FTimePickerStyle(...),
  onChange: (time) {},
  hour24: true,
  hourInterval: 1,
  minuteInterval: 1,
);
```

## 4. 覆盖层组件 (Overlay)

### 4.1 FDialog 对话框

FDialog 是一个模态对话框，用重要内容打断用户并期望响应。

**基本用法：**
```dart
showFDialog<T>(
  context: context,
  builder: (context, style, animation) => FDialog(...),
  useRootNavigator: false,
  routeStyle: FDialogRouteStyle(...),
  style: FDialogStyle(...),
  barrierLabel: 'Label',
  barrierDismissible: true,
  routeSettings: RouteSettings(...),
  transitionAnimationController: AnimationController(...),
  anchorPoint: Offset.zero,
  useSafeArea: false,
);
```

**对话框组件：**
```dart
FDialog(
  style: FDialogStyle(...),
  animation: Animation<double>(...),
  direction: Axis.horizontal,
  title: const Text('Are you absolutely sure?'),
  body: const Text('This action cannot be undone. This will permanently delete your account and remove your data from our servers.'),
  actions: [
    FButton(style: FButtonStyle.outline(), onPress: () => Navigator.of(context).pop(), child: const Text('Cancel')),
    FButton(onPress: () => Navigator.of(context).pop(), child: const Text('Continue')),
  ],
);
```

### 4.2 FSheet 表格

FDialog 是一个模态表格，是菜单或对话框的替代品，防止用户与应用程序的其余部分交互。

**基本用法：**
```dart
showFSheet(
  context: context,
  style: FModalSheetStyle(...),
  side: FLayout.ltr,
  useRootNavigator: true,
  useSafeArea: false,
  mainAxisMaxRatio: null,
  constraints: const BoxConstraints(maxWidth: 450, maxHeight: 450),
  barrierDismissible: true,
  draggable: true,
  builder: (context) => const Placeholder(),
  onClosing: () {},
);
```

### 4.3 FPopover 弹出框

FPopover 在门户中显示丰富内容，与子组件对齐。

**基本用法：**
```dart
FPopover(
  controller: FPopoverController(vsync: this),
  style: FPopoverStyle(...),
  popoverAnchor: Alignment.topCenter,
  childAnchor: Alignment.bottomCenter,
  constraints: const FPortalConstraints(),
  spacing: const FPortalSpacing(4),
  shift: FPortalShift.flip,
  offset: Offset.zero,
  groupId: 'popover-group',
  hideRegion: FPopoverHideRegion.excludeChild,
  onTapHide: () {},
  popoverBuilder: (context, controller) => const Placeholder(),
  builder: (context, controller, child) => const Placeholder(),
  child: const Placeholder(),
);
```

### 4.4 FPopoverMenu 弹出菜单

FPopoverMenu 在与子组件对齐的门户中显示菜单。

**基本用法：**
```dart
FPopoverMenu(
  popoverController: FPopoverController(vsync: this),
  scrollController: ScrollController(),
  style: FPopoverMenuStyle(...),
  cacheExtent: 100,
  maxHeight: 200,
  dragStartBehavior: DragStartBehavior.start,
  menuAnchor: Alignment.topCenter,
  childAnchor: Alignment.bottomCenter,
  spacing: FPortalSpacing.zero,
  shift: FPortalShift.flip,
  offset: Offset.zero,
  groupId: 'popover-menu-group',
  hideRegion: FPopoverHideRegion.excludeChild,
  onTapHide: () {},
  traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  menuBuilder: (context, controller, menu) => [FItemGroup(children: [])],
  menu: [
    FItemGroup(
      children: [],
    ),
  ],
  builder: (context, controller, child) => const Placeholder(),
  child: const Placeholder(),
);
```

### 4.5 FToast 吐司

FToast 显示临时简洁消息。

**基本用法：**
```dart
showRawFToast(
  context: context,
  style: FToastStyle(...),
  alignment: FToastAlignment.topRight,
  swipeToDismiss: [AxisDirection.left, AxisDirection.down],
  duration: const Duration(seconds: 10),
  onDismiss: () {},
  icon: const Icon(FIcons.triangleAlert),
  title: const Text('Download Complete'),
  description: const Text('Your file has been downloaded.'),
  suffix: FButton(
    onPress: () => entry.dismiss(),
    child: const Text('Undo'),
  ),
  showDismissButton: true,
  onDismiss: () {},
);
```

## 5. 数据展示组件 (Data Presentation)

### 5.1 FAccordion 手风琴

FAccordion 是一组垂直堆叠的交互式标题，点击时显示相关的内容部分。

**基本用法：**
```dart
FAccordion(
  controller: FAccordionController(min: 1, max: 2),
  style: FAccordionStyle(...),
  children: [
    FAccordionItem(
      title: const Text('Is it accessible?'),
      child: const Text('Yes. It follows WAI-ARIA design patterns.'),
    ),
  ],
);
```

### 5.2 FAvatar 头像

FAvatar 是一个圆形图像组件，显示用户头像图片，图片不可用时提供备用选项。

**基本用法：**
```dart
FAvatar(
  style: FAvatarStyle(...),
  image: const NetworkImage('https://example.com/profile.jpg'),
  fallback: const Text('JD'),
);
```

### 5.3 FBadge 徽章

FBadge 用于吸引对特定信息的注意，如标签和计数。

**基本用法：**
```dart
FBadge(
  style: FBadgeStyle.primary(),
  child: const Text('Badge'),
);
```

### 5.4 FCalendar 日历

FCalendar 是一个用于选择和编辑日期的组件。

**基本用法：**
```dart
FCalendar(
  controller: FCalendarController.date(
    initialSelection: DateTime(2024, 9, 13),
    selectable: (date) => allowedDates.contains(date),
  ),
  style: FCalendarStyle(...),
  dayBuilder: (context, data, child) => child!,
  start: DateTime(2024),
  end: DateTime(2030),
  today: DateTime(2024, 7, 14),
  initialType: FCalendarPickerType.yearMonth,
  initialMonth: DateTime(2024, 9),
  onMonthChange: (date) => print(date),
  onPress: (date) => print(date),
  onLongPress: (date) => print(date),
);
```

### 5.5 FCard 卡片

FCard 是一个灵活的容器组件，显示带有可选标题、副标题和子组件的内容。

**基本用法：**
```dart
FCard(
  style: FCardStyle(...),
  title: const Text('Notification'),
  subtitle: const Text('You have 3 unread messages.'),
  child: FButton(child: const Text('Read messages'), onPress: () {}),
);
```

### 5.6 FItem 项目

FItem 通常用于将相关信息组合在一起。

**基本用法：**
```dart
FItem(
  prefix: Icon(FIcons.user),
  title: const Text('Personalization'),
  suffix: Icon(FIcons.chevronRight),
  onPress: () {},
);
```

### 5.7 FItemGroup 项目组

FItemGroup 通常用于将相关信息组合在一起。

**基本用法：**
```dart
FItemGroup(
  scrollController: ScrollController(),
  style: FItemGroupStyle(...),
  cacheExtent: 100,
  maxHeight: 200,
  dragStartBehavior: DragStartBehavior.start,
  physics: const ClampingScrollPhysics(),
  semanticsLabel: 'Settings',
  divider: FItemDivider.indented,
  children: [
    FItem(title: const Text('Item'),
  ],
);
```

### 5.8 FLineCalendar 线性日历

FLineCalendar 是一个紧凑的日历组件，在可水平滚动的线上显示日期。

**基本用法：**
```dart
FLineCalendar(
  controller: FCalendarController.date(),
  style: FLineCalendarStyle(...),
  initialScrollAlignment: AlignmentDirectional.center,
  physics: const AlwaysScrollableScrollPhysics(),
  cacheExtent: 100,
  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
  builder: (context, data, child) => child!,
  onChange: (date) => print('Selected date: $date'),
  toggleable: true,
  start: DateTime(1900),
  end: DateTime(2050),
  initialScroll: DateTime.now(),
  initialSelection: DateTime.now(),
  today: DateTime.now(),
);
```

## 6. 反馈组件 (Feedback)

### 6.1 FAlert 警报

FAlert 显示用于用户注意的提示。

**基本用法：**
```dart
FAlert(
  style: FAlertStyle(...),
  icon: Icon(FIcons.badgeAlert),
  title: const Text('Heads Up!'),
  subtitle: const Text('You can add components to your app using the cli.'),
);
```

### 6.2 FCircularProgress 圆形进度条

FCircularProgress 显示不确定的圆形指示器，显示任务的完成进度。

**基本用法：**
```dart
FCircularProgress(
  style: FCircularProgressStyle(...),
  semanticsLabel: 'Label',
  icon: FIcons.loaderCircle,
);
```

### 6.3 FDeterminateProgress 确定进度条

FDeterminateProgress 显示确定的线性指示器，显示任务的完成进度。

**基本用法：**
```dart
FDeterminateProgress(
  style: FDeterminateProgressStyle(...),
  semanticsLabel: 'Label',
  value: 0.7,
);
```

### 6.4 FProgress 进度条

FProgress 显示不确定的线性指示器，显示任务的完成进度。

**基本用法：**
```dart
FProgress(
  style: FProgressStyle(...),
  semanticsLabel: 'Label',
);
```

## 7. 瓦片组件 (Tile)

### 7.1 FTile 瓦片

FTile 是一个专门用于触摸设备的 [Item](/docs/data/item)，通常用于将相关信息组合在一起。

**基本用法：**
```dart
FTile(
  style: FTileStyle(...),
  prefix: Icon(FIcons.user),
  title: const Text('Title'),
  subtitle: const Text('Subtitle'),
  details: const Text('Details'),
  suffix: Icon(FIcons.chevronRight),
  semanticsLabel: 'Label',
  enabled: true,
  selected: false,
  onFocusChange: (focused) {},
  onHoverChange: (hovered) {},
  onStateChange: (delta) {},
  onPress: () {},
  onLongPress: () {},
  onSecondaryPress: () {},
  onSecondaryLongPress: () {},
  shortcuts: { SingleActivator(LogicalKeyboardKey.enter): ActivateIntent() },
  actions: { ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {}) },
);
```

### 7.2 FTileGroup 瓦片组

FTileGroup 通常用于将相关信息组合在一起。

**基本用法：**
```dart
FTileGroup(
  scrollController: ScrollController(),
  style: FTileGroupStyle(...),
  cacheExtent: 100,
  maxHeight: 200,
  dragStartBehavior: DragStartBehavior.start,
  physics: const ClampingScrollPhysics(),
  label: const Text('Settings'),
  description: const Text('Personalize your experience'),
  semanticsLabel: 'Settings',
  divider: FItemDivider.indented,
  children: [],
);
```

### 7.3 FSelectTileGroup 选择瓦片组

FSelectTileGroup 是一组允许用户从选项集中进行选择的瓦片。

**基本用法：**
```dart
FSelectTileGroup<Value>(
  selectController: FSelectTileGroupController(), // or FSelectTileGroupController.radio()
  scrollController: ScrollController(),
  style: FSelectMenuTileStyle(...),
  cacheExtent: 100,
  maxHeight: 200,
  dragStartBehavior: DragStartBehavior.start,
  physics: const ClampingScrollPhysics(),
  label: const Text('Sidebar'),
  description: const Text('Select the items you want to display in the sidebar.'),
  divider: FItemDivider.indented,
  onChange: (all) => print(all),
  onSelect: (selection) => print(selection),
  children: [
    FSelectTile(
      title: const Text('1'),
      value: Value.something,
    ),
  ],
);
```

### 7.4 FSelectMenuTile 选择菜单瓦片

FSelectMenuTile 是一个触发时显示选项列表供用户选择的瓦片。

**基本用法：**
```dart
FSelectMenuTile<Value>(
  selectController: FSelectMenuTileController(), // or FSelectMenuTileController.radio()
  style: FSelectMenuTileStyle(...),
  menuAnchor: Alignment.topRight,
  tileAnchor: Alignment.bottomRight,
  spacing: const FPortalSpacing(4),
  shift: FPortalShift.flip,
  offset: Offset.zero,
  hideRegion: FPopoverHideRegion.anywhere,
  autoHide: false,
  scrollController: ScrollController(),
  cacheExtent: 100,
  maxHeight: 200,
  dragStartBehavior: DragStartBehavior.start,
  physics: const ClampingScrollPhysics(),
  divider: FItemDivider.indented,
  label: const Text('Sidebar'),
  description: const Text('Select the items you want to display in the sidebar.'),
  errorBuilder: (context, error) => Text(error),
  prefix: Icon(FIcons.bell),
  title: Text('Notifications'),
  subtitle: Text('subtitle'),
  detailsBuilder: (context, values, child) => Placeholder()m
  details: Text('All'),
  suffix: Icon(FIcons.chevronsUpDown),
  onChange: (all) => print(all),
  onSelect: (selection) => print(selection),
  shortcuts: { SingleActivator(LogicalKeyboardKey.enter): ActivateIntent() },
  actions: { ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {}) },
  initialValue: Value.something,
  menu: [
    FSelectTile(
      title: const Text('1'),
      value: Value.something,
    ),
  ],
);
```

## 8. 导航组件 (Navigation)

### 8.1 FBottomNavigationBar 底部导航栏

FBottomNavigationBar 通常出现在根页面的底部，用于在少量视图之间导航。

**基本用法：**
```dart
FBottomNavigationBar(
  style: FBottomNavigationBarStyle(...),
  index: 0,
  onChange: (index) => {},
  children: [
    FBottomNavigationBarItem(
      icon: Icon(FIcons.house),
      label: const Text('Home'),
      autofocus: false,
      focusNode: FocusNode(),
      onFocusChange: (focused) {},
      onHoverChange: (hovered) {},
      onStateChange: (delta) {},
    ),
  ],
);
```

### 8.2 FBreadcrumb 面包屑

FBreadcrumb 显示链接列表，帮助可视化页面在站点层次结构中的位置。

**基本用法：**
```dart
FBreadcrumb(
  style: FBreadcrumbStyle(...),
  children: [
    FBreadcrumbItem(onPress: () {}, child: const Text('Forui')),
    FBreadcrumbItem.collapsed(
      menu: [
        FTileGroup(
          children: [
            FTile(
              title: const Text('Documentation'),
              onPress: () {},
            ),
            FTile(
              title: const Text('Themes'),
              onPress: () {},
            ),
          ],
        ),
      ],
      spacing: const FPortalSpacing(4),
      offset: Offset.zero,
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
    ),
    FBreadcrumbItem(onPress: () {}, child: const Text('Themes')),
    FBreadcrumbItem(current: true, child: const Text('Widgets')),
  ],
);
```

### 8.3 FHeader 头部

FHeader 包含页面标题和导航操作，通常用于导航堆栈根部的页面。

**基本用法：**
```dart
FHeader(
  style: FHeaderStyle(...),
  title: const Text('Title'),
  suffixes: [
    FHeaderAction(
      style: FHeaderActionStyle(...),
      icon: Icon(FIcons.alarmClock),
      onPress: () {},
      onHoverChange: (hovered) {},
      onStateChange: (delta) {},
    ),
    FHeaderAction(
      icon: Icon(FIcons.plus),
      onPress: () {},
    ),
  ],
);
```

### 8.4 FPagination 分页

FPagination 显示当前活动页面并启用多页面之间的导航。

**基本用法：**
```dart
FPagination(
  controller: FPaginationController(
    pages: 20,
    initialPage: 4,
    showEdges: false,
    siblings: 2,
  ),
  style: FPaginationStyle(...),
  initialPage: 1,
  pages: 20,
  onChange: () {},
);
```

### 8.5 FSidebar 侧边栏

FSidebar 是一个侧边栏小部件，为屏幕侧面的导航提供固定布局。

**基本用法：**
```dart
FSidebar(
  style: FSidebarStyle(...),
  width: 250,
  header: const Text('Header'),
  footer: const Text('Footer'),
  children: [FSidebarGroup(...)],
);
```

### 8.6 FTabs 标签页

FTabs 是一组分层的内容部分（称为标签条目），一次显示一个。

**基本用法：**
```dart
FTabs(
  style: FTabsStyle(...),
  initialIndex: 1,
  onPress: (index) {},
  children: const [
    FTabEntry(label: Text('Account'), child: Placeholder()),
    FTabEntry(label: Text('Password'), child: Placeholder()),
  ],
);
```