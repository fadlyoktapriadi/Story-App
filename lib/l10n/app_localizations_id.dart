// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get loginWelcome => 'Selamat datang di Storyfy';

  @override
  String get smallLoginTitle =>
      'Masuk atau daftar dibawah untuk berbagi cerita kamu';

  @override
  String get placeholderEmail => 'Masukan email kamu';

  @override
  String get placeholderPassword => 'Masukan password kamu';

  @override
  String get loginButton => 'Masuk';

  @override
  String get registerButton => 'Daftar';

  @override
  String get registerTitle =>
      'Buat akun dan mulai berbagai cerita kamu bersama Storyfy';

  @override
  String get placeholderName => 'Masukan nama kamu';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun? masuk';

  @override
  String get titleAddStory => 'Tambah Cerita';

  @override
  String get placeholderDescription => 'Masukan deskripsi cerita';

  @override
  String get uploadStory => 'Kirim Cerita';
}
