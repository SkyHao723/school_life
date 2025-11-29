import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:school_life/screens/auth_screen.dart';
import 'package:school_life/screens/main_screen.dart';
import 'package:school_life/services/auth_service.dart';
import 'package:school_life/services/storage_service.dart';

Future<void> main() async {
  // 确保WidgetsBinding初始化完成
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化认证服务
  final authService = AuthService();
  await authService.init();
  
  // 检查用户认证状态
  try {
    await authService.checkAuthStatus();
  } catch (e) {
    // 如果检查认证状态失败，忽略错误继续启动应用
    print('检查认证状态失败: $e');
  }
  
  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  
  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light, // 使用ForUI的预设主题
      child: MaterialApp(
        title: '校园生活',
        debugShowCheckedModeBanner: false,
        home: authService.isAuthenticatedValue 
            ? const MainScreen() 
            : const AuthScreen(), // 根据认证状态决定显示哪个屏幕
        routes: {
          '/main': (context) => const MainScreen(),
          '/auth': (context) => const AuthScreen(),
        },
        onGenerateRoute: (settings) {
          // 处理未定义的路由
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => 
                  authService.isAuthenticatedValue ? const MainScreen() : const AuthScreen());
            case '/main':
              return MaterialPageRoute(builder: (_) => const MainScreen());
            case '/auth':
              return MaterialPageRoute(builder: (_) => const AuthScreen());
            default:
              return MaterialPageRoute(builder: (_) => const AuthScreen());
          }
        },
      ),
    );
  }
}

/// 认证包装器
/// 根据用户认证状态决定显示登录页面还是主页面
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    // 根据认证状态决定显示哪个页面
    if (authService.isAuthenticatedValue) {
      return const MainScreen();
    } else {
      return const AuthScreen();
    }
  }
}