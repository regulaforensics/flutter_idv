part of "../../flutter_idv.dart";

class PrepareWorkflowConfig {
  String _workflowId;

  PrepareWorkflowConfig(
    String workflowId,
  ) : _workflowId = workflowId;

  @visibleForTesting
  static PrepareWorkflowConfig? fromJson(json) {
    if (json == null) return null;

    var result = PrepareWorkflowConfig(
      json["workflowId"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "workflowId": _workflowId,
      }.clearNulls();
}
