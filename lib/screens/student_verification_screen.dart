import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:school_life/services/auth_service.dart';

class StudentVerificationScreen extends StatefulWidget {
  const StudentVerificationScreen({super.key});

  @override
  State<StudentVerificationScreen> createState() =>
      _StudentVerificationScreenState();
}

class _StudentVerificationScreenState extends State<StudentVerificationScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _requestVerification() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 调用认证服务申请学生认证
      final response = await _authService.requestStudentVerification();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        final success = response['success'] as bool?;
        if (success == true) {
          // 显示成功提示
          showFToast(
            context: context,
            icon: const Icon(FIcons.check),
            title: const Text('学生认证申请已提交'),
            alignment: FToastAlignment.topCenter,
            duration: const Duration(seconds: 3),
          );
        } else {
          // 显示失败提示
          showFToast(
            context: context,
            icon: const Icon(FIcons.circleX),
            title: Text(response['message'] as String? ?? '学生认证申请失败'),
            alignment: FToastAlignment.topCenter,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // 显示错误提示
        showFToast(
          context: context,
          icon: const Icon(FIcons.circleX),
          title: const Text('学生认证请求过程中发生错误'),
          alignment: FToastAlignment.topCenter,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            FHeader.nested(
              title: const Text('学生身份认证'),
              prefixes: [
                FHeaderAction.back(
                  onPress: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            
            // 在header下方添加分割线
            const FDivider(),
            
            // 主要内容区域
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '申请成为认证学生',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const Text(
                      '认证说明：\n\n'
                      '1. 认证后可发布信息\n'
                      '2. 需要提供有效的学生证明\n'
                      '3. 认证审核需要1-3个工作日\n\n'
                      '注意：此功能为演示功能，实际应用中需要上传学生证件照片进行审核。',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    FButton(
                      onPress: _isLoading ? null : _requestVerification,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('申请认证'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}