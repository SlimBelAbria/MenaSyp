# MenaSyp
MenaSyp App
MenaSyp is a comprehensive Flutter mobile application designed to support the MENASYP 2025 event, held in Tunis, Tunisia. The app facilitates efficient event schedule management, real-time notifications, and user role-based features, providing a seamless experience for attendees and administrators alike.

Features
Event Schedule: Browse detailed event schedules organized by day with time, description, and event type.

Dynamic Notifications: Receive real-time notifications synced with a Google Sheets backend, with unread notification badges.

User Roles: Supports different user roles (e.g., admin) with tailored access such as adding or deleting events.

Interactive UI: Intuitive day selector, clean event listings with icons, and smooth navigation.

Local Persistence: Uses SharedPreferences for caching notifications and user preferences.

Integration with Google Sheets: Fetches and updates event data and notifications directly from Google Sheets, ensuring up-to-date information without manual app updates.

Theming & Branding: Custom dark theme with MENASYP branding colors to ensure a consistent and professional look.

Tech Stack
Flutter & Dart

Provider for state management

SharedPreferences for local storage

Google Sheets API for backend data

Iconsax package for modern icons

Usage
Attendees can view schedules, receive notifications, and explore event details.

Administrators can manage the schedule by adding or deleting events within the app.

