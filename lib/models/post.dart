class Post {
  final int? id;
  final int userId;
  final String title;
  final String content;
  final List<String> tags;
  final bool isAnonymous;
  final List<String> imagePaths;
  final DateTime createdAt;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.tags,
    required this.isAnonymous,
    required this.imagePaths,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'tags': tags.join(','),
      'isAnonymous': isAnonymous ? 1 : 0,
      'imagePaths': imagePaths.join(','),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      tags: map['tags'] != null ? map['tags'].toString().split(',') : [],
      isAnonymous: map['isAnonymous'] == 1,
      imagePaths: map['imagePaths'] != null ? map['imagePaths'].toString().split(',') : [],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}