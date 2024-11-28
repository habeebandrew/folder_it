class Member {
  final String userName;
  final int roleId;
  final int id;
  final int userId;

  Member({
    required this.userName,
    required this.roleId,
    required this.id,
    required this.userId,
  });

  // تحويل JSON إلى كائن Member
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      userName: json['userName'],
      roleId: json['roleId'],
      id: json['id'],
      userId: json['userId'],
    );
  }
}
