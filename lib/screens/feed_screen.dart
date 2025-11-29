import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:school_life/screens/post_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // 使用ForUI的FHeader组件
            FHeader(
              title: const Text('信息流'),
              suffixes: [
                FHeaderAction(
                  icon: Icon(FIcons.plus),
                  onPress: () {
                    // 点击加号按钮跳转到发帖界面
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PostScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            
            // 在header下方添加分割线
            const FDivider(),
            
            // 主要内容区域（暂时留空）
            Expanded(
              child: Container(
                // 这里是主要内容区域，目前留空
                // 未来可以添加ListView、GridView等内容展示组件
              ),
            ),
            
            // 底部区域（底部导航栏在MainScreen中，这里可以添加其他底部元素）
            // 目前为空，可以根据需要添加内容
          ],
        ),
      ),
    );
  }
}