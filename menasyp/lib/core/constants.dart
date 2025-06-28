/// Application-wide constants and configuration
class AppConstants {
  const AppConstants._();

  // API and Data URLs
  static const String csvUrl = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vS3s2CodS5ElcAHye4YBwyQV5i7ZwuNiySbNMFagMRImyeMnsTSa1Ps32WZrM91qGHuNb7VwiaTln1t/pub?gid=255114807&single=true&output=csv';
  static const String csvId = '1CsRVRaqLhtswrRxyFaO8MbO2GweDGf6fRsEtYZCBgR4';
  
  // Notifications CSV URL
  static const String notificationsCsvUrl = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSEAEDhje20E1rev37xZE8xytcj7o4TqC-dqd99o4vQSk_VYLF92oQry6mtatdtPhKoJcd5dXhqutJi/pub?gid=1334086914&single=true&output=csv';
  
  // Feedback CSV URL
  static const String feedbackCsvUrl = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSEAEDhje20E1rev37xZE8xytcj7o4TqC-dqd99o4vQSk_VYLF92oQry6mtatdtPhKoJcd5dXhqutJi/pub?gid=1845174341&single=true&output=csv';

  // Validation Patterns
  static final RegExp usernameRegex = RegExp(r"^[a-zA-Z0-9_]+$");
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  
  // App Configuration
  static const String appName = 'MENASYP 2025';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'IEEE MENASYP 2025 Conference App';
  
  // Conference Details
  static const String conferenceName = 'MENASYP 2025';
  static const String conferenceLocation = 'Tunis, Tunisia';
  static const String conferenceDate = 'August 27-30, 2025';
  static const String conferenceWebsite = 'https://menasyp.ieee.tn/';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double largeBorderRadius = 20.0;
  
  // Storage Keys
  static const String userPrefsKey = 'user_preferences';
  static const String lastSeenNotificationKey = 'last_seen_notification_id';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
}

/// Application strings and text content
class AppStrings {
  const AppStrings._();

  // Authentication
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String createYourAccount = 'Sign in to your\nAccount';
  static const String doNotHaveAnAccount = "Don't have an account?";
  static const String username = 'Username';
  static const String password = 'Password';
  static const String email = 'Email';
  static const String forgotPassword = 'Forgot your password?';
  
  // Validation Messages
  static const String pleaseEnterUsername = 'Please, Enter Username';
  static const String pleaseEnterPassword = 'Please, Enter Password';
  static const String pleaseEnterEmail = 'Please, Enter Email';
  static const String invalidUsername = 'Invalid Username';
  static const String invalidEmail = 'Invalid Email';
  static const String invalidPassword = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  
  // Success Messages
  static const String loggedIn = 'Logged In!';
  static const String registrationComplete = 'Registration Complete!';
  static const String itemAddedSuccessfully = 'Item added successfully';
  static const String itemDeletedSuccessfully = 'Item deleted successfully';
  static const String feedbackSubmitted = 'Thank you for your feedback!';
  
  // Error Messages
  static const String loginFailed = 'Login Failed';
  static const String wrongCredentials = 'Wrong username or password. Please try again.';
  static const String networkError = 'Network error. Please check your connection.';
  static const String unknownError = 'An unknown error occurred.';
  static const String failedToLoad = 'Failed to load data';
  static const String failedToAdd = 'Failed to add item';
  static const String failedToDelete = 'Failed to delete item';
  
  // General UI
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String delete = 'Delete';
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String save = 'Save';
  static const String refresh = 'Refresh';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String noData = 'No data available';
  static const String search = 'Search';
  static const String clear = 'Clear';
  
  // Navigation
  static const String home = 'Home';
  static const String schedule = 'Schedule';
  static const String contacts = 'Contacts';
  static const String notifications = 'Notifications';
  static const String settings = 'Settings';
  static const String feedback = 'Feedback';
  static const String tunisiaGuide = 'Tunisia Guide';
  
  // Schedule
  static const String addEvent = 'Add New Event';
  static const String eventName = 'Event Name';
  static const String eventDescription = 'Description';
  static const String eventTime = 'Time';
  static const String eventType = 'Type';
  static const String eventDay = 'Day';
  static const String confirmDelete = 'Confirm Delete';
  static const String confirmDeleteMessage = 'Are you sure you want to delete this item?';
  
  // Tunisia Guide
  static const String addGuideItem = 'Add New Guide Item';
  static const String guideTitle = 'Title';
  static const String guideDescription = 'Description';
  static const String guideCategory = 'Category';
  static const String noGuideItems = 'No guide items available';
  static const String noGuideItemsAdmin = 'No guide items yet';
  static const String addGuideItemHint = 'Tap the "+" button to add useful tips for Tunisia';
  
  // Notifications
  static const String noNotifications = 'No notifications available';
  static const String addNotification = 'Add Notification';
  static const String notificationTitle = 'Title';
  static const String notificationMessage = 'Message';
  static const String notificationType = 'Type';
  
  // Settings
  static const String profile = 'Profile';
  static const String account = 'Account';
  static const String preferences = 'Preferences';
  static const String about = 'About';
  static const String help = 'Help';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  static const String shareApp = 'Share App';
  static const String rateApp = 'Rate App';
  static const String contactUs = 'Contact Us';
  static const String version = 'Version';
  
  // Days
  static const String day1 = 'Day 1';
  static const String day2 = 'Day 2';
  static const String day3 = 'Day 3';
  static const String day4 = 'Day 4';
  static const String date27Aug = '27 Aug';
  static const String date28Aug = '28 Aug';
  static const String date29Aug = '29 Aug';
  static const String date30Aug = '30 Aug';
}
