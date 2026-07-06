package com.regula.plugin.idv

import com.regula.idv.api.IdvSdk.Companion.instance
import com.regula.idv.api.config.InitConfig
import com.regula.idv.api.enums.SessionRestoreMode
import com.regula.idv.api.listeners.IdvSdkListener
import com.regula.idv.module.BaseException
import com.regula.idv.module.IModule
import com.regula.idv.module.enums.IdvLogLevel
import org.json.JSONArray
import org.json.JSONObject

const val didStartSessionEvent = "didStartSessionEvent"
const val didEndSessionEvent = "didEndSessionEvent"
const val didStartRestoreSessionEvent = "didStartRestoreSessionEvent"
const val didContinueRemoteSessionEvent = "didContinueRemoteSessionEvent"
const val didReceiveLogEventEvent = "didReceiveLogEventEvent"

val allModules = listOf(
    "com.regula.idv.docreader.DocReaderModule",
    "com.regula.idv.face.FaceModule",
)

fun methodCall(method: String, callback: Callback): Any = when (method) {
    "setSessionRestoreMode" -> instance().sessionRestoreMode = SessionRestoreMode.entries[args(0)]
    "setLogLevel" -> instance().logLevel = HashSet(args<JSONArray>(0).toList<Int>().map { IdvLogLevel.entries[it] })
    "getCurrentSessionId" -> callback(instance().currentSessionId())
    "initialize" -> initialize(callback)
    "deinitialize" -> deinitialize(callback)
    "configureWithToken" -> configureWithToken(callback, args(0))
    "configureWithCredentials" -> configureWithCredentials(callback, args(0))
    "configureWithApiKey" -> configureWithApiKey(callback, args(0))
    "prepareWorkflow" -> prepareWorkflow(callback, args(0))
    "startWorkflow" -> startWorkflow(callback, argsNullable(0))
    "getWorkflows" -> getWorkflows(callback)
    "startSession" -> startSession(callback, args(0))
    "sendData" -> sendData(callback, args(0))
    "startLogin" -> startLogin(callback, args(0))
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

fun deinitialize(callback: Callback) = instance().deinitialize {
    generateCompletion(
        it.isSuccess,
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun configureWithToken(callback: Callback, config: JSONObject) = instance().configure(tokenConnectionConfigFromJSON(config)) {
    generateCompletion(
        it.getOrNull(),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun configureWithCredentials(callback: Callback, config: JSONObject) = instance().configure(credentialsConnectionConfigFromJSON(config)) {
    generateCompletion(
        it.isSuccess,
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun configureWithApiKey(callback: Callback, config: JSONObject) = instance().configure(apiKeyConnectionConfigFromJSON(config)) {
    generateCompletion(
        it.isSuccess,
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun prepareWorkflow(callback: Callback, config: JSONObject) = instance().prepareWorkflow(prepareWorkflowConfigFromJSON(config)) {
    generateCompletion(
        generateWorkflow(it.getOrNull()),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun startWorkflow(callback: Callback, config: JSONObject?) = instance().startWorkflow(
    activity,
    startWorkflowConfigFromJSON(config)
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

fun startSession(callback: Callback, config: JSONObject) = instance().startSession(
    startSessionConfigFromJSON(config)!!
) {
    generateCompletion(
        it.getOrNull(),
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun sendData(callback: Callback, config: JSONObject) = instance().sendData(
    sendDataConfigFromJSON(config)!!
) {
    generateCompletion(
        it.isSuccess,
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

fun startLogin(callback: Callback, config: JSONObject) = instance().startLogin(loginConfigFromJSON(config)) {
    generateCompletion(
        it.isSuccess,
        it.exceptionOrNull() as BaseException?
    ).send(callback)
}

// Weak references
var listener = object : IdvSdkListener {
    override fun didStartSession() = sendEvent(didStartSessionEvent)
    override fun didEndSession() = sendEvent(didEndSessionEvent)
    override fun didStartRestoreSession() = sendEvent(didStartRestoreSessionEvent)
    override fun didContinueRemoteSession() = sendEvent(didContinueRemoteSessionEvent)
    override fun didReceiveLogEvent(level: IdvLogLevel, message: String) = sendEvent(didReceiveLogEventEvent, mapOf(
        "level" to level.ordinal,
        "message" to message,
    ).toJson())
}
