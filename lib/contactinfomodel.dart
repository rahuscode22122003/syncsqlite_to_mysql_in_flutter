class ContactinfoModel {
  int? id;
  int userId;
  String name;
  String email;
  String gender;
  String createdAt;

  ContactinfoModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.gender,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'gender': gender,
      'createdAt': createdAt,
    };
  }

  factory ContactinfoModel.fromJson(Map<String, dynamic> json) {
    return ContactinfoModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      createdAt: json['createdAt'],
    );
  }
}
