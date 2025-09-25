@file:Suppress("unused")

package com.regula.plugin.idv

import com.regula.idv.api.config.ApiKeyConnectionConfig
import com.regula.idv.api.config.CredentialsConnectionConfig
import com.regula.idv.api.config.PrepareWorkflowConfig
import com.regula.idv.api.config.StartWorkflowConfig
import com.regula.idv.api.config.TokenConnectionConfig
import com.regula.idv.api.models.WorkflowResult
import com.regula.idv.api.models.Workflow
import com.regula.idv.api.models.WorkflowStep
import com.regula.idv.module.BaseException
import org.json.JSONObject

fun generateCompletion(success: Any?, error: BaseException?) = mapOf(
    "success" to success,
    "error" to error?.message
).toJson()

// Config ------------------------------

fun credentialsConnectionConfigFromJSON(it: JSONObject) = CredentialsConnectionConfig(
    it.getString("baseUrl"),
    it.getString("userName"),
    it.getString("password")
).let { self ->
    self.httpTimeoutMs = it.getIntOrNull("httpTimeoutMs")
    return@let self
}

fun generateCredentialsConnectionConfig(it: CredentialsConnectionConfig) = mapOf(
    "baseUrl" to it.baseUrl,
    "userName" to it.userName,
    "password" to it.password,
    "httpTimeoutMs" to it.httpTimeoutMs,
).toJson()

fun tokenConnectionConfigFromJSON(it: JSONObject) = TokenConnectionConfig(
    it.getString("url")
)

fun generateTokenConnectionConfig(it: TokenConnectionConfig) = mapOf(
    "url" to it.baseUrl,
).toJson()

fun apiKeyConnectionConfigFromJSON(it: JSONObject) = ApiKeyConnectionConfig(
    it.getString("baseUrl"),
    it.getString("apiKey"),
    it.getIntOrNull("ttl"),
).let { self ->
    self.httpTimeoutMs = it.getIntOrNull("httpTimeoutMs")
    return@let self
}

fun generateApiKeyConnectionConfig(it: ApiKeyConnectionConfig) = mapOf(
    "baseUrl" to it.baseUrl,
    "apiKey" to it.apiKey,
    "ttl" to it.ttl,
    "httpTimeoutMs" to it.httpTimeoutMs,
).toJson()

fun prepareWorkflowConfigFromJSON(it: JSONObject) = PrepareWorkflowConfig(
    it.getString("workflowId"),
)

fun generatePrepareWorkflowConfig(it: PrepareWorkflowConfig) = mapOf(
    "workflowId" to it.workflowId,
).toJson()

fun startWorkflowConfigFromJSON(input: JSONObject?) = input?.let { json ->
    val builder = StartWorkflowConfig.Builder()

    json.getStringOrNull("locale")?.let { builder.setLocale(it) }
    json.getJSONObjectOrNull("metadata")?.let { builder.setMetadata(it) }

    builder.build()
}

fun generateStartWorkflowConfig(input: StartWorkflowConfig?) = input?.let {
    mapOf(
        "locale" to it.locale,
        "metadata" to it.metadata,
    ).toJson()
}

// Model ------------------------------

fun workflowFromJSON(input: JSONObject?) = input?.let {
    Workflow(
        it.getString("id"),
        it.getString("name"),
        it.getString("version"),
        it.getString("description"),
        it.getStringOrNull("defaultLocale"),
    )
}

fun generateWorkflow(input: Workflow?) = input?.let {
    mapOf(
        "id" to it.id,
        "name" to it.name,
        "version" to it.version,
        "description" to it.description,
        "defaultLocale" to it.defaultLocale,
    ).toJson()
}

fun workflowStepFromJSON(input: JSONObject?) = input?.let {
    WorkflowStep(
        it.getString("id"),
        it.getString("name"),
    )
}

fun generateWorkflowStep(input: WorkflowStep?) = input?.let {
    mapOf(
        "id" to it.id,
        "name" to it.name,
    ).toJson()
}

fun workflowResultFromJSON(input: JSONObject?): WorkflowResult? = input?.let {
    WorkflowResult(
        it.getString("sessionId"),
        workflowStepFromJSON(it.getJSONObjectOrNull("finalStep"))!!
    )
}

fun generateWorkflowResult(input: WorkflowResult?) = input?.let {
    mapOf(
        "sessionId" to it.sessionId,
        "finalStep" to generateWorkflowStep(it.finalStep),
    ).toJson()
}
