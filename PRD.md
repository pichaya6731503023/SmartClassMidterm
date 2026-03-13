# Product Requirement Document (PRD)

**Project Name:** Smart Class Check-in & Learning Reflection App
**Date:** March 13, 2026

---

## 1. Problem Statement
Many university classes struggle to accurately verify physical student attendance and simultaneously gather valuable insights into student comprehension and well-being. Traditional roll-calls are inefficient and do not provide instructors with feedback on whether students actually understood the lesson or how they felt before and after the class. This app solves both problems by requiring physical presence verification (GPS & QR) tied to a learning reflection form.

## 2. Target User
- **Primary Users:** University Students (Use the app to check-in, check-out, and submit class reflections).
- **Secondary Users:** Instructors (To review attendance correctness via GPS logs and analyze student feedback/mood).

## 3. Feature List
1. **Location Verification (GPS Tracker):** Automatically captures GPS coordinates during check-in and check-out to ensure the student is on-site.
2. **Class Validation (QR Code Scanner):** Scan a unique classroom QR code to confirm attendance for a specific session.
3. **Pre-class Reflection (Check-in Form):**
   - Record the topic from the previous class.
   - Record expectations for today's session.
   - Capture student mood (Scale 1-5).
4. **Post-class Reflection (Check-out Form):**
   - Record what was learned today.
   - Provide feedback about the class or instructor.
5. **Data Storage & Sync:** Store session data to Firebase (or offline LocalStorage/SQLite for MVP fallback).

## 4. User Flow
### Flow 1: Class Check-in (Before Class)
1. User opens the application and stays on the **Home Screen**.
2. User taps the **"Check-in"** button to go to the Check-in Screen.
3. System prompts for Location permission and records GPS Location + Timestamp.
4. User taps "Scan QR" and scans the classroom QR Code.
5. User fills out the Pre-class form:
   - *What topic was covered in the previous class?* (Text field)
   - *What topic do you expect to learn today?* (Text field)
   - *Mood before class* (Slider/Radio buttons: 1=😡, 2=🙁, 3=😐, 4=🙂, 5=😄)
6. User clicks **"Submit Check-in"**. Data is saved to the database.

### Flow 2: Class Completion (After Class)
1. User returns to the app and taps the **"Finish Class"** button from the Home Screen.
2. User scans the classroom QR Code again.
3. System automatically records the new GPS Location + Timestamp.
4. User fills out the Post-class form:
   - *What did you learn today?* (Short text field)
   - *Feedback about the class or instructor?* (Short text field)
5. User clicks **"Submit Check-out"**. Data is saved to the database.

## 5. Data Fields
The database will contain a collection (e.g., `class_sessions`) with the following structure:

- `session_id` (String) - Decoded from the scanned QR Code.
- `student_id` (String) - Simulated student ID for MVP.
- `check_in_time` (DateTime) - Timestamp of check-in.
- `check_in_location` (GeoPoint / Lat&Lng) - GPS coordinates.
- `previous_topic` (String) - Input from check-in form.
- `expected_topic` (String) - Input from check-in form.
- `mood_score` (Integer) - Value from 1 to 5.
- `check_out_time` (DateTime) - Timestamp of check-out (Updated later).
- `check_out_location` (GeoPoint / Lat&Lng) - GPS coordinates (Updated later).
- `learned_topic` (String) - Input from check-out form.
- `feedback` (String) - Input from check-out form.

## 6. Tech Stack
- **Frontend / Framework:** Flutter (Dart).
- **Core Packages:**
  - `geolocator`: For fetching device GPS coordinates.
  - `mobile_scanner` (or `qr_code_scanner`): For QR Code scanning.
- **Backend / Storage:** Firebase Cloud Firestore (or SQFlite/SharedPreferences).
- **Deployment:** Firebase Hosting (Hosting the Flutter Web build).
