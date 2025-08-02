// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    val kotlin_version by extra("1.9.22")

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0") // Android Gradle Plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version") // Kotlin plugin
        classpath("com.google.gms:google-services:4.3.15") // Google Services plugin for Firebase
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set Kotlin JVM target properly
tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions {
        jvmTarget = "17"
    }
}

// Custom build directory settings (optional)
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    project.layout.buildDirectory.set(newBuildDir.dir(project.name))
    evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
