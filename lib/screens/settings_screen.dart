import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:school_life/screens/student_verification_screen.dart';
import 'package:school_life/services/auth_service.dart';
import '../models/user.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUserValue;
    
    return FScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '设置',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // 用户信息卡片
              FCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text(user?.name?.substring(0, 1) ?? 'U'),
                      ),
                      title: Text(user?.name ?? '未知用户'),
                      subtitle: Text(
                        user?.isStudent == true 
                            ? '已认证学生（可发布信息）' 
                            : '普通用户（仅可浏览）'
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 设置选项
              FCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('个人信息'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: 导航到个人信息页面
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('通知设置'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: 导航到通知设置页面
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: const Text('主题设置'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: 导航到主题设置页面
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(user?.isStudent == true 
                          ? Icons.check_circle 
                          : Icons.school),
                      title: Text(user?.isStudent == true 
                          ? '学生认证已完成' 
                          : '学生身份认证'),
                      trailing: user?.isStudent == true 
                          ? null 
                          : const Icon(Icons.arrow_forward_ios),
                      onTap: user?.isStudent == true 
                          ? null 
                          : () {
                              // 导航到学生认证页面
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => 
                                      const StudentVerificationScreen(),
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // 登出按钮
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: context.theme.colors.destructive,
                ),
                title: const Text('退出登录'),
                onTap: () {
                  showFDialog(
                    context: context,
                    builder: (context, style, animation) => FDialog(
                      style: style,
                      animation: animation,
                      direction: Axis.horizontal,
                      title: const Text('确认退出'),
                      body: const Text('确定要退出登录吗？'),
                      actions: [
                        FButton(
                          style: FButtonStyle.outline(), 
                          onPress: () => Navigator.of(context).pop(), 
                          child: const Text('取消')
                        ),
                        FButton(
                          onPress: () async {
                            // 执行退出登录操作
                            final authService = AuthService();
                            await authService.logout();
                            
                            // 关闭对话框
                            Navigator.pop(context);
                            
                            // 导航到登录页面并清除导航栈
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/auth', 
                                (route) => false,
                              );
                            }
                          }, 
                          child: const Text('确认')
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}