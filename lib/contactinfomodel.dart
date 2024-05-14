class ContactinfoModel {
  final int? userId;
  final String name;
  final String email;
  final String gender;
  final String createdAt;
  final int? id;


  ContactinfoModel({
    required this.name,
    required this.email,
    required this.gender,
    required this.createdAt,
    this.userId,
    this.id,
  });

  // Convert this model to a Map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'gender': gender,
      'createdAt': createdAt,
      'id': id,
    };
  }

  // Factory constructor to create from a Map
  factory ContactinfoModel.fromJson(Map<String, dynamic> json) {
    return ContactinfoModel(
      name: json['name'],
      createdAt: json['createdAt'],
      userId: json['userId'], // Change 'userId' to 'user_id'
      email: json['email'],
      gender: json['gender'],
      id: json['contact_id'],


    );
  }
}
