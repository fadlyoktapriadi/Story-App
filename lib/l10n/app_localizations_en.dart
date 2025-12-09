// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginWelcome => 'Welcome to Storyfy';

  @override
  String get smallLoginTitle =>
      'Sign in or register bellow to share your story';

  @override
  String get placeholderEmail => 'Enter your email';

  @override
  String get placeholderPassword => 'Enter your password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get registerButton => 'Sign Up';

  @override
  String get registerTitle =>
      'Create an account and start sharing your story with Storyfy';

  @override
  String get placeholderName => 'Enter your name';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get titleAddStory => 'Add Story';

  @override
  String get placeholderDescription => 'Enter a description';

  @override
  String get uploadStory => 'Upload Story';
}
