buildscript {
    // Definindo versões compatíveis com Java 17
    val kotlin_version = "1.9.0"
    
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // O plugin do Android que exige Java 17 (Versão 8.0+)
        classpath("com.android.tools.build:gradle:8.1.0")
        // O plugin do Kotlin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}