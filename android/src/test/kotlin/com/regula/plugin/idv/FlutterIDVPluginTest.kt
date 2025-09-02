package com.regula.plugin.idv

import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(shadows = [MyShadowBitmap::class, MyShadowDrawable::class, MyShadowBitmapDrawable::class])
class FlutterIDVPluginTest {

    // Config ------------------------------

    @Test
    fun connectionConfig() = compare("connectionConfig", ::connectionConfigFromJSON, ::generateConnectionConfig)

    @Test
    fun urlConnectionConfig() = compare("urlConnectionConfig", ::urlConnectionConfigFromJSON, ::generateUrlConnectionConfig)

    @Test
    fun apiKeyConnectionConfig() = compare("apiKeyConnectionConfig", ::apiKeyConnectionConfigFromJSON, ::generateApiKeyConnectionConfig)

    @Test
    fun prepareWorkflowConfig() = compare("prepareWorkflowConfig", ::prepareWorkflowConfigFromJSON, ::generatePrepareWorkflowConfig)

    @Test
    fun startWorkflowConfig() = compare("startWorkflowConfig", ::startWorkflowConfigFromJSON, ::generateStartWorkflowConfig)

    // Model ------------------------------

    @Test
    fun workflowModel() = compare("workflowModel", ::workflowModelFromJSON, ::generateWorkflowModel)

    @Test
    fun workflowStepModel() = compare("workflowStepModel", ::workflowStepModelFromJSON, ::generateWorkflowStepModel)

    @Test
    fun sessionResult() = compare("sessionResult", ::sessionResultFromJSON, ::generateSessionResult)
}
