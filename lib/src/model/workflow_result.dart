part of "../../flutter_idv.dart";

class WorkflowResult {
  String get sessionId => _sessionId;
  String _sessionId;

  WorkflowStep get finalStep => _finalStep;
  WorkflowStep _finalStep;

  WorkflowResult._(this._sessionId, this._finalStep);

  @visibleForTesting
  static WorkflowResult? fromJson(json) {
    if (json == null) return null;

    var result = WorkflowResult._(json["sessionId"], WorkflowStep.fromJson(json["finalStep"])!);

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "sessionId": _sessionId,
        "finalStep": _finalStep.toJson(),
      }.clearNulls();
}
