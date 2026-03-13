# 📋 Product Requirement Document (PRD)

**Project Name:** Smart Class Check-in & Learning Reflection App  
**Version:** 1.0 (MVP)  
**Date:** March 13, 2026  
**Status:** ✅ Complete & Deployed  
**Contact:** Student ID 1305216 (MFU LAB)

---

---

## 1. Problem Statement

**Challenge:**  
Many university classes struggle to accurately verify physical student attendance while simultaneously gathering valuable insights into student comprehension, engagement, and well-being.

**Current Issues with Traditional Methods:**
- ❌ Roll-calls are time-consuming and error-prone
- ❌ No mechanism to verify actual physical presence
- ❌ Lack of real-time learning feedback
- ❌ No pre/post-class emotional tracking
- ❌ Data isn't centralized or analyzable

**Our Solution:**  
A mobile-first platform combining **GPS location verification**, **QR code validation**, and **interactive reflection forms** to ensure both attendance integrity and learning insights.

## 2. Target User

### Primary Users: University Students
- **Goal:** Check in/out from class easily, provide emotional & learning feedback
- **Pain Point:** Don't want complicated attendance systems; want quick, mobile-friendly process
- **User Count:** ~500-5,000 per university

### Secondary Users: Instructors/Administrators
- **Goal:** Track attendance accuracy, analyze class engagement patterns
- **Pain Point:** Need reliable data for attendance records and pedagogical insights
- **User Count:** ~50-200 per university

## 3. Feature List

| # | Feature | Priority | Description |
|----|---------|----------|-------------|
| 1 | **GPS Location Verification** | CRITICAL | Captures device GPS coordinates (lat/lng) at check-in & check-out to verify on-campus presence |
| 2 | **QR Code Scanner** | CRITICAL | Scans unique classroom QR codes to validate session-specific attendance |
| 3 | **Pre-Class Reflection Form** | HIGH | Captures: (a) previous class topic, (b) today's expectations, (c) mood score (1-5 emoji scale) |
| 4 | **Post-Class Reflection Form** | HIGH | Captures: (a) what was learned, (b) class/instructor feedback |
| 5 | **Real-Time Data Sync** | HIGH | Stores all session data to Firebase Firestore with automatic timestamps |
| 6 | **Navigation & UI** | HIGH | Clean Material Design 3 interface with smooth page transitions |
| 7 | **Error Handling & Validation** | MEDIUM | Validates all form inputs and GPS/QR permissions gracefully |
| 8 | **Responsive Design** | MEDIUM | Works across phone, tablet, and web browsers |

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
6. User clicks **"Submit Check-in"**. Data is saved to the **Firebase Firestore database**.

### Flow 2: Class Completion (After Class)
1. User returns to the app and taps the **"Finish Class"** button from the Home Screen.
2. User scans the classroom QR Code again.
3. System automatically records the new GPS Location + Timestamp.
4. User fills out the Post-class form:
   - *What did you learn today?* (Short text field)
   - *Feedback about the class or instructor?* (Short text field)
5. User clicks **"Submit Check-out"**. Data is saved to the **Firebase Firestore database**.

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
- **Backend / Storage:** Firebase Cloud Firestore (NoSQL Document Database).
- **Deployment:** Firebase Hosting (Hosting the Flutter Web build).

---

## 7. Submission Details
- **GitHub Repository:** [Insert your GitHub URL here]
- **Firebase Hosted URL:** [Insert your Firebase Web App URL here]
- *Note: Instructor (`vittayasak@mfu.ac.th`) has been invited to the GitHub repository.*
