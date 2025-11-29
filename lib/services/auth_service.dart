import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:school_life/models/user.dart';
import 'package:school_life/services/storage_service.dart';
import 'api_service.dart';

class AuthService {
  User? _currentUser;
  String? _authToken;
  bool _isLoading = false;
  final StorageService _storageService = StorageService();

  User? get currentUserValue => _currentUser;
  String? get authTokenValue => _authToken;
  bool get isAuthenticatedValue => _currentUser != null && _authToken != null;
  bool get canPublishValue => _currentUser?.isStudent ?? false;
  bool get isLoadingValue => _isLoading;

  /// 初始化认证服务
  Future<void> init() async {
    await _storageService.init();
  }
  
  /// 发送验证码
  /// 返回包含 success 和 message 的 Map
  Future<Map<String, dynamic>> sendVerificationCode(String phone) async {
    _isLoading = true;
    try {
      final response = await ApiService.sendVerificationCode(phone);
      return response;
    } on SocketException catch (e) {
      // 网络连接错误
      print('网络连接错误: $e');
      return {
        'success': false,
        'message': '网络连接失败，请检查网络设置'
      };
    } on TimeoutException catch (e) {
      // 请求超时
      print('请求超时: $e');
      return {
        'success': false,
        'message': '请求超时，请稍后重试'
      };
    } catch (e) {
      // 其他错误
      print('发送验证码错误: $e');
      return {
        'success': false,
        'message': '发送验证码过程中发生错误，请稍后再试'
      };
    } finally {
      _isLoading = false;
    }
  }
  
  /// 登录方法
  /// [phone] 手机号
  /// [password] 密码
  /// 返回包含 success 和 message 的 Map
  Future<Map<String, dynamic>> login(String phone, String password) async {
    _isLoading = true;
    
    try {
      final response = await ApiService.login(phone, password);
      
      // 确保响应是一个Map
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          _authToken = response['token'] as String?;
          final userData = response['user'];
          
          if (userData != null && userData is Map<String, dynamic>) {
            _currentUser = User.fromJson(userData);
            
            // 保存认证状态到本地存储
            await _saveAuthState();
          }
        }
        
        return response;
      } else {
        // 如果响应不是Map，返回错误
        return {
          'success': false,
          'message': '服务器响应格式错误'
        };
      }
    } on SocketException catch (e) {
      // 网络连接错误
      print('网络连接错误: $e');
      return {
        'success': false,
        'message': '网络连接失败，请检查网络设置'
      };
    } on TimeoutException catch (e) {
      // 请求超时
      print('请求超时: $e');
      return {
        'success': false,
        'message': '请求超时，请稍后重试'
      };
    } catch (e) {
      // 其他错误
      print('登录错误: $e');
      return {
        'success': false,
        'message': '登录失败，请检查手机号和密码'
      };
    } finally {
      _isLoading = false;
    }
  }
  
  /// 注册
  Future<Map<String, dynamic>> register(String phone, String password, String verificationCode) async {
    _isLoading = true;
    
    try {
      final response = await ApiService.register(phone, password);
      
      // 确保响应是一个Map
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          _authToken = response['token'] as String?;
          final userData = response['user'];
          
          if (userData != null && userData is Map<String, dynamic>) {
            _currentUser = User.fromJson(userData);
            
            // 保存认证状态到本地存储
            await _saveAuthState();
          }
        }
        
        return response;
      } else {
        // 如果响应不是Map，返回错误
        return {
          'success': false,
          'message': '服务器响应格式错误'
        };
      }
    } on SocketException catch (e) {
      print('网络连接错误: $e');
      return {
        'success': false,
        'message': '网络连接失败，请检查网络设置'
      };
    } on TimeoutException catch (e) {
      print('请求超时错误: $e');
      return {
        'success': false,
        'message': '请求超时，请稍后再试'
      };
    } catch (e) {
      print('注册错误: $e');
      return {
        'success': false,
        'message': '注册过程中发生错误，请稍后再试'
      };
    } finally {
      _isLoading = false;
    }
  }
  
  /// 登出方法
  Future<void> logout() async {
    _currentUser = null;
    _authToken = null;
    await _clearAuthState();
  }
  
  /// 检查认证状态
  /// 应用启动时调用，恢复之前的登录状态
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    
    try {
      // 从本地存储中获取保存的认证信息
      final savedAuthData = await _storageService.getString('auth_data');
      
      if (savedAuthData != null && savedAuthData.isNotEmpty) {
        final authData = jsonDecode(savedAuthData);
        if (authData is Map<String, dynamic>) {
          _authToken = authData['token'] as String?;
          final userData = authData['user'];
          
          if (userData != null && userData is Map<String, dynamic>) {
            _currentUser = User.fromJson(userData);
          }
        }
      }
    } on SocketException catch (e) {
      print('网络连接错误: $e');
      throw Exception('网络连接失败，请检查网络设置');
    } on TimeoutException catch (e) {
      print('请求超时错误: $e');
      throw Exception('请求超时，请稍后再试');
    } catch (e) {
      print('检查认证状态时出错: $e');
      // 清除可能损坏的本地数据
      await _clearAuthState();
    } finally {
      _isLoading = false;
    }
  }
  
  /// 申请学生认证
  /// 实际项目中应该上传学生证等材料供审核
  /// 返回包含 success 和 message 的 Map
  Future<Map<String, dynamic>> requestStudentVerification() async {
    if (_authToken == null) {
      return {
        'success': false,
        'message': '用户未登录',
      };
    }

    _isLoading = true;
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
      }
      
      return response;
    } on SocketException catch (e) {
      // 网络连接错误
      print('网络连接错误: $e');
      return {
        'success': false,
        'message': '网络连接失败，请检查网络设置'
      };
    } on TimeoutException catch (e) {
      // 请求超时
      print('请求超时: $e');
      return {
        'success': false,
        'message': '请求超时，请稍后重试'
      };
    } catch (e) {
      // 其他错误
      print('申请学生认证时出错: $e');
      return {
        'success': false,
        'message': '学生认证请求过程中发生错误，请稍后再试'
      };
    } finally {
      _isLoading = false;
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
    }
  }

  /// 清除本地存储的认证状态
  Future<void> _clearAuthState() async {
    await _storageService.setString('auth_data', '');
  }
}