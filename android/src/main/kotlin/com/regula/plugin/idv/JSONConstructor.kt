@file:Suppress("unused")

package com.regula.plugin.idv

import com.regula.idv.api.config.IdvApiKeyConnectionConfig
import com.regula.idv.api.config.IdvConnectionConfig
import com.regula.idv.api.config.IdvPrepareWorkflowConfig
import com.regula.idv.api.config.IdvStartWorkflowConfig
import com.regula.idv.api.config.IdvUrlConnectionConfig
import com.regula.idv.api.models.IdvWorkflowModel
import com.regula.idv.api.models.IdvWorkflowStepModel
import com.regula.idv.api.models.SessionResult
import com.regula.idv.module.BaseException
import org.json.JSONObject

fun generateCompletion(success: Boolean, value: Any?, error: BaseException?) = mapOf(
    "success" to success,
    "value" to value,
    "errorMessage" to error?.message
).toJson()

// Config ------------------------------

fun connectionConfigFromJSON(it: JSONObject) = IdvConnectionConfig(
    it.getString("url"),
    it.getString("userName"),
    it.getString("password")
)

fun generateConnectionConfig(it: IdvConnectionConfig) = mapOf(
    "url" to it.url,
    "userName" to it.userName,
    "password" to it.password,
).toJson()

fun urlConnectionConfigFromJSON(it: JSONObject) = IdvUrlConnectionConfig(
    it.getString("url")
)

fun generateUrlConnectionConfig(it: IdvUrlConnectionConfig) = mapOf(
    "url" to it.url,
).toJson()

fun apiKeyConnectionConfigFromJSON(it: JSONObject) = IdvApiKeyConnectionConfig(
    it.getString("url"),
    it.getString("apiKey"),
)

fun generateApiKeyConnectionConfig(it: IdvApiKeyConnectionConfig) = mapOf(
    "url" to it.url,
    "apiKey" to it.apiKey,
).toJson()

fun prepareWorkflowConfigFromJSON(it: JSONObject) = IdvPrepareWorkflowConfig(
    it.getString("workflowId"),
)

fun generatePrepareWorkflowConfig(it: IdvPrepareWorkflowConfig) = mapOf(
    "workflowId" to it.workflowId,
).toJson()

fun startWorkflowConfigFromJSON(input: JSONObject?) = input?.let { json ->
    val builder = IdvStartWorkflowConfig.Builder()

    json.getStringOrNull("locale")?.let { builder.setLocale(it) }
    json.getJSONObjectOrNull("metadata")?.let { builder.setMetadata(it) }

    builder.build()
}

fun generateStartWorkflowConfig(input: IdvStartWorkflowConfig?) = input?.let {
    mapOf(
        "locale" to it.locale,
        "metadata" to it.metadata,
    ).toJson()
}

// Misc ------------------------------

fun workflowModelFromJSON(input: JSONObject?) = input?.let {
    IdvWorkflowModel(
        it.getString("id"),
        it.getString("name"),
        it.getString("version"),
        it.getString("description"),
        it.getString("defaultLocale"),
    )
}

fun generateWorkflowModel(input: IdvWorkflowModel?) = input?.let {
    mapOf(
        "id" to it.id,
        "name" to it.name,
        "version" to it.version,
        "description" to it.description,
        "defaultLocale" to it.defaultLocale,
    ).toJson()
}

fun workflowStepModelFromJSON(input: JSONObject?) = input?.let {
    IdvWorkflowStepModel(
        it.getString("id"),
        it.getString("name"),
    )
}

fun generateWorkflowStepModel(input: IdvWorkflowStepModel?) = input?.let {
    mapOf(
        "id" to it.id,
        "name" to it.name,
    ).toJson()
}

fun sessionResultFromJSON(it: JSONObject): SessionResult {
    val result = SessionResult()

    result.transactionId = it.getStringOrNull("transactionId")
    result.finalStep = workflowStepModelFromJSON(it.getJSONObjectOrNull("finalStep"))

    return result
}

fun generateSessionResult(it: SessionResult) = mapOf(
    "transactionId" to it.transactionId,
    "finalStep" to generateWorkflowStepModel(it.finalStep),
).toJson()
