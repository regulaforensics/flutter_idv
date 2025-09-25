part of "../../flutter_idv.dart";

class CredentialsConnectionConfig {
  String _baseUrl;
  String _userName;
  String _password;
  int? _httpTimeoutMs;

  CredentialsConnectionConfig(
    String baseUrl,
    String userName,
    String password, {
    int? httpTimeoutMs,
  })  : _baseUrl = baseUrl,
        _userName = userName,
        _password = password,
        _httpTimeoutMs = httpTimeoutMs;

  @visibleForTesting
  static CredentialsConnectionConfig? fromJson(json) {
    if (json == null) return null;

    var result = CredentialsConnectionConfig(
      json["baseUrl"],
      json["userName"],
      json["password"],
      httpTimeoutMs: json["httpTimeoutMs"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "baseUrl": _baseUrl,
        "userName": _userName,
        "password": _password,
        "httpTimeoutMs": _httpTimeoutMs,
      }.clearNulls();
}
