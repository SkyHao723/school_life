import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  const baseUrl = 'https://skyhao.xyz';
  
  print('Testing API connection to $baseUrl');
  
  try {
    // 创建一个忽略SSL证书验证的HttpClient
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        print('Allowing bad certificate for $host:$port');
        return true; // 允许所有证书（仅用于测试）
      };
    
    // 测试API状态端点
    final statusUrl = Uri.parse('$baseUrl/api/status');
    print('Calling $statusUrl');
    
    final request = await httpClient.getUrl(statusUrl);
    final response = await request.close().timeout(Duration(seconds: 10));
    
    print('Status code: ${response.statusCode}');
    
    final responseBody = await response.transform(utf8.decoder).join();
    print('Response body: $responseBody');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      if (data['success'] == true) {
        print('✅ API is working correctly');
      } else {
        print('❌ API returned success=false');
      }
    } else {
      print('❌ API returned status code ${response.statusCode}');
    }
    
    httpClient.close();
  } catch (e) {
    print('❌ Error connecting to API: $e');
  }
}