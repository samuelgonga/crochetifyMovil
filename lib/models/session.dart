class Session {
  final String token;

  Session({required this.token});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(token: json['token']);
  }
}
