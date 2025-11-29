import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

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
                    '校园市场',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: List.generate(6, (index) {
                        return FCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FIcons.shoppingCart,
                                size: 40,
                                color: context.theme.colors.primary,
                              ),
                              const SizedBox(height: 8),
                              Text('商品 ${index + 1}'),
                              Text('¥${(index + 1) * 10}'),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            // 添加悬浮按钮
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: 实现市场页面的悬浮按钮功能
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('市场页面：点击了悬浮按钮'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}