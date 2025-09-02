package com.regula.plugin.idv

import com.regula.idv.api.IdvSdk.Companion.instance
import com.regula.idv.api.config.IdvInitConfig
import com.regula.idv.api.enums.SessionRestoreMode
import com.regula.idv.api.listeners.IdvSdkListener
import com.regula.idv.module.BaseException
import com.regula.idv.module.IModule
import org.json.JSONObject

fun methodCall(method: String, callback: Callback): Any = when (method) {
    "getIsInitialized" -> callback(instance().isInitialized())
    "getCurrentSessionId" -> callback(instance().currentSessionId())
    "getSessionRestoreMode" -> callback(instance().sessionRestoreMode.ordinal)
    "setSessionRestoreMode" -> instance().sessionRestoreMode = SessionRestoreMode.entries[args(0)]
    "initialize" -> initialize(callback)
    "configureWithConnectionConfig" -> configureWithConnectionConfig(callback, args(0))
    "configureWithUrlConnectionConfig" -> configureWithUrlConnectionConfig(callback, args(0))
    "configureWithApiKeyConnectionConfig" -> configureWithApiKeyConnectionConfig(callback, args(0))
    "deinitialize" -> instance().deinitialize(context)
    "prepareWorkflow" -> prepareWorkflow(callback, args(0))
    "getWorkflows" -> getWorkflows(callback)
    "startWorkflow" -> startWorkflow(callback, args(0))
    else -> Unit
}

inline fun <reified T> args(index: Int) = argsNullable<T>(index)!!
typealias Callback = (Any?) -> Unit

const val didStartSessionEvent = "didStartSessionEvent"
const val didEndSessionEvent = "didEndSessionEvent"
const val didStartRestoreSessionEvent = "didStartRestoreSessionEvent"
const val didContinueRemoteSessionEvent = "didContinueRemoteSessionEvent"

val allModules = listOf(
    "com.regula.idv.docreader.DocReaderModule",
    "com.regula.idv.face.FaceModule",
)

fun initialize(callback: Callback) {
    val includedModules = mutableListOf<IModule>()
    for (className in allModules) {
        try {
            val targetClass = Class.forName(className)
            includedModules.add(targetClass.getDeclaredConstructor().newInstance() as IModule)
        } catch (_: Exception) {
        }
    }

    println("Connected modules: ${includedModules.size}") // TODO remove this line

    instance().initialize(context, IdvInitConfig(includedModules)) {
        instance().listener = object : IdvSdkListener {
            override fun didStartSession() = sendEvent(didStartSessionEvent)
            override fun didEndSession() = sendEvent(didEndSessionEvent)
            override fun didStartRestoreSession() = sendEvent(didStartRestoreSessionEvent)
            override fun didContinueRemoteSession() = sendEvent(didContinueRemoteSessionEvent)
        }
        generateCompletion(
            it.isSuccess,
            null,
            it.exceptionOrNull() as BaseException?
        ).send(callback)
    }
}

fun configureWithConnectionConfig(callback: Callback, data: JSONObject) = instance().configure(
    context,
    connectionConfigFromJSON(data)
) {
    generateCompletion(
        it.isSuccess,
        null,
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun configureWithUrlConnectionConfig(callback: Callback, data: JSONObject) = instance().configure(
    context,
    urlConnectionConfigFromJSON(data)
) {
    generateCompletion(
        it.isSuccess,
        it.getOrNull(),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun configureWithApiKeyConnectionConfig(callback: Callback, data: JSONObject) = instance().configure(
    context,
    apiKeyConnectionConfigFromJSON(data)
) {
    generateCompletion(
        it.isSuccess,
        it.getOrNull(),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun prepareWorkflow(callback: Callback, data: JSONObject) = instance().prepareWorkflow(
    context,
    prepareWorkflowConfigFromJSON(data)
) {
    generateCompletion(
        it.isSuccess,
        generateWorkflowModel(it.getOrNull()),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun getWorkflows(callback: Callback) = instance().getWorkflows {
    generateCompletion(
        it.isSuccess,
        it.getOrNull().toJsonNullable(::generateWorkflowModel),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun startWorkflow(callback: Callback, data: JSONObject?) = instance().startWorkflow(
    context,
    startWorkflowConfigFromJSON(data)
) { value, error ->
    generateCompletion(
        error == null,
        generateSessionResult(value),
        error
    ).send(callback)
}
