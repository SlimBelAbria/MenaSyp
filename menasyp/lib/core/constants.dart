 const String csvUrl =
    'https://docs.google.com/spreadsheets/d/e/2PACX-1vS3s2CodS5ElcAHye4YBwyQV5i7ZwuNiySbNMFagMRImyeMnsTSa1Ps32WZrM91qGHuNb7VwiaTln1t/pub?gid=255114807&single=true&output=csv';
  
   const String csvId = '1CsRVRaqLhtswrRxyFaO8MbO2GweDGf6fRsEtYZCBgR4';
class AppConstants {
  const AppConstants._();

  static final RegExp usernameRegex = RegExp(r"^[a-zA-Z0-9_]+$");
}
class AppStrings {
  const AppStrings._();

  static const String loginAndRegister = 'Login and Register UI';
  static const String uhOhPageNotFound = 'uh-oh!\nPage not found';

  static const String register = 'Register';
  static const String login = 'Login';
  static const String createYourAccount = 'Sign in to your\nAccount';
  static const String doNotHaveAnAccount = "Don't have an account?";

  static const String loggedIn = 'Logged In!';
  static const String registrationComplete = 'Registration Complete!';

  static const String username = 'Username';
  static const String pleaseEnterUsername = 'Please, Enter Username';
  static const String invalidUsername = 'Invalid Username';

  static const String password = 'Password';
  static const String pleaseEnterPassword = 'Please, Enter Password';
}
