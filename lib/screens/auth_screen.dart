import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:school_life/services/auth_service.dart';
import 'dart:async'; // 添加Timer导入

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginPhoneController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerPhoneController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  
  bool _isLoading = false;
  int _currentIndex = 0;
  bool _canResendCode = true;
  int _resendCooldown = 60; // 60秒冷却时间
  
  final AuthService _authService = AuthService();
  late BuildContext _toastContext; // 添加一个变量来保存正确的上下文

  Timer? _cooldownTimer; // 添加一个变量来存储倒计时定时器
  
  // 添加密码可见性控制变量
  bool _isLoginPasswordVisible = false;
  bool _isRegisterPasswordVisible = false;
  bool _isRegisterConfirmPasswordVisible = false;
  
  // 添加协议同意控制变量
  bool _isAgreementChecked = false;
  
  
  @override
  void dispose() {
    _loginPhoneController.dispose();
    _loginPasswordController.dispose();
    _registerPhoneController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    _verificationCodeController.dispose();
    _cooldownTimer?.cancel(); // 取消倒计时定时器
    super.dispose();
  }
  
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
      return '请输入正确的手机号';
    }
    return null;
  }
  
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码长度至少6位';
    }
    return null;
  }
  
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请确认密码';
    }
    if (value != _registerPasswordController.text) {
      return '两次输入的密码不一致';
    }
    return null;
  }
  
  String? _validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入验证码';
    }
    // 暂时接受任意验证码，但提示用户使用9999进行测试
    return null;
  }
  
  void _showToast(String message, {bool isError = false}) {
    if (_toastContext.mounted) {
      showFToast(
        context: _toastContext,
        icon: isError ? const Icon(FIcons.circleX) : const Icon(FIcons.check),
        title: Text(message),
        alignment: FToastAlignment.topCenter,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  void _startCooldownTimer() {
    setState(() {
      _canResendCode = false;
    });
    
    // 存储 Timer 引用以便后续取消
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendCooldown > 1) {
          _resendCooldown--;
        } else {
          _resendCooldown = 60;
          _canResendCode = true;
          timer.cancel();
        }
      });
    });
  }
  
  void _handleLogin() async {
    // 执行表单验证
    if ((_validatePhone(_loginPhoneController.text) == null) && 
        (_validatePassword(_loginPasswordController.text) == null)) {
      
      // 检查是否同意协议
      if (!_isAgreementChecked) {
        _showToast('请先阅读并同意用户协议和隐私政策', isError: true);
        return;
      }
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        final response = await _authService.login(
          _loginPhoneController.text.trim(),
          _loginPasswordController.text,
        );
        
        setState(() {
          _isLoading = false;
        });
        
        final success = response['success'] as bool?;
        if (success == true) {
          // 登录成功，显示提示并跳转到主屏幕
          _showToast('登录成功');
          // 延迟跳转，让用户看到成功提示
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/main');
            }
          });
        } else {
          _showToast(response['message'] as String? ?? '登录失败', isError: true);
        }
      } on Exception catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showToast(e.toString().replaceAll('Exception:', '').trim(), isError: true);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showToast('未知错误，请稍后重试', isError: true);
        print('未知错误: $e');
      }
    } else {
      _showToast('请检查输入信息', isError: true);
    }
  }
  
  void _handleRegister() async {
    // 执行表单验证
    if ((_validatePhone(_registerPhoneController.text) == null) && 
        (_validatePassword(_registerPasswordController.text) == null) &&
        (_validateConfirmPassword(_registerConfirmPasswordController.text) == null)) {
      
      // 检查是否同意协议
      if (!_isAgreementChecked) {
        _showToast('请先阅读并同意用户协议和隐私政策', isError: true);
        return;
      }
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        final response = await _authService.register(
          _registerPhoneController.text.trim(),
          _registerPasswordController.text,
          _verificationCodeController.text,
        );
        
        setState(() {
          _isLoading = false;
        });
        
        final success = response['success'] as bool?;
        if (success == true) {
          // 注册成功，显示成功消息
          _showToast('注册成功! 请使用新账户登录');
          
          // 注册成功后自动切换到登录标签页
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _currentIndex = 0;
              });
            }
          });
        } else {
          _showToast(response['message'] as String? ?? '注册失败', isError: true);
        }
      } on Exception catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showToast(e.toString().replaceAll('Exception:', '').trim(), isError: true);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showToast('未知错误，请稍后重试', isError: true);
        print('未知错误: $e');
      }
    } else {
      _showToast('请检查输入信息', isError: true);
    }
  }
  
  void _sendVerificationCode() async {
    // 执行表单验证
    if (_validatePhone(_registerPhoneController.text) == null) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final response = await _authService.sendVerificationCode(
          _registerPhoneController.text.trim(),
        );
        
        setState(() {
          _isLoading = false;
        });
        
        final success = response['success'] as bool?;
        if (success == true) {
          // 发送成功，开始倒计时
          _startCooldownTimer();
          _showToast('验证码已发送，请查收短信');
        } else {
          _showToast(response['message'] as String? ?? '发送失败', isError: true);
        }
      } on Exception catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showToast(e.toString().replaceAll('Exception:', '').trim(), isError: true);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showToast('未知错误，请稍后重试', isError: true);
        print('未知错误: $e');
      }
    } else {
      _showToast('请检查输入信息', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: SafeArea(
        child: Builder(
          builder: (toastContext) {
            // 保存正确的上下文供后续使用
            _toastContext = toastContext;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo 和标题
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: context.theme.colors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            FIcons.user,
                            size: 40,
                            color: context.theme.colors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 使用 FTabs 组件组织登录和注册表单
                  Expanded(
                    child: FTabs(
                      children: [
                        // 登录标签页
                        FTabEntry(
                          label: const Text('登录'),
                          child: Builder(
                            builder: (tabContext) => SingleChildScrollView(
                              child: FCard(
                                child: Column(
                                  children: [
                                    FTextField(
                                      label: const Text('手机号'),
                                      controller: _loginPhoneController,
                                      keyboardType: TextInputType.phone,
                                      suffixBuilder: (context, styles, child) => SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Container(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    FTextField(
                                      label: const Text('密码'),
                                      controller: _loginPasswordController,
                                      obscureText: !_isLoginPasswordVisible,
                                      suffixBuilder: (context, styles, child) => SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: IconButton(
                                          icon: Icon(
                                            _isLoginPasswordVisible 
                                              ? FIcons.eye 
                                              : FIcons.eyeOff,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isLoginPasswordVisible = !_isLoginPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // 协议同意复选框
                                    FCheckbox(
                                      label: const Text('接受条款和条件'),
                                      description: const Text('您已阅读并同意我们的用户协议和隐私政策。'),
                                      semanticsLabel: '接受条款和条件',
                                      value: _isAgreementChecked,
                                      onChange: (value) => setState(() => _isAgreementChecked = value),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // 登录按钮
                                    FButton(
                                      onPress: _isLoading ? null : () => _handleLogin(),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text('登录'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // 注册标签页
                        FTabEntry(
                          label: const Text('注册'),
                          child: Builder(
                            builder: (tabContext) => SingleChildScrollView(
                              child: FCard(
                                child: Column(
                                  children: [
                                    FTextField(
                                      label: const Text('手机号'),
                                      hint:"仅支持中国大陆手机号",
                                      controller: _registerPhoneController,
                                      keyboardType: TextInputType.phone,
                                      suffixBuilder: (context, styles, child) => SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Container(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    FTextField(
                                      label: const Text('密码'),
                                      hint:"6-18位，包含a-z，0-9",
                                      controller: _registerPasswordController,
                                      obscureText: !_isRegisterPasswordVisible,
                                      suffixBuilder: (context, styles, child) => SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: IconButton(
                                          icon: Icon(
                                            _isRegisterPasswordVisible 
                                              ? FIcons.eye 
                                              : FIcons.eyeOff,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isRegisterPasswordVisible = !_isRegisterPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    FTextField(
                                      label: const Text('确认密码'),
                                      hint:"请确保两次输入的密码一致",
                                      controller: _registerConfirmPasswordController,
                                      obscureText: !_isRegisterConfirmPasswordVisible,
                                      suffixBuilder: (context, styles, child) => SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: IconButton(
                                          icon: Icon(
                                            _isRegisterConfirmPasswordVisible 
                                              ? FIcons.eye 
                                              : FIcons.eyeOff,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isRegisterConfirmPasswordVisible = !_isRegisterConfirmPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // 验证码输入框和发送按钮
                                    Row(
                                      children: [
                                        Expanded(
                                          child: FTextField(
                                            label: const Text('验证码'),
                                            controller: _verificationCodeController,
                                            hint: _canResendCode ? '请输入验证码' : '请${_resendCooldown}秒后再获取',
                                            suffixBuilder: (context, styles, child) => SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Container(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            const SizedBox(height: 20), // 按照规范使用SizedBox添加空白行
                                            FButton(
                                              style: FButtonStyle.secondary(),
                                              onPress: _canResendCode && !_isLoading ? () => _sendVerificationCode() : null,
                                              child: _isLoading
                                                  ? const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                      ),
                                                    )
                                                  : Text('获取验证码'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // 协议同意复选框
                                    FCheckbox(
                                      label: const Text('接受条款和条件'),
                                      description: const Text('您已阅读并同意我们的用户协议和隐私政策。'),
                                      semanticsLabel: '接受条款和条件',
                                      value: _isAgreementChecked,
                                      onChange: (value) => setState(() => _isAgreementChecked = value),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // 注册按钮
                                    FButton(
                                      onPress: _isLoading ? null : () => _handleRegister(),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text('注册'),
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // 注意事项
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: context.theme.colors.secondary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        '注意：新注册账户仅有浏览权限。\n如需发布信息，请在设置中进行学生身份认证。',
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      initialIndex: _currentIndex,
                      onPress: (index) => setState(() => _currentIndex = index),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}