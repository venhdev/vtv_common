import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils.dart';
import '../../domain/entities/dto/register_params.dart';
import '../../../core/presentation/components/outline_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.onRegisterPressed,
    this.onLoginPressed,
  });

  // static const String routeName = 'register';
  // static const String path = '/user/register';

  final Future<void> Function(RegisterParams params) onRegisterPressed;
  final VoidCallback? onLoginPressed;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool? _gender;
  DateTime? _dob;

  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "VTV",
            textAlign: TextAlign.center,
            style: GoogleFonts.ribeye(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OutlineTextField(
                  controller: _fullNameController,
                  label: 'Họ và tên',
                  hintText: 'Nhập tên đầy đủ của bạn',
                  prefixIcon: const Icon(Icons.badge),
                ),
                const SizedBox(height: 12),
                OutlineTextField(
                  controller: _genderController,
                  label: 'Giới tính',
                  hintText: 'Chọn giới tính của bạn',
                  readOnly: true,
                  onTap: () async {
                    // show dialog to choose gender
                    final result = await showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('Chọn giới tính'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Nam', style: TextStyle(fontSize: 16)),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Nữ', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    );

                    setState(() {
                      _gender = result as bool?;
                      if (_gender == null) {
                        _genderController.clear();
                      } else if (_gender == true) {
                        _genderController.text = 'Nam';
                      } else {
                        _genderController.text = 'Nữ';
                      }
                    });
                  },
                  prefixIcon: const Icon(Icons.wc),
                ),
                const SizedBox(height: 12),
                OutlineTextField(
                  controller: _dobController,
                  readOnly: true,
                  label: 'Ngày sinh',
                  hintText: 'Chọn ngày sinh của bạn',
                  prefixIcon: const Icon(Icons.cake),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(DateTime.now().year - 12), // least 12 years old
                    );

                    if (pickedDate != null) {
                      _dobController.text = ConversionUtils.convertDateTimeToString(
                        pickedDate,
                        pattern: 'dd/MM/yyyy',
                      );
                      _dob = pickedDate;
                    }
                  },
                ),
                const SizedBox(height: 12),
                OutlineTextField(
                  controller: _usernameController,
                  label: 'Tài khoản',
                  hintText: 'Nhập tên tài khoản',
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 12),
                OutlineTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Nhập email',
                  prefixIcon: const Icon(Icons.email),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email không được để trống';
                    } else if (!ValidationUtils.isValidEmail(value)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                OutlineTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  hintText: 'Nhập mật khẩu',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mật khẩu không được để trống';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                OutlineTextField(
                  controller: _confirmPasswordController,
                  label: 'Xác nhận mật khẩu',
                  hintText: 'Nhập lại mật khẩu',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mật khẩu không được để trống';
                    } else if (value != _passwordController.text) {
                      return 'Mật khẩu không trùng khớp';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),

          // btn register
          _buildRegisterButton(context),

          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: widget.onLoginPressed,
              child: const Text(
                'Đã có tài khoản? Đăng nhập ngay',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final param = RegisterParams(
                    username: _usernameController.text.trim(),
                    password: _passwordController.text.trim(),
                    email: _emailController.text.trim(),
                    fullName: _fullNameController.text.trim(),
                    gender: _gender!,
                    birthday: _dob!,
                  );

                  setState(() {
                    _isLoading = true;
                  });

                  await widget.onRegisterPressed(param);

                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }

                  // add event to bloc
                  //   await context.read<AuthCubit>().register(RegisterParams(
                  //         username: _usernameController.text.trim(),
                  //         password: _passwordController.text.trim(),
                  //         email: _emailController.text.trim(),
                  //         fullName: _fullNameController.text.trim(),
                  //         gender: _gender!,
                  //         birthday: _dob!,
                  //       ));
                  // } else {
                  //   ScaffoldMessenger.of(context)
                  //     ..hideCurrentSnackBar()
                  //     ..showSnackBar(
                  //       const SnackBar(
                  //         content: Text('Vui lòng kiểm tra lại đầy đủ thông tin'),
                  //       ),
                  //     );
                }
              },
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
