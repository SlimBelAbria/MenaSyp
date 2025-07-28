# MenaSyp

# MenaSyp App

MenaSyp is a Flutter mobile application built to support the MENASYP 2025 event in Tunis, Tunisia. The app helps attendees and administrators manage event schedules, receive real-time notifications, and access role-specific features, all in one place.

## Features

- **Event Schedule:** Browse detailed schedules by day, including time, description, and event type.
- **Dynamic Notifications:** Get real-time updates synced with a Google Sheets backend, with badges showing unread notifications.
- **User Roles:** Different user roles (e.g., admin) with permissions to add or delete events.
- **Interactive UI:** Easy day selector, clean event listings with icons, and smooth navigation.
- **Local Persistence:** Caches notifications and preferences using SharedPreferences.
- **Google Sheets Integration:** Fetches and updates data directly from Google Sheets to keep information current.
- **Theming & Branding:** Custom dark theme aligned with MENASYP branding for a professional look.

## Tech Stack

- Flutter & Dart  
- Provider for state management  
- SharedPreferences for local storage  
- Google Sheets API for backend data  
- Iconsax package for icons  

## Usage

- **Attendees** can view schedules, receive notifications, and check event details.  
- **Administrators** can manage the schedule by adding or deleting events within the app.

## Flutter Version

- **Flutter**: 3.13.6 (stable channel)
- **Dart**: 3.1.3
- **Engine**: a794cf2681
- **DevTools**: 2.25.0

## iOS Configuration

This project is configured for iOS development with:
- iOS deployment target: 12.0
- All necessary permissions configured in Info.plist
- Podfile properly configured for CocoaPods

## Getting Started

1. Ensure you have Flutter 3.13.6 or later installed
2. Run `flutter pub get` to install dependencies
3. For iOS: Open `ios/Runner.xcworkspace` in Xcode
4. For Android: Run `flutter run` or open in Android Studio

## Dependencies

See `pubspec.yaml` for the complete list of dependencies.

