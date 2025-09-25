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

part 'src/config/credentials_connection_config.dart';
part 'src/config/token_connection_config.dart';
part 'src/config/api_key_connection_config.dart';
part 'src/config/prepare_workflow_config.dart';
part 'src/config/start_workflow_config.dart';

part 'src/model/workflow.dart';
part 'src/model/workflow_step.dart';
part 'src/model/workflow_result.dart';

/// Entry point of the Regula IDV.
class IDV {
  IDV._privateConstructor();

  /// The only instance of singleton class [IDV].
  static IDV get instance => _instance;
  static final IDV _instance = IDV._privateConstructor();

  void setListener({
    void Function()? didStartSession,
    void Function()? didEndSession,
    void Function()? didStartRestoreSession,
    void Function()? didContinueRemoteSession,
  }) {
    _setDidStartSessionCompletion(didStartSession);
    _setDidEndSessionCompletion(didEndSession);
    _setDidStartRestoreSessionCompletion(didStartRestoreSession);
    _setDidContinueRemoteSessionCompletion(didContinueRemoteSession);
  }

  set sessionRestoreMode(SessionRestoreMode val) {
    _bridge.invokeMethod("setSessionRestoreMode", [val.value]);
  }

  Future<String?> getCurrentSessionId() async {
    return await _bridge.invokeMethod("getCurrentSessionId", []);
  }

  Future<(bool success, String? error)> initialize() async {
    var response = await _bridge.invokeMethod("initialize", []);
    return _completionFromJson(response) as (bool, String?);
  }

  Future<(bool success, String? error)> deinitialize() async {
    var response = await _bridge.invokeMethod("deinitialize", []);
    return _completionFromJson(response) as (bool, String?);
  }

  Future<(List<String>? workflowIds, String? error)> configureWithToken(
    TokenConnectionConfig config,
  ) async {
    var response = await _bridge.invokeMethod(
      "configureWithToken",
      [config.toJson()],
    );
    return _completionFromJson(
      response,
      fromJson: (json) => (json as List<dynamic>?)?.cast<String>(),
    );
  }

  Future<(bool success, String? error)> configureWithCredentials(
    CredentialsConnectionConfig config,
  ) async {
    var response = await _bridge.invokeMethod(
      "configureWithCredentials",
      [config.toJson()],
    );
    return _completionFromJson(response) as (bool, String?);
  }

  Future<(bool success, String? error)> configureWithApiKey(
      ApiKeyConnectionConfig config) async {
    var response = await _bridge.invokeMethod(
      "configureWithApiKey",
      [config.toJson()],
    );
    return _completionFromJson(response) as (bool, String?);
  }

  Future<(Workflow? workflow, String? error)> prepareWorkflow(
    PrepareWorkflowConfig config,
  ) async {
    var response = await _bridge.invokeMethod(
      "prepareWorkflow",
      [config.toJson()],
    );
    return _completionFromJson(response, fromJson: Workflow.fromJson);
  }

  Future<(WorkflowResult? result, String? error)> startWorkflow({
    StartWorkflowConfig? config,
  }) async {
    var response = await _bridge.invokeMethod(
      "startWorkflow",
      [config?.toJson()],
    );
    return _completionFromJson(response, fromJson: WorkflowResult.fromJson);
  }

  Future<(List<Workflow>? workflows, String? error)> getWorkflows() async {
    var response = await _bridge.invokeMethod("getWorkflows", []);
    return _completionFromJson(
      response,
      fromJson: (json) => (json as List<dynamic>)
          .map((item) => Workflow.fromJson(item)!)
          .toList(),
    );
  }

  (T? success, String? error) _completionFromJson<T>(
    String jsonString, {
    T? Function(dynamic)? fromJson,
  }) {
    var json = _decode(jsonString);
    var success = json["success"];
    var error = json["error"];
    if (success != null && fromJson != null) success = fromJson(success);
    return (success as T?, error);
  }
}

enum SessionRestoreMode {
  ENABLED(0),

  DISABLED(1);

  const SessionRestoreMode(this.value);
  final int value;

  static SessionRestoreMode? getByValue(int? i) {
    if (i == null) return null;
    try {
      return SessionRestoreMode.values.firstWhere((x) => x.value == i);
    } catch (_) {
      return null;
    }
  }
}
