# Stripe SDK: Evita que ProGuard elimine clases necesarias
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**
-keepclassmembers class com.stripe.** { *; }
