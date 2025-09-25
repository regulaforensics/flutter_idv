import 'package:flutter_idv/flutter_idv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'json.dart';
import 'utils.dart';

void main() {
  group("IDV", () {
    compare(
      'credentialsConnectionConfig',
      credentialsConnectionConfig,
      CredentialsConnectionConfig.fromJson,
    );
    compare(
      'tokenConnectionConfig',
      tokenConnectionConfig,
      TokenConnectionConfig.fromJson,
    );
    compare(
      'apiKeyConnectionConfig',
      apiKeyConnectionConfig,
      ApiKeyConnectionConfig.fromJson,
    );
    compare(
      'prepareWorkflowConfig',
      prepareWorkflowConfig,
      PrepareWorkflowConfig.fromJson,
    );
    compare(
      'startWorkflowConfig',
      startWorkflowConfig,
      StartWorkflowConfig.fromJson,
    );

    compare('workflow', workflow, Workflow.fromJson);
    compare('workflowStep', workflowStep, WorkflowStep.fromJson);
    compare('workflowResult', workflowResult, WorkflowResult.fromJson);
  });
}
