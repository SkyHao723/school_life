/// 用户数据模型
class User {
  /// 用户ID
  final int id;
  
  /// 手机号
  final String phone;
  
  /// 密码
  final String password;
  
  /// 是否为认证学生（拥有发布权限）
  final bool isStudent;
  
  /// 学号
  final String? studentId;
  
  /// 姓名
  final String? name;
  
  /// 学院
  final String? college;
  
  /// 专业
  final String? major;
  
  /// 入学年份
  final String? enrollmentYear;
  
  /// 账户创建时间
  final DateTime createdAt;

  User({
    required this.id,
    required this.phone,
    required this.password,
    this.isStudent = false,
    this.studentId,
    this.name,
    this.college,
    this.major,
    this.enrollmentYear,
    required this.createdAt,
  });

  /// 从Map创建用户对象
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      phone: map['phone'],
      password: map['password'],
      isStudent: map['isStudent'] == 1 || map['isStudent'] == true,
      studentId: map['studentId'],
      name: map['name'],
      college: map['college'],
      major: map['major'],
      enrollmentYear: map['enrollmentYear'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  /// 从JSON创建用户对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phone: json['phone'],
      password: json['password'],
      isStudent: json['isStudent'] == true,
      studentId: json['studentId'],
      name: json['name'],
      college: json['college'],
      major: json['major'],
      enrollmentYear: json['enrollmentYear'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// 将用户对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'password': password,
      'isStudent': isStudent ? 1 : 0,
      'studentId': studentId,
      'name': name,
      'college': college,
      'major': major,
      'enrollmentYear': enrollmentYear,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  /// 将用户对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'password': password,
      'isStudent': isStudent,
      'studentId': studentId,
      'name': name,
      'college': college,
      'major': major,
      'enrollmentYear': enrollmentYear,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  @override
  String toString() {
    return 'User(id: $id, phone: $phone, isStudent: $isStudent, createdAt: $createdAt)';
  }
}