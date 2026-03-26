part of "../../flutter_idv.dart";

class TokenConnectionConfig {
  String _url;

  TokenConnectionConfig(
    String url,
  ) : _url = url;

  @visibleForTesting
  static TokenConnectionConfig? fromJson(json) {
    if (json == null) return null;

    var result = TokenConnectionConfig(
      json["url"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "url": _url,
      }.clearNulls();
}
