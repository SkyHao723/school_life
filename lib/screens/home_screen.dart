import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '欢迎使用校园生活',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '这是一个用户ui展示',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildFeatureCard(
                          context,
                          icon: FIcons.calendar,
                          title: '课程表',
                          onTap: () {
                            // TODO: 导航到课程表页面
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          icon: FIcons.bookOpen,
                          title: '成绩查询',
                          onTap: () {
                            // TODO: 导航到成绩页面
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          icon: FIcons.users,
                          title: '同学圈',
                          onTap: () {
                            // TODO: 导航到同学圈页面
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          icon: FIcons.settings,
                          title: '设置',
                          onTap: () {
                            // TODO: 导航到设置页面
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  static Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: FCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: context.theme.colors.primary),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}