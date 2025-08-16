plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

import java.util.Properties
import java.io.FileInputStream

android {
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.simple_notes"
        minSdk = 21
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    signingConfigs {
        create("release") {
            val propertiesFile = project.rootProject.file("key.properties")
            if (propertiesFile.exists()) {
                val properties = Properties()
                FileInputStream(propertiesFile).use { inputStream ->
                    properties.load(inputStream)
                }
                keyAlias = properties.getProperty("keyAlias")
                keyPassword = properties.getProperty("keyPassword")
                storeFile = file(properties.getProperty("storeFile"))
                storePassword = properties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}

dependencies {}