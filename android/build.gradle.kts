import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.regulaforensics.com/RegulaDocumentReader/Nightly")
            isAllowInsecureProtocol = true
        }
    }
}

plugins {
    id("com.android.library")
}

val agpMajor = com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION.substringBefore('.').toInt()
val builtInKotlinEnabled = providers.gradleProperty("android.builtInKotlin").map { it.toBoolean() }.getOrElse(agpMajor >= 9)
if (agpMajor < 9 || !builtInKotlinEnabled) {
    apply(plugin = "org.jetbrains.kotlin.android")
    apply(plugin = "org.jetbrains.kotlin.kapt")
} else {
    apply(plugin = "com.android.legacy-kapt")
}

android {
    namespace = "com.regula.plugin.idv"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        minSdk = 24
    }

    buildFeatures {
        dataBinding = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.outputs.upToDateWhen { false }
                it.testLogging {
                    events("passed", "skipped", "failed", "standardOut", "standardError")
                    showStandardStreams = true
                }
            }
        }
    }
}

extensions.configure<KotlinAndroidProjectExtension> {
    compilerOptions {
        jvmTarget = JvmTarget.JVM_17
    }
}

dependencies {
    implementation("com.regula.idv:api:3.10.400") {
        isTransitive = true
    }

    testImplementation("junit:junit:4.13.2")
    testImplementation("androidx.test:core:1.7.0")
    testImplementation("org.robolectric:robolectric:4.16.1")
    testImplementation("org.json:json:20260522")
    testImplementation("org.skyscreamer:jsonassert:1.5.3")
}
