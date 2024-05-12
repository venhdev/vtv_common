import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/presentation/components/outline_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    super.key,
    required this.onSendCode,
    required this.handleResetPassword,
  });

  // static const String routeName = 'forgot-password';
  // static const String path = '/user/login/forgot-password';

  final FutureOr<bool> Function(String username) onSendCode; // true if send code success (parent call API)
  final Future<void> Function(String username, String otp, String newPassword) handleResetPassword;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isCodeSent = false;
  bool _isSendingCode = false;
  bool _isChangingPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> handleSendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSendingCode = true;
      });

      if (await widget.onSendCode(_emailController.text)) {
        setState(() {
          _isSendingCode = false;
          _isCodeSent = true;
        });
      }
    }
  }

  Future<void> handleResetPassword() async {
    final username = _emailController.text;
    final otp = _codeController.text;
    final newPassword = _passwordController.text;
    await widget.handleResetPassword(username, otp, newPassword);

    // sl<AuthRepository>().resetPasswordViaOTP(username, otp, newPassword).then((resultEither) {
    //   resultEither.fold(
    //     (failure) {
    //       ScaffoldMessenger.of(context)
    //         ..hideCurrentSnackBar()
    //         ..showSnackBar(
    //           SnackBar(
    //             content: Text(failure.message ?? 'Có lỗi xảy ra'),
    //           ),
    //         );
    //     },
    //     (success) {
    //       ScaffoldMessenger.of(context)
    //         ..hideCurrentSnackBar()
    //         ..showSnackBar(
    //           SnackBar(
    //             content: Text(success.message ?? 'Đổi mật khẩu thành công'),
    //           ),
    //         );

    //       // navigate back to login page
    //       context.go('/user/login');
    //     },
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        backgroundColor: Colors.transparent,
        leading: _isSendingCode || _isChangingPassword
            ? const IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: null,
              )
            : null,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 24),
                  const Text(
                    'Nhập tên tài khoản và mã xác nhận\n được gửi đến email của bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlineTextField(
                    readOnly: _isCodeSent,
                    controller: _emailController,
                    label: 'Tài khoản',
                    hintText: 'Nhập tên tài khoản',
                    isRequired: true,
                    suffixIcon: IconButton(
                      onPressed: () async => await handleSendCode(),
                      icon: _isSendingCode ? const CircularProgressIndicator() : const Icon(Icons.send),
                    ),
                  ),
                  // when code is sent add more fields to form
                  if (_isCodeSent) ...[
                    const SizedBox(height: 12),
                    OutlineTextField(
                      controller: _codeController,
                      label: 'Mã xác nhận',
                      hintText: 'Nhập mã xác nhận',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chưa nhập mã xác nhận';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlineTextField(
                      controller: _passwordController,
                      label: 'Mật khẩu mới',
                      hintText: 'Nhập mật khẩu mới',
                      isRequired: true,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chưa nhập mật khẩu mới';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlineTextField(
                      controller: _confirmPasswordController,
                      label: 'Xác nhận mật khẩu mới',
                      hintText: 'Nhập lại mật khẩu mới',
                      isRequired: true,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chưa nhập lại mật khẩu mới';
                        } else if (value != _passwordController.text) {
                          return 'Mật khẩu không khớp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isChangingPassword = true;
                            });
                            await handleResetPassword();
                            setState(() {
                              _isChangingPassword = false;
                            });
                          }
                        },
                        child: _isChangingPassword
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Đổi mật khẩu'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
