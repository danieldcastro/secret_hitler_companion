import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.marciano.secret_hitler_companion"
            resValue("string", "app_name", "Secret Hitler Companion")
        }
        create("qa") {
            dimension = "flavor-type"
            applicationId = "com.marciano.secret_hitler_companion_qa"
            resValue("string", "app_name", "[QA] Secret Hitler Companion")
        }
    }
}
