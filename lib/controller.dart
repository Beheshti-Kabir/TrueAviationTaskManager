class LogInResponse {
  final String accessToken;
  final String result;

  LogInResponse({
    required this.accessToken,
    required this.result,
  });

  factory LogInResponse.fromJson(Map<String, dynamic> json) {
    return LogInResponse(
        accessToken: json["accessToken"] != null ? json["accessToken"] : "",
        result: json["result"] != null ? json["result"] : "");
  }
}

class LogInRequest {
  String email;
  String password;

  LogInRequest({
    required this.email,
    required this.password,
  });
  Map<String, dynamic> ToJson() {
    Map<String, dynamic> map = {
      'username': email.trim(),
      'password': password.trim(),
    };

    return map;
  }
}
