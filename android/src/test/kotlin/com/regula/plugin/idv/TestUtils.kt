package com.regula.plugin.idv

import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import org.json.JSONArray
import org.json.JSONObject
import org.skyscreamer.jsonassert.JSONAssert
import java.io.IOException
import java.nio.file.Files
import java.nio.file.Paths
import java.util.Base64

fun readFile(name: String): JSONObject {
    val bytes = Files.readAllBytes(Paths.get("../test/json/$name.json"))
    return JSONObject(String(bytes))
}

fun compareJSONs(name: String, expected: JSONObject, actual: JSONObject) =
    try {
        JSONAssert.assertEquals(expected, actual, false)
    } catch (e: Throwable) {
        println("\nAndroid test failed: $name")
        println(" Expected JSON:\n$expected")
        println(" Actual JSON:\n$actual")
        throw e
    }

fun <T> compareSingle(
    name: String,
    fromJson: (JSONObject) -> T,
    toJson: (T) -> JSONObject?,
    vararg omit: String
) {
    try {
        var expected = readFile(name)
        for (key in omit) expected = omitDeep(expected, key.split("."), 0)
        val actual = toJson(fromJson(expected))!!
        compareJSONs(name, expected, actual)
    } catch (_: IOException) {
    }
}

fun <T> compare(
    name: String,
    fromJson: (JSONObject) -> T,
    toJson: (T) -> JSONObject?,
    vararg omit: String
) {
    compareSingle(name, fromJson, toJson, *omit)
    compareSingle(name + "Nullable", fromJson, toJson, *omit)
}

fun omitDeep(dict: JSONObject, path: List<String>, index: Int): JSONObject {
    if (index < path.size - 1) {
        if (!dict.has(path[index]))
            return dict // in this case its probably trying to omit in nullability test
        val node = dict.get(path[index])
        if (node is JSONObject)
            dict.put(path[index], omitDeep(node, path, index + 1))
        else if (node is JSONArray)
            dict.put(path[index], omitDeep(node, path, index + 1))
    } else
        dict.remove(path[index])
    return dict
}

fun omitDeep(dict: JSONArray, path: List<String>, index: Int): JSONArray {
    for (i in 0 until dict.length())
        dict.put(i, omitDeep(dict.getJSONObject(i), path, index))
    return dict
}
