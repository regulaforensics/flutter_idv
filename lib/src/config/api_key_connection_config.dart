part of "../../flutter_idv.dart";

class ApiKeyConnectionConfig {
  String _baseUrl;
  String _apiKey;
  int? _ttl;
  int? _httpTimeoutMs;

  ApiKeyConnectionConfig(
    String baseUrl,
    String apiKey, {
    int? ttl,
    int? httpTimeoutMs,
  })  : _baseUrl = baseUrl,
        _apiKey = apiKey,
        _ttl = ttl,
        _httpTimeoutMs = httpTimeoutMs;

  @visibleForTesting
  static ApiKeyConnectionConfig? fromJson(json) {
    if (json == null) return null;

    var result = ApiKeyConnectionConfig(
      json["baseUrl"],
      json["apiKey"],
      ttl: json["ttl"],
      httpTimeoutMs: json["httpTimeoutMs"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "baseUrl": _baseUrl,
        "apiKey": _apiKey,
        "ttl": _ttl,
        "httpTimeoutMs": _httpTimeoutMs,
      }.clearNulls();
}
