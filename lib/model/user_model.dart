class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? country;
  final String? profileImage;
  final String? role;
  final String? status;
  final String aboutUs;
  final String dateOfBirth;
  final String gender;
  final bool isCompleteProfile;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.country,
    this.profileImage,
    this.role,
    this.status,
    this.aboutUs = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.isCompleteProfile = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      country: json['country'],
      profileImage: json['profileImage'],
      role: json['role'],
      status: json['status'],
      aboutUs: json['aboutUs'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
      isCompleteProfile: json['isCompleteProfile'] ?? false,
    );
  }
}