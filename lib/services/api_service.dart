// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../models/post.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://skyhao.xyz'; // 使用实际部署的域名

  // 创建一个自定义的HttpClient以处理SSL证书问题
  static http.Client _createHttpClient() {
    final client = IOClient(HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // 在开发环境中允许所有证书（仅用于测试）
        // 生产环境中应该正确配置SSL证书
        print('Allowing bad certificate for $host:$port');
        return true;
      });
    return client;
  }

  // 用户登录
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/auth/login');
      client = _createHttpClient();
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'phone': phone,
          'password': password,
        });
      
      final response = await client.send(request).timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();
      
      // 确保响应体不为空再解析
      if (responseBody.trim().isEmpty) {
        return {
          'success': false,
          'message': '服务器返回空响应'
        };
      }
      
      try {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        print('JSON解析错误: $e');
        print('响应内容: $responseBody');
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
      print('登录错误: $e');
      return {
        'success': false,
        'message': '登录过程中发生错误，请稍后再试'
      };
    } finally {
      client?.close();
    }
  }

  // 获取用户信息
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/user/profile');
      client = _createHttpClient();
      final request = http.Request('GET', url)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token';
      
      final response = await client.send(request).timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();
      
      // 确保响应体不为空再解析
      if (responseBody.trim().isEmpty) {
        return {
          'success': false,
          'message': '服务器返回空响应'
        };
      }
      
      try {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        print('JSON解析错误: $e');
        print('响应内容: $responseBody');
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
      print('获取用户信息错误: $e');
      return {
        'success': false,
        'message': '获取用户信息过程中发生错误，请稍后再试'
      };
    } finally {
      client?.close();
    }
  }

  // 用户登出
  static Future<Map<String, dynamic>> logout(String token) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/auth/logout');
      client = _createHttpClient();
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token';
      
      final response = await client.send(request).timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();
      
      // 确保响应体不为空再解析
      if (responseBody.trim().isEmpty) {
        return {
          'success': false,
          'message': '服务器返回空响应'
        };
      }
      
      try {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        print('JSON解析错误: $e');
        print('响应内容: $responseBody');
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
      print('登出错误: $e');
      return {
        'success': false,
        'message': '登出过程中发生错误，请稍后再试'
      };
    } finally {
      client?.close();
    }
  }

  // 用户注册
  static Future<Map<String, dynamic>> register({
    required String phone,
    required String password,
    required String verificationCode,
  }) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/auth/register');
      client = _createHttpClient();
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'phone': phone,
          'password': password,
          'verificationCode': verificationCode,
        });
      
      final response = await client.send(request).timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();
      
      // 确保响应体不为空再解析
      if (responseBody.trim().isEmpty) {
        return {
          'success': false,
          'message': '服务器返回空响应'
        };
      }
      
      try {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        print('JSON解析错误: $e');
        print('响应内容: $responseBody');
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
      client?.close();
    }
  }

  // 发送验证码
  static Future<Map<String, dynamic>> sendVerificationCode(String phone) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/auth/send-code');
      client = _createHttpClient();
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({'phone': phone});
      
      final response = await client.send(request).timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();
      
      // 确保响应体不为空再解析
      if (responseBody.trim().isEmpty) {
        return {
          'success': false,
          'message': '服务器返回空响应'
        };
      }
      
      try {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        print('JSON解析错误: $e');
        print('响应内容: $responseBody');
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
      print('发送验证码错误: $e');
      return {
        'success': false,
        'message': '发送验证码过程中发生错误，请稍后再试'
      };
    } finally {
      client?.close();
    }
  }


  /// 学生认证
  /// [studentId] 学号
  /// [name] 姓名
  /// [token] JWT令牌
  static Future<Map<String, dynamic>> verifyStudent(String studentId, String name, String token) async {
    http.Client? client;
    try {
      final url = Uri.parse('${ApiService._baseUrl}/api/user/verify-student');
      
      client = _createHttpClient();
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token'
        ..body = jsonEncode({
          'studentId': studentId,
          'name': name,
        });
      
      final response = await client.send(request).timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();
      
      // 确保响应体不为空再解析
      if (responseBody.trim().isEmpty) {
        return {
          'success': false,
          'message': '服务器返回空响应'
        };
      }
      
      try {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        print('JSON解析错误: $e');
        print('响应内容: $responseBody');
        return {
          'success': false,
          'message': '服务器响应格式错误'
        };
      }
    } catch (e) {
      print('学生认证API错误: $e');
      rethrow;
    } finally {
      client?.close();
    }
  }

  // 学生认证请求API
  static Future<Map<String, dynamic>> requestStudentVerification(String token) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/user/verify-student');
      client = _createHttpClient();
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token';
      
      final response = await client.send(request).timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();
      
      // 确保响应体不为空
      if (responseBody.isNotEmpty) {
        final decodedResponse = jsonDecode(responseBody);
        if (decodedResponse is Map<String, dynamic>) {
          return decodedResponse;
        }
      }
      
      // 如果响应为空或不是Map类型，返回默认错误响应
      return {
        'success': false,
        'message': '服务器响应格式错误'
      };
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
      print('学生认证请求错误: $e');
      return {
        'success': false,
        'message': '学生认证请求过程中发生错误，请稍后再试'
      };
    } finally {
      client?.close();
    }
  }

  // 发送帖子到服务器
  static Future<bool> uploadPost(Post post, User user, String token) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/posts');
      client = _createHttpClient();
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token'
        ..body = jsonEncode({
          'title': post.title,
          'content': post.content,
          'tags': post.tags,
          'isAnonymous': post.isAnonymous,
          'imagePaths': post.imagePaths,
        });
      
      final response = await client.send(request).timeout(const Duration(seconds: 30));
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 201) {
        // 成功上传
        return true;
      } else {
        // 上传失败
        print('Failed to upload post: ${response.statusCode}');
        print('Response body: $responseBody');
        return false;
      }
    } on SocketException catch (e) {
      print('Network error uploading post: $e');
      return false;
    } on TimeoutException catch (e) {
      print('Timeout error uploading post: $e');
      return false;
    } catch (e) {
      print('Error uploading post: $e');
      return false;
    } finally {
      client?.close();
    }
  }

  // 上传图片到服务器
  static Future<String?> uploadImage(String imagePath, String token) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/images');
      client = _createHttpClient();
      final request = http.MultipartRequest('POST', url);
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      final file = await http.MultipartFile.fromPath('image', imagePath);
      request.files.add(file);

      final response = await request.send().timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        if (respStr.trim().isEmpty) {
          print('上传图片返回空响应');
          return null;
        }
        
        try {
          final respJson = jsonDecode(respStr);
          return respJson['imageUrl'];
        } catch (e) {
          print('JSON解析错误: $e');
          print('响应内容: $respStr');
          return null;
        }
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } on SocketException catch (e) {
      print('Network error uploading image: $e');
      return null;
    } on TimeoutException catch (e) {
      print('Timeout error uploading image: $e');
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    } finally {
      client?.close();
    }
  }
  
  // 获取帖子列表
  static Future<Map<String, dynamic>?> getPosts(int page, int limit) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/posts?page=$page&limit=$limit');
      client = _createHttpClient();
      final request = http.Request('GET', url);
      
      final response = await client.send(request).timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        // 确保响应体不为空再解析
        if (responseBody.trim().isEmpty) {
          print('获取帖子列表返回空响应');
          return null;
        }
        
        try {
          final decodedResponse = jsonDecode(responseBody);
          if (decodedResponse is Map<String, dynamic>) {
            return decodedResponse;
          }
          print('获取帖子列表响应格式错误');
          return null;
        } catch (e) {
          print('JSON解析错误: $e');
          print('响应内容: $responseBody');
          return null;
        }
      } else {
        print('Failed to get posts: ${response.statusCode}');
        return null;
      }
    } on SocketException catch (e) {
      print('Network error getting posts: $e');
      return null;
    } on TimeoutException catch (e) {
      print('Timeout error getting posts: $e');
      return null;
    } catch (e) {
      print('Error getting posts: $e');
      return null;
    } finally {
      client?.close();
    }
  }
  
  // 获取单个帖子
  static Future<Map<String, dynamic>?> getPost(int postId) async {
    http.Client? client;
    try {
      final url = Uri.parse('$_baseUrl/api/posts/$postId');
      client = _createHttpClient();
      final request = http.Request('GET', url);
      
      final response = await client.send(request).timeout(const Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        // 确保响应体不为空再解析
        if (responseBody.trim().isEmpty) {
          print('获取单个帖子返回空响应');
          return null;
        }
        
        try {
          final decodedResponse = jsonDecode(responseBody);
          if (decodedResponse is Map<String, dynamic>) {
            return decodedResponse;
          }
          print('获取单个帖子响应格式错误');
          return null;
        } catch (e) {
          print('JSON解析错误: $e');
          print('响应内容: $responseBody');
          return null;
        }
      } else {
        print('Failed to get post: ${response.statusCode}');
        return null;
      }
    } on SocketException catch (e) {
      print('Network error getting post: $e');
      return null;
    } on TimeoutException catch (e) {
      print('Timeout error getting post: $e');
      return null;
    } catch (e) {
      print('Error getting post: $e');
      return null;
    } finally {
      client?.close();
    }
  }
}

