part of "../../flutter_idv.dart";

class WorkflowStep {
  String get id => _id;
  String _id;

  String get name => _name;
  String _name;

  WorkflowStep._(
    this._id,
    this._name,
  );

  @visibleForTesting
  static WorkflowStep? fromJson(json) {
    if (json == null) return null;

    var result = WorkflowStep._(
      json["id"],
      json["name"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "id": _id,
        "name": _name,
      }.clearNulls();
}
