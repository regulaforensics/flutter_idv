part of "../../flutter_idv.dart";

dynamic _decode(String? value) => value == null ? null : jsonDecode(value);

extension _ClearNulls on Map<String, dynamic> {
  Map<String, dynamic> clearNulls() {
    Map<String, dynamic> result = {};
    forEach((key, value) {
      if (value != null) result[key] = value;
    });
    return result;
  }
}
