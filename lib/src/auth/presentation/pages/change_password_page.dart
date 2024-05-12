import 'package:flutter/material.dart';
import '../../../core/presentation/components/outline_text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, required this.onChangePassword});

  static const String routeName = 'change-password';
  static const String path = '/user/change-password';

  final void Function(String oldPass, String newPass) onChangePassword;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        backgroundColor: Colors.transparent,
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
                  OutlineTextField(
                    controller: _oldPasswordController,
                    label: 'Mật khẩu hiện tại',
                    hintText: 'Nhập mật khẩu hiện tại',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 24),
                  OutlineTextField(
                    controller: _newPasswordController,
                    label: 'Mật khẩu mới',
                    hintText: 'Nhập mật khẩu mới',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 24),
                  OutlineTextField(
                    controller: _confirmPasswordController,
                    label: 'Xác nhận mật khẩu mới',
                    hintText: 'Nhập lại mật khẩu mới',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                    validator: (value) {
                      if (value != _newPasswordController.text) {
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onChangePassword(
                            _oldPasswordController.text,
                            _newPasswordController.text,
                          );
                        }
                      },
                      child: const Text('Đổi mật khẩu'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
