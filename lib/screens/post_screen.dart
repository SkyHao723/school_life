import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/post.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/user_service.dart';
import '../services/api_service.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<String> _selectedTags = [];
  bool _isAnonymous = false;
  List<XFile> _selectedImages = [];
  bool _isLoading = false;

  // 标签选项
  final List<String> _availableTags = ['吐槽', '安利', '提问'];

  final ImagePicker _picker = ImagePicker();
  final DatabaseService _dbService = DatabaseService();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// 选择图片
  Future<void> _pickImages() async {
    if (_selectedImages.length >= 9) {
      // 显示提示信息
      if (mounted) {
        showFToast(
          context: context,
          icon: const Icon(FIcons.circleX, color: Colors.white),
          title: const Text('最多只能选择9张图片'),
          alignment: FToastAlignment.topCenter,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      
      if (pickedFiles.isNotEmpty) {
        final int remainingSlots = 9 - _selectedImages.length;
        final List<XFile> filesToAdd = pickedFiles.length > remainingSlots
            ? pickedFiles.sublist(0, remainingSlots)
            : pickedFiles;
        
        setState(() {
          _selectedImages.addAll(filesToAdd);
        });
      }
    } catch (e) {
      // 显示错误信息
      if (mounted) {
        showFToast(
          context: context,
          icon: const Icon(FIcons.circleX, color: Colors.white),
          title: const Text('选择图片失败'),
          alignment: FToastAlignment.topCenter,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  /// 压缩图片
  Future<String?> _compressImage(String imagePath) async {
    try {
      final String compressedPath = '${path.dirname(imagePath)}/compressed_${path.basename(imagePath)}';
      
      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        compressedPath,
        quality: 50,
        minWidth: 800,
        minHeight: 600,
      );
      
      return compressedFile?.path;
    } catch (e) {
      print('图片压缩失败: $e');
      return null;
    }
  }

  /// 上传图片
  Future<List<String?>> _uploadImages(List<XFile> images, String token) async {
    List<String?> uploadedUrls = [];

    for (final XFile image in images) {
      try {
        // 压缩图片
        final String? compressedImagePath = await _compressImage(image.path);
        final String imagePathToUpload = compressedImagePath ?? image.path;

        // 上传图片
        final String? imageUrl = await ApiService.uploadImage(imagePathToUpload, token);
        uploadedUrls.add(imageUrl);
      } catch (e) {
        print('上传图片失败: $e');
        uploadedUrls.add(null);
      }
    }

    return uploadedUrls;
  }

  Future<void> _submitPost() async {
    // 检查必填字段
    if (_titleController.text.trim().isEmpty) {
      if (mounted) {
        // 显示Toast提示
        showFToast(
          context: context,
          icon: const Icon(FIcons.circleX),
          title: const Text('请输入标题'),
          alignment: FToastAlignment.topCenter,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    if (_contentController.text.trim().isEmpty) {
      if (mounted) {
        // 显示Toast提示
        showFToast(
          context: context,
          icon: const Icon(FIcons.circleX),
          title: const Text('请输入正文'),
          alignment: FToastAlignment.topCenter,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    if (_selectedTags.isEmpty) {
      if (mounted) {
        // 显示Toast提示
        showFToast(
          context: context,
          icon: const Icon(FIcons.circleX),
          title: const Text('请选择至少一个标签'),
          alignment: FToastAlignment.topCenter,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 获取当前用户
      final User? currentUser = await UserService.getCurrentUser();
      if (currentUser == null) {
        if (mounted) {
          showFToast(
            context: context,
            icon: const Icon(FIcons.circleX),
            title: const Text('用户未登录'),
            alignment: FToastAlignment.topCenter,
            duration: const Duration(seconds: 3),
          );
        }
        return;
      }

      // 获取用户令牌
      final String? userToken = await UserService.getUserToken();
      if (userToken == null) {
        if (mounted) {
          showFToast(
            context: context,
            icon: const Icon(FIcons.circleX),
            title: const Text('用户认证失败'),
            alignment: FToastAlignment.topCenter,
            duration: const Duration(seconds: 3),
          );
        }
        return;
      }

      // 上传图片（如果有的话）
      List<String?> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        imageUrls = await _uploadImages(_selectedImages, userToken);
      }

      // 创建帖子对象
      final Post post = Post(
        userId: currentUser.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        tags: List<String>.from(_selectedTags), // 创建副本以防修改
        isAnonymous: _isAnonymous,
        imagePaths: imageUrls.where((url) => url != null).cast<String>().toList(),
        createdAt: DateTime.now(),
      );

      // 保存到本地数据库
      final int localPostId = await _dbService.insertPost(post);

      // 上传到服务器
      final bool uploadSuccess = await ApiService.uploadPost(post, currentUser, userToken);
      
      if (uploadSuccess) {
        if (mounted) {
          showFToast(
            context: context,
            icon: const Icon(FIcons.check),
            title: const Text('发布成功'),
            alignment: FToastAlignment.topCenter,
            duration: const Duration(seconds: 3),
          );
          
          // 返回上一页
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          showFToast(
            context: context,
            icon: const Icon(FIcons.circleX),
            title: const Text('发布失败，请检查网络连接'),
            alignment: FToastAlignment.topCenter,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      print('发布帖子时出错: $e'); // 新增：打印错误日志
      if (mounted) {
        // 显示Toast提示
        showFToast(
          context: context,
          icon: const Icon(FIcons.circleX),
          title: const Text('发帖失败，请重试'),
          alignment: FToastAlignment.topCenter,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              title: const Text('发布帖子'),
              prefixes: [
                FHeaderAction.back(
                  onPress: () => Navigator.of(context).pop(),
                ),
              ],
              suffixes: [
                FButton(
                  style: FButtonStyle.primary(),
                  onPress: _isLoading ? null : _submitPost,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('发布'),
                ),
              ],
            ),
            
            // 在header下方添加分割线
            const FDivider(),
            
            // 发帖内容区域
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题输入框
                    FTextField(
                      controller: _titleController,
                      label: const Text('标题'),
                      hint: '请输入帖子标题',
                    ),
                    const SizedBox(height: 16),
                    
                    // 正文输入框
                    FTextField(
                      controller: _contentController,
                      label: const Text('正文'),
                      hint: '请输入帖子内容',
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    
                    // 图片选择区域
                    const Text('图片（最多9张）', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FIcons.image, color: context.theme.colors.primary),
                            const SizedBox(height: 8),
                            const Text('点击选择图片', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_selectedImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(_selectedImages[index].path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(FIcons.x, size: 16, color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          _selectedImages.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // 标签选择
                    const Text('标签', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _availableTags.map((tag) {
                        final bool isSelected = _selectedTags.contains(tag);
                        return FButton(
                          style: isSelected 
                              ? FButtonStyle.primary() 
                              : FButtonStyle.secondary(),
                          onPress: () {
                            setState(() {
                              if (isSelected) {
                                _selectedTags.remove(tag);
                              } else {
                                _selectedTags.add(tag);
                              }
                            });
                          },
                          child: Text(tag, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    // 匿名选择
                    FSwitch(
                      label: const Text('匿名发布', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      description: const Text('对其他用户匿名显示', style: TextStyle(fontSize: 14)),
                      value: _isAnonymous,
                      onChange: (value) {
                        setState(() {
                          _isAnonymous = value;
                        });
                      },
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