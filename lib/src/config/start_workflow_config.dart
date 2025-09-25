part of "../../flutter_idv.dart";

class StartWorkflowConfig {
  String? _locale;
  Map<String, dynamic>? _metadata;

  StartWorkflowConfig({
    String? locale,
    Map<String, dynamic>? metadata,
  })  : _locale = locale,
        _metadata = metadata;

  @visibleForTesting
  static StartWorkflowConfig? fromJson(json) {
    if (json == null) return null;

    var result = StartWorkflowConfig(
      locale: json["locale"],
      metadata: json["metadata"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "locale": _locale,
        "metadata": _metadata,
      }.clearNulls();
}
