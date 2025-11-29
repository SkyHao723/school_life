import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/profile_service.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await ProfileService.getCurrentUserProfile();
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      print('加载用户资料失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户资料'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? Center(child: Text('未找到用户资料'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildInfoTile('用户名', _currentUser!.username),
                      SizedBox(height: 10),
                      _buildInfoTile('学号', _currentUser!.studentId ?? '未填写'),
                      SizedBox(height: 10),
                      _buildInfoTile('邮箱', _currentUser!.email ?? '未填写'),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // 这里可以添加编辑资料的逻辑
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('编辑功能待实现')),
                            );
                          },
                          child: Text('编辑资料'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}