class LoginDto {
  final String username;
  final String password;
  final String otp;

  const LoginDto({
    required this.username,
    required this.password,
    required this.otp,
  });

  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'password': password,
        'otp': otp,
      };
}
