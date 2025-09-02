part of "../../flutter_idv.dart";

class InitConfig {
  /// The license binary file.
  ByteData get license => _license;
  ByteData _license;

  InitConfig(ByteData license) : _license = license;

  @visibleForTesting
  static InitConfig? fromJson(jsonObject) {
    if (jsonObject == null) return null;

    var result = InitConfig(_dataFromBase64(jsonObject["license"])!);

    return result;
  }

  @visibleForTesting
  Map<String, dynamic> toJson() =>
      {"license": _dataToBase64(license)}.clearNulls();
}
