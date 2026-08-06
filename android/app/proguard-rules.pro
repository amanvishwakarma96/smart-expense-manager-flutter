-keep class io.flutter.** { *; }
-keep class com.smartspend.app.** { *; }

# Flutter's Android embedding contains optional Google Play deferred-component
# references. PiggyAI does not configure deferred components or use
# FlutterPlayStoreSplitApplication, so these classes are intentionally absent.
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
