part of "../../flutter_idv.dart";

class StartSessionConfig {
  String _workflowId;
  Map<String, dynamic>? _metadata;

  StartSessionConfig(String workflowId, {Map<String, dynamic>? metadata})
      : _workflowId = workflowId,
        _metadata = metadata;

  @visibleForTesting
  static StartSessionConfig? fromJson(json) {
    if (json == null) return null;

    var result = StartSessionConfig(
      json["workflowId"],
      metadata: json["metadata"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "workflowId": _workflowId,
        "metadata": _metadata,
      }.clearNulls();
}
