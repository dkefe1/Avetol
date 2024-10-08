class ChangeForgotPassword {
  final String phone;
  final String password;
  final String password_confirmation;

  ChangeForgotPassword(
      {required this.phone,
      required this.password,
      required this.password_confirmation});
}
