/// Regula IDV
library idv;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

part 'src/internal/utils.dart';
part 'src/internal/bridge.dart';
part 'src/internal/event_channels.dart';

part 'src/init/init_config.dart';

/// Entry point of the Regula IDV.
class IDV {
  IDV._privateConstructor();

  /// The only instance of singleton class [IDV].
  static IDV get instance => _instance;
  static final IDV _instance = IDV._privateConstructor();

  /// Allows you to initialize IDV.
  ///
  /// [config] - configuration file for IDV initialization.
  ///
  /// Returns [bool] indicating success of initialization
  Future<bool> initialize(InitConfig config) async {
    var response = await _bridge.invokeMethod("initialize", [config.toJson()]);

    var jsonObject = _decode(response);
    bool success = jsonObject["success"];

    if (success) await _onInit();

    return success;
  }

  Future<void> _onInit() async {}
}
