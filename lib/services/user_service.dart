import 'dart:convert';
import 'package:school_life/models/user.dart';
import 'package:school_life/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _authKey = 'auth_data';

  /// 获取当前用户
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString(_authKey);
    
    if (authData != null) {
      try {
        final Map<String, dynamic> userData = jsonDecode(authData);
        return User.fromJson(userData['user']);
      } catch (e) {
        print('解析用户数据失败: $e');
        return null;
      }
    }
    
    return null;
  }

  /// 获取用户认证令牌
  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString(_authKey);
    
    if (authData != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(authData);
        return data['token'] as String?;
      } catch (e) {
        print('解析认证令牌失败: $e');
        return null;
      }
    }
    
    return null;
  }

  /// 保存用户认证信息
  static Future<void> saveUserInfo(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    final authData = jsonEncode({
      'user': user.toJson(),
      'token': token,
    });
    await prefs.setString(_authKey, authData);
  }

  /// 清除用户认证信息
  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
  }

  /// 获取下一个用户ID
  static Future<int> getNextUserId() async {
    final dbService = DatabaseService();
    return await dbService.getNextUserId();
  }
}