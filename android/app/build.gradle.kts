plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Required for Firebase
}

android {
    namespace = "com.example.expensease"
    compileSdk = 35
    ndkVersion = "29.0.13599879"

    defaultConfig {
        applicationId = "com.example.expensease"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true // ✅ Useful for Firebase if hitting method limit
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true // ✅ Required for java.time support
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        viewBinding = true
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.0.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.10")

    // ✅ Required for java.time APIs in older Android versions (like flutter_local_notifications)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
