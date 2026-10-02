# Keep WebView / JS bridge / app entry points.
-keep class com.bulkchef.app.** { *; }
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
