package com.regula.plugin.idv

import org.junit.Test

class FlutterIDVPluginTest {

    // Config ------------------------------

    @Test
    fun credentialsConnectionConfig() = compare("credentialsConnectionConfig", ::credentialsConnectionConfigFromJSON, ::generateCredentialsConnectionConfig)

    @Test
    fun tokenConnectionConfig() = compare("tokenConnectionConfig", ::tokenConnectionConfigFromJSON, ::generateTokenConnectionConfig)

    @Test
    fun apiKeyConnectionConfig() = compare("apiKeyConnectionConfig", ::apiKeyConnectionConfigFromJSON, ::generateApiKeyConnectionConfig)

    @Test
    fun prepareWorkflowConfig() = compare("prepareWorkflowConfig", ::prepareWorkflowConfigFromJSON, ::generatePrepareWorkflowConfig)

    @Test
    fun startWorkflowConfig() = compare("startWorkflowConfig", ::startWorkflowConfigFromJSON, ::generateStartWorkflowConfig)

    // Model ------------------------------

    @Test
    fun workflow() = compare("workflow", ::workflowFromJSON, ::generateWorkflow)

    @Test
    fun workflowStep() = compare("workflowStep", ::workflowStepFromJSON, ::generateWorkflowStep)

    @Test
    fun workflowResult() = compare("workflowResult", ::workflowResultFromJSON, ::generateWorkflowResult)
}
