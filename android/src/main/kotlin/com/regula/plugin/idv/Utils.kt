package com.regula.plugin.idv

import org.json.JSONArray
import org.json.JSONObject

inline fun <reified T> args(index: Int) = argsNullable<T>(index)!!
typealias Callback = (Any?) -> Unit

fun List<*>.toJson(): JSONArray {
    val result = JSONArray()
    for (i in indices)
        when (val v = this[i]) {
            null -> result.put(null)
            is Map<*, *> -> result.put(v.toJson())
            is List<*> -> result.put(v.toJson())
            else -> result.put(v)
        }
    return result
}

fun Map<*, *>.toJson(): JSONObject {
    val result = JSONObject()
    for ((k, v) in this) {
        when (v) {
            null -> result.put(k as String, null)
            is Map<*, *> -> result.put(k as String, v.toJson())
            is List<*> -> result.put(k as String, v.toJson())
            else -> result.put(k as String, v)
        }
    }
    return result
}

fun Any?.toSendable(): Any? = this?.let {
    if (it is JSONObject || it is JSONArray) it.toString()
    else it
}

fun JSONObject.send(callback: Callback) = callback(this)

fun <T> List<T>?.toJsonNullable(toJson: (T?) -> Any?) = this?.let {
    val result = JSONArray()
    for (item in it) result.put(toJson(item))
    result
}

fun JSONObject.getJSONObjectOrNull(name: String): JSONObject? {
    if (has(name) && get(name).toString() != "null") return getJSONObject(name)
    return null
}

fun JSONObject.getStringOrNull(name: String): String? {
    if (has(name) && get(name).toString() != "null") return getString(name)
    return null
}

fun JSONObject.getIntOrNull(name: String): Int? {
    if (has(name) && get(name).toString() != "null") return getInt(name)
    return null
}
