import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/presentation/components/outline_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.onLoginPressed,
    this.onRegisterPressed,
    this.onForgotPasswordPressed,
    this.showTitle = true,
  });

  final Future<void> Function(String username, String password)? onLoginPressed; // only call when validate success
  final VoidCallback? onRegisterPressed;
  final VoidCallback? onForgotPasswordPressed;

  /// only call when auth status changed and page is mounted

  // ui
  final bool showTitle;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showTitle
          ? AppBar(
              title: const Text('Đăng nhập'),
              backgroundColor: Colors.transparent,
            )
          : null,
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
                  Text(
                    "VTV",
                    style: GoogleFonts.ribeye(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlineTextField(
                    controller: _usernameController,
                    label: 'Tài khoản',
                    hintText: 'Nhập tên tài khoản',
                    isRequired: true,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 12),
                  OutlineTextField(
                    controller: _passwordController,
                    label: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu',
                    isRequired: true,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  // forgot password btn
                  _buildForgotPasswordBtn(context),
                  const SizedBox(height: 18),
                  // btn login
                  _buildLoginButton(context),
                  // register
                  _buildRegisterBtn(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align _buildRegisterBtn(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: widget.onRegisterPressed,
        child: const Text(
          'Chưa có tài khoản? Đăng ký ngay!',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Align _buildForgotPasswordBtn(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: widget.onForgotPasswordPressed,
        child: const Text(
          'Quên mật khẩu?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SizedBox _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
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
              _loading = true;
            });
            await widget.onLoginPressed?.call(
              _usernameController.text,
              _passwordController.text,
            );
            if (mounted) {
              setState(() {
                _loading = false;
              });
            }
          }
        },
        child: _loading
            ? const Text(
                'Đang tải...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              )
            : const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
