package com.regula.plugin.idv

import com.regula.idv.api.IdvSdk.Companion.instance
import com.regula.idv.api.config.InitConfig
import com.regula.idv.api.enums.SessionRestoreMode
import com.regula.idv.api.listeners.IdvSdkListener
import com.regula.idv.module.BaseException
import com.regula.idv.module.IModule
import org.json.JSONObject

const val didStartSessionEvent = "didStartSessionEvent"
const val didEndSessionEvent = "didEndSessionEvent"
const val didStartRestoreSessionEvent = "didStartRestoreSessionEvent"
const val didContinueRemoteSessionEvent = "didContinueRemoteSessionEvent"

val allModules = listOf(
    "com.regula.idv.docreader.DocReaderModule",
    "com.regula.idv.face.FaceModule",
)

fun methodCall(method: String, callback: Callback): Any = when (method) {
    "setSessionRestoreMode" -> instance().sessionRestoreMode = SessionRestoreMode.entries[args(0)]
    "getCurrentSessionId" -> callback(instance().currentSessionId())
    "initialize" -> initialize(callback)
    "deinitialize" -> deinitialize(callback)
    "configureWithToken" -> configureWithToken(callback, args(0))
    "configureWithCredentials" -> configureWithCredentials(callback, args(0))
    "configureWithApiKey" -> configureWithApiKey(callback, args(0))
    "prepareWorkflow" -> prepareWorkflow(callback, args(0))
    "startWorkflow" -> startWorkflow(callback, argsNullable(0))
    "getWorkflows" -> getWorkflows(callback)
    else -> Unit
}

fun initialize(callback: Callback) {
    val includedModules = mutableListOf<IModule>()
    for (className in allModules) try {
        includedModules.add(Class.forName(className).getDeclaredConstructor().newInstance() as IModule)
    } catch (_: Exception) {
    }

    instance().initialize(context, InitConfig(includedModules)) {
        instance().listener = listener
        generateCompletion(
            it.isSuccess,
            it.exceptionOrNull() as BaseException?
        ).send(callback)
    }
}

fun deinitialize(callback: Callback) {
    instance().deinitialize(context) {
        generateCompletion(
            it.isSuccess,
            it.exceptionOrNull() as BaseException?
        ).send(callback)
    }
}


fun configureWithToken(callback: Callback, data: JSONObject) = instance().configure(
    context,
    tokenConnectionConfigFromJSON(data)
) {
    generateCompletion(
        it.getOrNull(),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun configureWithCredentials(callback: Callback, data: JSONObject) = instance().configure(
    context,
    credentialsConnectionConfigFromJSON(data)
) {
    generateCompletion(
        it.isSuccess,
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun configureWithApiKey(callback: Callback, data: JSONObject) = instance().configure(
    context,
    apiKeyConnectionConfigFromJSON(data)
) {
    generateCompletion(
        it.isSuccess,
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun prepareWorkflow(callback: Callback, data: JSONObject) = instance().prepareWorkflow(
    context,
    prepareWorkflowConfigFromJSON(data)
) {
    generateCompletion(
        generateWorkflow(it.getOrNull()),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun startWorkflow(callback: Callback, data: JSONObject?) = instance().startWorkflow(
    context,
    startWorkflowConfigFromJSON(data)
) {
    generateCompletion(
        generateWorkflowResult(it.getOrNull()),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun getWorkflows(callback: Callback) = instance().getWorkflows {
    generateCompletion(
        it.getOrNull().toJsonNullable(::generateWorkflow),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

// Weak references
var listener = object : IdvSdkListener {
    override fun didStartSession() = sendEvent(didStartSessionEvent)
    override fun didEndSession() = sendEvent(didEndSessionEvent)
    override fun didStartRestoreSession() = sendEvent(didStartRestoreSessionEvent)
    override fun didContinueRemoteSession() = sendEvent(didContinueRemoteSessionEvent)
}
