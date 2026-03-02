// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboarding1Title => 'Connect Instantly';

  @override
  String get onboarding1Description =>
      'Chat with your friends in real-time anytime';

  @override
  String get next => 'Next';

  @override
  String get simpleSecureTitle => 'Simple & Secure';

  @override
  String get simpleSecureSubtitle =>
      'Your conversations are private and protected with modern security';

  @override
  String get getStarted => 'Get Started';

  @override
  String get appName => 'Chat Box';

  @override
  String get authTagline => 'Fast. Secure. Simple messaging.';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get loginSubtitle => 'Login to continue using the app.';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Create one';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get createAccount => 'Create Account';

  @override
  String get registerSubtitle => 'Sign up to start messaging.';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get username => 'Username';

  @override
  String get chooseUsername => 'Choose a username';

  @override
  String get createPassword => 'Create password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get reEnterPassword => 'Re-enter password';

  @override
  String get passwordNotMatch => 'Passwords do not match';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get registerSuccess => 'Register successful! Please login.';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email to receive a password reset link.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get enterEmailRequired => 'Please enter your email';

  @override
  String get resetLinkSentMessage =>
      'If an account exists with this email, a password reset link has been sent.';

  @override
  String get auth_invalidEmail => 'The email address is not valid.';

  @override
  String get auth_wrongCredentials => 'Incorrect email or password.';

  @override
  String get auth_emailAlreadyInUse => 'This email is already in use.';

  @override
  String get auth_tooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get auth_networkError =>
      'Network error. Please check your connection.';

  @override
  String get auth_authenticationFailed =>
      'Authentication failed. Please try again.';

  @override
  String get auth_unknown => 'Something went wrong. Please try again.';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get passwordRequired => 'Password is required';
}
