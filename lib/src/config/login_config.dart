part of "../../flutter_idv.dart";

class LoginConfig {
  String _applicationId;
  String _baseUrl;
  String? _locale;
  Map<String, dynamic>? _metadata;
  int? _httpTimeoutMs;

  LoginConfig(
    String applicationId,
    String baseUrl, {
    String? locale,
    Map<String, dynamic>? metadata,
    int? httpTimeoutMs,
  })  : _applicationId = applicationId,
        _baseUrl = baseUrl,
        _locale = locale,
        _metadata = metadata,
        _httpTimeoutMs = httpTimeoutMs;

  @visibleForTesting
  static LoginConfig? fromJson(json) {
    if (json == null) return null;

    var result = LoginConfig(
      json["applicationId"],
      json["baseUrl"],
      locale: json["locale"],
      metadata: json["metadata"],
      httpTimeoutMs: json["httpTimeoutMs"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "applicationId": _applicationId,
        "baseUrl": _baseUrl,
        "locale": _locale,
        "metadata": _metadata,
        "httpTimeoutMs": _httpTimeoutMs,
      }.clearNulls();
}
