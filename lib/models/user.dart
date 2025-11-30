/// User data model
class User {
  /// UserID
  final int id;
  
  /// Phone number
  final String phone;
  
  /// Password
  final String password;
  
  /// Whether the user is a verified student (with posting permissions)
  final bool isStudent;
  
  /// Student ID
  final String? studentId;
  
  /// Name
  final String? name;
  
  /// College
  final String? college;
  
  /// Major
  final String? major;
  
  /// Enrollment year
  final String? enrollmentYear;
  
  /// Account creation time
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

  /// Create a User object from a Map
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

  /// Create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      phone: json['phone'] as String? ?? '',
      password: json['password'] as String? ?? '',
      isStudent: json['isStudent'] as bool? ?? false,
      studentId: json['studentId'] as String?,
      name: json['name'] as String?,
      college: json['college'] as String?,
      major: json['major'] as String?,
      enrollmentYear: json['enrollmentYear'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : DateTime.now(),
    );
  }

  /// Convert a User object to a Map
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
  
  /// Convert a User object to JSON
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