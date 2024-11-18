class Session {
  final String token;
  final String role;

  Session({required this.token, required this.role});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      token: json['token'],
      role: json['role'],
    );
  }
}
