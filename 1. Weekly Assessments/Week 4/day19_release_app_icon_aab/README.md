# Day 19 — Flutter App Release Practice

## What I Learned

Today, I practised preparing a Flutter application for Android release and learned about the Google Play publishing process.

### 1. App Icon

- Added a custom launcher icon using `assets/icon/logo.jpg`.
- Used the `flutter_launcher_icons` package to generate the Android app icons.

### 2. Splash Screen

- Added a splash screen using the `flutter_native_splash` package.
- Configured the background color and logo.
- Generated the required splash screen resources for Android.

### 3. Build Flavors

- Configured two flavors: `development` and `production`.
- Added a separate application ID suffix for the development flavor.
- Configured different app names for development and production.
- Tested running the production flavor successfully.

### 4. Android App Signing

- Generated a signing keystore using `keytool`.
- Created a `key.properties` file to store the signing configuration.
- Configured release signing in `android/app/build.gradle.kts`.
- Learned why signing credentials should not be uploaded to GitHub.

### 5. Release App Bundle (AAB)

- Successfully built a production release Android App Bundle.
- Used Flutter's size analysis option to inspect the app build.

**AAB output location:**

`build/app/outputs/bundle/productionRelease/app-production-release.aab`

**Reported AAB size:** Approximately 40.1 MB.

## What I Could Not Complete

### Google Play Console

I started the Google Play Console developer registration process but did not complete it because Google requires a one-time developer registration fee of US$25.

As a result, I could not:

- Complete developer account registration.
- Create the app entry in Google Play Console.
- Upload the AAB to the Internal testing track.
- Add testers and install the app through Google Play.

These tasks remain pending until I have access to a registered developer account.

## Conclusion

I successfully practised app icons, splash screens, build flavors, release signing, and AAB generation in Flutter. The remaining work is to complete Google Play Console registration and practise uploading and testing the app through its Internal testing track.

**Status:** Local release preparation completed; Google Play Console testing pending.
