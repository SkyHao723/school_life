import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class StudentVerificationScreen extends StatefulWidget {
  @override
  _StudentVerificationScreenState createState() =>
      _StudentVerificationScreenState();
}

class _StudentVerificationScreenState extends State<StudentVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _studentIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String? _validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入学号';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入姓名';
    }
    return null;
  }

  Future<void> _submitVerification() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authService = AuthService();
        final response = await authService.verifyStudent(
          studentId: _studentIdController.text.trim(),
          name: _nameController.text.trim(),
        );

        if (response['success'] == true) {
          // 更新本地用户信息
          final user = await UserService.getCurrentUser();
          if (user != null) {
            final updatedUser = User(
              id: user.id,
              phone: user.phone,
              password: user.password,
              isStudent: true,
              studentId: _studentIdController.text.trim(),
              name: _nameController.text.trim(),
              createdAt: user.createdAt,
            );
            await UserService.saveUserInfo(updatedUser, await UserService.getUserToken() ?? '');
          }
          
          if (mounted) {
            // 使用ForUI的正确Toast方法
            showFToast(
              context: context,
              icon: const Icon(FIcons.check),
              title: const Text('学生认证成功'),
              alignment: FToastAlignment.topCenter,
              duration: const Duration(seconds: 3),
            );
            
            // 返回上一页
            Navigator.of(context).pop(true);
          }
        } else {
          setState(() {
            _errorMessage = response['message'] as String?;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = '认证过程中发生错误，请稍后再试';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // 使用ForUI的FHeader组件
            FHeader.nested(
              title: const Text('学生认证'),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '请输入您的学号和姓名进行学生认证',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      
                      // 学号输入框
                      FTextFormField(
                        controller: _studentIdController,
                        label: const Text('学号'),
                        validator: _validateStudentId,
                      ),
                      const SizedBox(height: 16),
                      
                      // 姓名输入框
                      FTextFormField(
                        controller: _nameController,
                        label: const Text('姓名'),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 24),
                      
                      // 认证说明
                      FCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '认证说明',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• 认证成功后您将获得发布信息的权限\n'
                             ,
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // 错误消息显示
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: FAlert(
                            style: FAlertStyle.destructive(),
                            title: Text(_errorMessage!),
                          ),
                        ),
                      
                      // 提交按钮
                      FButton(
                        onPress: _isLoading ? null : _submitVerification,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('提交认证'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}