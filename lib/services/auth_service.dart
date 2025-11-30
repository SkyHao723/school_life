import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:school_life/models/user.dart';
import 'package:school_life/services/storage_service.dart';
import 'api_service.dart'; // 确保路径正确，如果 ApiService 在同一目录下

/// 认证服务类
/// 管理用户登录状态和认证逻辑
class AuthService {
  // 单例模式
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // 当前用户
  User? _currentUser;

  // 认证令牌
  String? _authToken;

  // 加载状态
  bool _isLoading = false;

  // 存储服务
  late final StorageService _storageService;

  /// 初始化服务
  Future<void> init() async {
    _storageService = StorageService();
    await _storageService.init();
  }

  /// 获取当前用户
  User? get currentUser => _currentUser;

  /// 获取认证令牌
  String? get authToken => _authToken;

  /// 检查用户是否已认证
  bool get isAuthenticated => _currentUser != null && _authToken != null;

  /// 检查用户是否有发布权限（已通过学生认证）
  bool get canPublish => _currentUser?.isStudent ?? false;
  
  /// 发送验证码
  /// 返回包含 success 和 message 的 Map
  Future<Map<String, dynamic>> sendVerificationCode(String phone) async {
    try {
      final response = await ApiService.sendVerificationCode(phone);
      return response;
    } on SocketException catch (e) {
      // 网络连接错误
      print('网络连接错误: $e');
      throw Exception('网络连接失败，请检查网络设置');
    } on TimeoutException catch (e) {
      // 请求超时
      print('请求超时: $e');
      throw Exception('请求超时，请稍后重试');
    } catch (e) {
      // 其他错误
      print('发送验证码错误: $e');
      throw Exception('发送验证码过程中发生错误，请稍后再试');
    }
  }
  
  /// 登录方法
  /// [phone] 手机号
  /// [password] 密码
  /// 返回登录是否成功
  Future<bool> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await ApiService.login(
        phone: phone,
        password: password,
      );
      
      if (response['success'] == true && response['data'] != null) {
        final userData = response['data']['user'];
        final token = response['data']['token'];
        
        _currentUser = User.fromJson(userData);
        _authToken = token as String?; // 确保token正确处理
        
        // 保存登录状态
        await _saveAuthState();
        return true;
      } else {
        // API返回错误信息
        print('登录失败: ${response['message']}');
        return false;
      }
    } on SocketException catch (e) {
      // 网络连接错误
      print('网络连接错误: $e');
      throw Exception('网络连接失败，请检查网络设置');
    } on TimeoutException catch (e) {
      // 请求超时
      print('请求超时: $e');
      throw Exception('请求超时，请稍后重试');
    } catch (e) {
      // 其他错误
      print('登录错误: $e');
      throw Exception('登录失败，请检查手机号和密码');
    }
  }
  
  /// 注册方法
  /// [phone] 手机号
  /// [password] 密码
  /// [verificationCode] 验证码
  /// 返回注册是否成功
  Future<bool> register({
    required String phone,
    required String password,
    required String verificationCode,
  }) async {
    try {
      final response = await ApiService.register(
        phone: phone,
        password: password,
        verificationCode: verificationCode,
      );
      
      if (response['success'] == true && response['data'] != null) {
        final userData = response['data']['user'];
        final token = response['data']['token'];
        
        _currentUser = User.fromJson(userData as Map<String, dynamic>);
        _authToken = token as String?; // 确保token正确处理
        
        // 保存登录状态
        await _saveAuthState();
        return true;
      } else {
        // API返回错误信息
        print('注册失败: ${response['message']}');
        return false;
      }
    } on SocketException catch (e) {
      // 网络连接错误
      print('网络连接错误: $e');
      throw Exception('网络连接失败，请检查网络设置');
    } on TimeoutException catch (e) {
      // 请求超时
      print('请求超时: $e');
      throw Exception('请求超时，请稍后重试');
    } catch (e) {
      // 其他错误
      print('注册错误: $e');
      throw Exception('注册失败，请检查输入信息');
    }
  }
  
  /// 登出方法
  Future<void> logout() async {
    if (_authToken != null) {
      // 调用API登出
      try {
        await ApiService.logout(_authToken!);
      } catch (e) {
        print('调用登出API时出错: $e');
      }
    }
    
    _currentUser = null;
    _authToken = null;
    await _clearAuthState();
  }
  
  /// 检查认证状态
  /// 应用启动时调用，恢复之前的登录状态
  Future<void> checkAuthStatus() async {
    try {
      // 从本地存储恢复令牌
      final token = await _storageService.getString('auth_token');
      if (token == null || token.isEmpty) {
        return;
      }
      
      // 使用令牌获取用户信息
      final response = await ApiService.getUserProfile(token);
      if (response['success'] == true && response['data'] != null && response['data']['user'] != null) {
        _currentUser = User.fromJson(response['data']['user']);
        _authToken = token;
      } else {
        // 令牌无效，清除认证状态
        await _clearAuthState();
      }
    } catch (e) {
      // 解析失败，清除认证状态
      print('检查认证状态时出错: $e');
      await _clearAuthState();
    }
  }
  
  /// 申请学生认证
  /// 实际项目中应该上传学生证等材料供审核
  Future<bool> requestStudentVerification() async {
    if (_authToken == null) {
      return false;
    }
    
    try {
      final response = await ApiService.requestStudentVerification(_authToken!);
      
      if (response['success'] == true) {
        // 更新本地用户状态
        if (_currentUser != null) {
          _currentUser = User(
            id: _currentUser!.id,
            phone: _currentUser!.phone,
            password: '', // AuthService中没有存储密码
            isStudent: true, // 设置为已认证学生
            name: _currentUser!.name,
            createdAt: _currentUser!.createdAt,
          );

          // 保存更新后的状态
          await _saveAuthState();
        }
        return true;
      }
      return false;
    } on SocketException catch (e) {
      // 网络连接错误
      print('网络连接错误: $e');
      throw Exception('网络连接失败，请检查网络设置');
    } on TimeoutException catch (e) {
      // 请求超时
      print('请求超时: $e');
      throw Exception('请求超时，请稍后重试');
    } catch (e) {
      // 其他错误
      print('申请学生认证时出错: $e');
      throw Exception('学生认证请求过程中发生错误，请稍后再试');
    }
  }

  /// 学生认证
  /// [studentId] 学号
  /// [name] 姓名
  /// 返回包含 success 和 message 的 Map
  Future<Map<String, dynamic>> verifyStudent({
    required String studentId,
    required String name,
  }) async {
    if (_authToken == null) {
      return {
        'success': false,
        'message': '用户未登录',
      };
    }
    
    try {
      final response = await ApiService.verifyStudent(studentId, name, _authToken!);
      return response;
    } catch (e) {
      print('学生认证错误: $e');
      return {
        'success': false,
        'message': '认证过程中发生错误，请稍后再试'
      };
    }
  }
  
  /// 保存认证状态到本地存储
  Future<void> _saveAuthState() async {
    if (_authToken != null && _currentUser != null) {
      final authData = {
        'token': _authToken,
        'user': _currentUser!.toMap(), // 假设User类有toMap方法，否则使用toJson
      };
      await _storageService.setString('auth_data', jsonEncode(authData));
      
      // 同时单独保存token以便快速检查登录状态
      await _storageService.setString('auth_token', _authToken!);
    }
  }

  /// 清除本地存储的认证状态
  Future<void> _clearAuthState() async {
    await _storageService.setString('auth_data', '');
    await _storageService.setString('auth_token', '');
  }
}