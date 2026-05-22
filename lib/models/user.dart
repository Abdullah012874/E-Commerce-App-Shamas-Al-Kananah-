class AppUser {
  final String id;
  final String firstName;
  final String secondName;
  final String phone;
  final String email;
  final String role; // 'admin' or 'user'

  AppUser({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.phone,
    required this.email,
    this.role = 'user',
  });

  String get fullName => '$firstName $secondName';
  bool get isAdmin => role == 'admin';
}

