part of "../../flutter_idv.dart";

class WorkflowResult {
  String get sessionId => _sessionId;
  String _sessionId;

  WorkflowStep get finalStep => _finalStep;
  WorkflowStep _finalStep;

  WorkflowResult(
    String sessionId,
    WorkflowStep finalStep,
  )   : _sessionId = sessionId,
        _finalStep = finalStep;

  @visibleForTesting
  static WorkflowResult? fromJson(json) {
    if (json == null) return null;

    var result = WorkflowResult(
      json["sessionId"],
      WorkflowStep.fromJson(json["finalStep"])!,
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "sessionId": _sessionId,
        "finalStep": _finalStep.toJson(),
      }.clearNulls();
}
