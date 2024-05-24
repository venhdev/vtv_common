import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key, required this.sl, this.onBackPressed});

  final GetIt sl;
  final VoidCallback? onBackPressed;

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  late GetIt sl;

  String accessToken = '';
  String? fcmToken = '';
  String? newAccessToken;

  String? forceAccessToken;

  TextEditingController domainTextController = TextEditingController(text: host);
  Future<void> setDomain(String newDomain) async {
    if (newDomain == host) {
      Fluttertoast.showToast(msg: 'Domain is the same');
    } else {
      host = newDomain;
      await sl<SharedPreferencesHelper>().I.setString('host', host);
      Fluttertoast.showToast(msg: 'Server domain has been changed to $host');
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    sl = widget.sl;
    domainTextController.text = host;
    sl<SecureStorageHelper>().accessToken.then((token) {
      if (mounted && token != null) {
        Fluttertoast.showToast(msg: 'loaded access token');
        setState(() {
          accessToken = token;
        });
      }
    });

    fcmToken = sl<FirebaseCloudMessagingManager>().currentFCMToken;
  }

  @override
  void dispose() {
    domainTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _devAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRoles(),
            _buildDomain(),
            const Divider(),
            _buildAccessToken(),
            const Divider(),
            _buildFCM(),
            // const Divider(),
            // _buildForceChangeAccessToken(),
          ],
        ),
      ),
    );
  }

  AppBar _devAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Dev Page - Tap to copy'),
      leading: IconButton(
        onPressed: widget.onBackPressed ?? () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        // btn change token
        IconButton(
          onPressed: () {
            sl<SecureStorageHelper>()
                .saveOrUpdateAccessToken(
                    'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ2MSIsImlhdCI6MTcxMjY2MzE4NCwiZXhwIjoxNzEyNzIzMTg0fQ.njQ0wEqDXmthW5kz7q2s_g-5Ot0CrMnb_6rrmqnUkfU')
                .then((_) => Fluttertoast.showToast(msg: 'expired token has been set'));
          },
          icon: const Icon(Icons.device_unknown),
        ),
      ],
    );
  }

  FutureBuilder<List<Role>?> _buildRoles() {
    return FutureBuilder(
      future: sl<SecureStorageHelper>().roles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final roles = snapshot.data!;
          return Text('${roles.length} Roles: $roles');
        }
        return const Text(
          'Chưa đăng nhập',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        );
      },
    );
  }

  // ignore: unused_element
  TextField _buildForceChangeAccessToken() {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'forceAccessToken',
        suffixIcon: IconButton(
          onPressed: () async {
            if (forceAccessToken != null) {
              final oldAccessToken = await sl<SecureStorageHelper>().accessToken;
              if (oldAccessToken != null) {
                // final newAuth = auth.copyWith(accessToken: forceAccessToken!);

                log('authBeforeSet: $oldAccessToken');
                await sl<SecureStorageHelper>().saveOrUpdateAccessToken(forceAccessToken ?? '');
                final authAfterSet = await sl<SecureStorageHelper>().accessToken;

                log('authAfterSet: $authAfterSet');

                Fluttertoast.showToast(msg: 'forceAccessToken has been set');
              }
            }
          },
          icon: const Icon(Icons.save),
        ),
      ),
      onChanged: (value) {
        setState(() {
          forceAccessToken = value;
        });
      },
    );
  }

  Column _buildFCM() {
    return Column(
      children: [
        // current FCM token
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: fcmToken ?? 'null'));
            Fluttertoast.showToast(msg: 'Copied to clipboard FCM token');
          },
          child: Column(
            children: [
              Row(
                children: [
                  const Text('FCM token:'),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: fcmToken ?? 'null'));
                      Fluttertoast.showToast(msg: 'Copied to clipboard FCM token');
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
              SelectableText('$fcmToken'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccessToken() {
    return Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: accessToken));
            Fluttertoast.showToast(msg: 'Copied to clipboard access token');
          },
          child: Column(
            children: [
              Row(
                children: [
                  const Text('accessToken:'),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: accessToken));
                      Fluttertoast.showToast(msg: 'Copied to clipboard accessToken');
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
              SelectableText(accessToken),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final accessToken = await sl<SecureStorageHelper>().accessToken;
            if (mounted && accessToken != null) {
              setState(() {
                Fluttertoast.showToast(msg: 'get current access token success');
                this.accessToken = accessToken;
              });
            }
          },
          child: const Text('Get current access token'),
        ),

        // call usecase to get new access token
        if (newAccessToken != null)
          GestureDetector(
            child: Text('newAccessToken: $newAccessToken'),
            onTap: () {
              Clipboard.setData(ClipboardData(text: newAccessToken ?? ''));
              Fluttertoast.showToast(msg: 'Copied to clipboard new access token');
            },
          ),
        ElevatedButton(
          onPressed: () async {
            // final result = await sl<CheckTokenUC>().call(accessToken);
            await sl<AuthCubit>().onStarted();
            // Fluttertoast.showToast(msg: 'result: $result');
            final currentToken = getCurrentToken();
            if (mounted && currentToken != null) {
              setState(() {
                newAccessToken = currentToken;
              });
            }
            if (newAccessToken == currentToken) {
              Fluttertoast.showToast(msg: 'SAME TOKEN');
            }
          },
          child: const Text('Check and get new access token'),
        ),
      ],
    );
  }

  Column _buildDomain() {
    return Column(
      children: <Widget>[
        Text('current Domain: $host'),
        TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Domain',
            suffixIcon: IconButton(
              onPressed: () async {
                await setDomain(domainTextController.text);
              },
              icon: const Icon(Icons.save),
            ),
          ),
          // init value
          controller: domainTextController,
          // save button
          onSubmitted: (value) async {
            await setDomain(value);
          },
        ),
      ],
    );
  }

  String? getCurrentToken() {
    return context.read<AuthCubit>().state.auth?.accessToken;
  }
}




// // expired token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ2MSIsImlhdCI6MTcxMjY2MzE4NCwiZXhwIjoxNzEyNzIzMTg0fQ.njQ0wEqDXmthW5kz7q2s_g-5Ot0CrMnb_6rrmqnUkfU
