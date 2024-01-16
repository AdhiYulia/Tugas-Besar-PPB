class UserLogin {
  final String? idUser;
  final String? email;
  final String? name;
  final bool? isAdmin;

  UserLogin({
    this.idUser,
    this.email,
    this.name,
    this.isAdmin,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      idUser: json['idUser'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      isAdmin: json['isAdmin'] as bool?,
    );
  }
}
