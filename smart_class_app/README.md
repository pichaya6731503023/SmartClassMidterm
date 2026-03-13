# Smart Class Check-in & Learning Reflection App 🚀

This is the Flutter MVP version correctly fulfilling the requirements of the Midterm Lab.

## 📱 Features Implemented
- **Beautiful & Professional UI:** Built with Material 3 & Google Fonts (`Inter`).
- **GPS Location:** Accurate latitude & longitude tracking using `geolocator`.
- **QR Code Scanning:** Fast scanning with `mobile_scanner`.
- **Pre-class Reflection (Check-in):** Captures expectations, previous topics, and mood (emoji-based score).
- **Post-class Reflection (Check-out):** Captures short text of what was learned and instructor feedback.

## 🛠️ Setup Instructions 

1. Ensure you have installed **Flutter** (>=3.0.0).  
2. Open the terminal inside this directory (`smart_class_app`) and run:
   ```bash
   flutter pub get
   ```
3. To run the app, you need a physical device or an emulator with camera & location permissions:
   ```bash
   flutter run
   ```

## 📍 Required Android / iOS Permissions Setup
Please make sure when compiling that you grant permissions to Camera and Location.

**For Android (`android/app/src/main/AndroidManifest.xml`):**
Add:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

**For iOS (`ios/Runner/Info.plist`):**
Add:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan class QR codes.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to verify your presence in the classroom.</string>
```

## 🔥 Firebase Setup Notes (For deployment stage)
To earn full marks in the exam, compile this to web and push to Firebase Hosting.
```bash
# Build the web version
flutter build web

# Initialize Firebase in your folder
firebase init hosting

# Deploy it!
firebase deploy
```

## 🤖 AI Usage Report
- **AI Tool Used:** GitHub Copilot / Gemini.
- **What was generated:** The structure of the application, UI components with Material 3, QR scanner integration (`qr_scanner_screen.dart`), and GPS extraction (`location_service.dart`).
- **What was modified:** Adjusted form validation, integrated the mood emojis manually instead of a standard slider for better UX, and connected the logical flow between screens.
