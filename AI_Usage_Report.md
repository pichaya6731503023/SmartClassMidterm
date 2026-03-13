# 🤖 AI Usage Report
**Project:** Smart Class Check-in & Learning Reflection App
**Date:** March 13, 2026

This document explicitly outlines how Artificial Intelligence (AI) tools were utilized in the development of this midterm lab project, adhering to the principles of academic integrity and the *AI Usage & Engineering Judgment* rubric.

---

### 1. AI Tools Used
- **GitHub Copilot / Gemini 3.1 Pro:** Used as an intelligent programming assistant natively integrated within VS Code.

### 2. What the AI Helped Generate
- **Flutter Framework & UI Scaffolding:** AI assisted in drafting the structural layout using Material 3 guidelines (e.g., `home_screen.dart`, `checkin_screen.dart`, `checkout_screen.dart`). This accelerated the visual design process, providing a professional and clean user interface.
- **Sensor Boilerplates:** AI swiftly generated the standard boilerplate code for handling `geolocator` permissions and extracting GPS coordinates (`location_service.dart`). It also set up the camera stack for the `mobile_scanner` implementation.
- **Product Requirement Document (PRD):** AI conversational prompt helped brainstorm and structure the PRD file initially based on the problem statement given in the exam instructions.

### 3. What Was Modified and Implemented Manually (Engineering Judgment)
While AI provided the structural foundation, several critical engineering decisions and code implementations were handled directly to ensure proper functionality and integration:

1. **State Management & Refactoring:** Restructured how variables like `Position? _currentPosition` were managed to align with the latest `geolocator` library updates, ensuring no unhandled null-safety exceptions occurred during runtime.
2. **Firebase Firestore Integration:** Hand-coded the Firebase connection logic in `main.dart` and implemented the specific data payload mapping within the `_submitForm()` functions to successfully transmit data to the `class_sessions` collection. I mapped the exact fields required by the Rubric.
3. **Data Types & Flow:** Modified the Mood input from a basic slider into an interactive Emoji selector system for better UX. I also configured the routing logic to cleanly transition back to the root `HomeScreen` upon successful database injection.
4. **Environment Setup & Deployment:** Handled terminal operations manually, utilizing Windows Winget to download Dart/Flutter, executing Firebase CLI via standalone `.exe`, and resolving firewall restrictions by compiling the application with the `--web-renderer html` flag for the final deployment.

---
*Declaration: I understand the generated code and am fully capable of explaining the structure, data pathways, and Firebase logic used in this application if queried by the instructor.*
