# Resume Builder for Freshers – Simple CV Maker

Offline-first Flutter Android app to create, preview, save, and export ATS-friendly resumes for Indian students/freshers.

## Play Store title
**Resume Builder – CV Maker for Freshers**

## Tech stack
- Flutter (stable)
- Provider
- shared_preferences
- pdf + printing
- Google AdMob
- in_app_purchase

## Project structure
```
lib/
 ├── models/
 ├── screens/
 ├── widgets/
 ├── services/
 ├── templates/
```

## Implemented phase-1 features
- Resume model with required fields.
- Home screen with:
  - Create Resume
  - My Resumes
  - Templates
- Resume form sections:
  - Personal Information
  - Career Objective
  - Education
  - Skills (comma separated)
  - Projects
  - Experience
- Local saving/loading via SharedPreferences.
- Resume preview with black/white professional layout.
- 3 templates:
  - Basic (free)
  - Modern (premium)
  - Professional (premium)
- PDF generation and export/share.
- Watermark for free users: `Created with Resume Builder App`.
- Premium unlock removes watermark + ads + unlocks premium templates.
- Banner ad on form screen.
- Interstitial ad before PDF download.

## Setup
1. Install Flutter stable and Android SDK.
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Run app:
   ```bash
   flutter run
   ```

## AdMob setup (Android)
1. Replace test IDs in `lib/services/ad_service.dart` with production IDs.
2. Add your AdMob App ID to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
     android:name="com.google.android.gms.ads.APPLICATION_ID"
     android:value="ca-app-pub-xxxxxxxx~yyyyyyyy"/>
   ```

## In-app purchase setup
1. Product ID used in app: `premium_unlock_59`.
2. Create a **one-time non-consumable** product in Google Play Console with this exact product ID.
3. Publish to an internal testing track and test with a license tester account.

## Release build
1. Configure signing in `android/key.properties` and `android/app/build.gradle`.
2. Build release APK:
   ```bash
   flutter build apk --release
   ```
3. Build appbundle for Play Store:
   ```bash
   flutter build appbundle --release
   ```

## Notes
- No login
- No cloud storage
- No backend
- No AI API
- Offline-first
