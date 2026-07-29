part of "../../flutter_idv.dart";

class SendDataConfig {
  String _sessionId;
  String _step;
  Map<String, dynamic> _data;

  SendDataConfig(String sessionId, String step, Map<String, dynamic> data)
      : _sessionId = sessionId,
        _step = step,
        _data = data;

  @visibleForTesting
  static SendDataConfig? fromJson(json) {
    if (json == null) return null;

    var result = SendDataConfig(
      json["sessionId"],
      json["step"],
      json["data"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "sessionId": _sessionId,
        "step": _step,
        "data": _data,
      }.clearNulls();
}
