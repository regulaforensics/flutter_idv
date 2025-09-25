part of "../../flutter_idv.dart";

class Workflow {
  String get id => _id;
  String _id;

  String get name => _name;
  String _name;

  String get description => _description;
  String _description;

  String get version => _version;
  String _version;

  String? get defaultLocale => _defaultLocale;
  String? _defaultLocale;

  Workflow._(
    this._id,
    this._name,
    this._description,
    this._version,
    this._defaultLocale,
  );

  @visibleForTesting
  static Workflow? fromJson(json) {
    if (json == null) return null;

    var result = Workflow._(
      json["id"],
      json["name"],
      json["description"],
      json["version"],
      json["defaultLocale"],
    );

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => {
        "id": _id,
        "name": _name,
        "description": _description,
        "version": _version,
        "defaultLocale": _defaultLocale,
      }.clearNulls();
}
