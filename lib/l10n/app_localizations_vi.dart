// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get onboarding1Title => 'Kết nối ngay lập tức';

  @override
  String get onboarding1Description =>
      'Trò chuyện với bạn bè theo thời gian thực mọi lúc';

  @override
  String get next => 'Tiếp tục';

  @override
  String get simpleSecureTitle => 'Đơn giản & Bảo mật';

  @override
  String get simpleSecureSubtitle =>
      'Cuộc trò chuyện của bạn được bảo vệ bằng công nghệ bảo mật hiện đại';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get appName => 'Chat Box';

  @override
  String get authTagline => 'Nhanh chóng. Bảo mật. Nhắn tin đơn giản.';

  @override
  String get login => 'Đăng nhập';

  @override
  String get register => 'Đăng ký';

  @override
  String get welcomeBack => 'Chào mừng trở lại';

  @override
  String get loginSubtitle => 'Đăng nhập để tiếp tục sử dụng ứng dụng.';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Nhập email của bạn';

  @override
  String get password => 'Mật khẩu';

  @override
  String get enterPassword => 'Nhập mật khẩu của bạn';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản? Tạo ngay';

  @override
  String get fillAllFields => 'Vui lòng điền đầy đủ thông tin';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get registerSubtitle => 'Đăng ký để bắt đầu nhắn tin.';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get enterFullName => 'Nhập họ và tên';

  @override
  String get username => 'Tên người dùng';

  @override
  String get chooseUsername => 'Chọn tên người dùng';

  @override
  String get createPassword => 'Tạo mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get reEnterPassword => 'Nhập lại mật khẩu';

  @override
  String get passwordNotMatch => 'Mật khẩu không khớp';

  @override
  String get passwordMinLength => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get registerSuccess => 'Đăng ký thành công! Vui lòng đăng nhập.';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản? Đăng nhập';

  @override
  String get forgotPasswordTitle => 'Quên mật khẩu';

  @override
  String get forgotPasswordSubtitle =>
      'Nhập email để nhận liên kết đặt lại mật khẩu.';

  @override
  String get sendResetLink => 'Gửi liên kết đặt lại';

  @override
  String get backToLogin => 'Quay lại đăng nhập';

  @override
  String get enterEmailRequired => 'Vui lòng nhập email';

  @override
  String get resetLinkSentMessage =>
      'Nếu email tồn tại trong hệ thống, liên kết đặt lại mật khẩu đã được gửi.';

  @override
  String get auth_invalidEmail => 'Email không hợp lệ.';

  @override
  String get auth_wrongCredentials => 'Sai email hoặc mật khẩu.';

  @override
  String get auth_emailAlreadyInUse => 'Email này đã được sử dụng.';

  @override
  String get auth_tooManyRequests => 'Quá nhiều lần thử. Vui lòng thử lại sau.';

  @override
  String get auth_networkError => 'Lỗi mạng. Vui lòng kiểm tra kết nối.';

  @override
  String get auth_authenticationFailed =>
      'Xác thực thất bại. Vui lòng thử lại.';

  @override
  String get auth_unknown => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get fieldRequired => 'Vui lòng nhập thông tin';

  @override
  String get passwordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get chooseLanguage => 'Chọn ngôn ngữ';

  @override
  String get continueText => 'Tiếp tục';

  @override
  String get home => 'Trang chủ';

  @override
  String get profile => 'Trang cá nhân';

  @override
  String get settings => 'Cài đặt';

  @override
  String get noUsersFound => 'Không tìm thấy người dùng';

  @override
  String get online => 'Đang hoạt động';

  @override
  String minutesAgo(Object minutes) {
    return '${minutes}p';
  }

  @override
  String get changeLanguage => 'Đổi ngôn ngữ';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logoutConfirm => 'Bạn có chắc muốn đăng xuất không?';

  @override
  String get cancel => 'Hủy';
}
