import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

import 'package:vtv_common/src/core/base/base_redirect.dart';

void main() {
  test('01', () {
    final logger = Logger();
    final authRedirect = AuthRedirect(redirect: {
      RedirectType.logoutSuccess: () {
        logger.i('Logout success');
      },
      RedirectType.loginSuccess: () {
        logger.i('Login success');
      },
      RedirectType.loginFailure: () {
        logger.i('Login failure');
      },
    });

    authRedirect.go(RedirectType.logoutSuccess);

    authRedirect.go(RedirectType.loginSuccess);

    authRedirect.go(RedirectType.loginFailure);
  });
}

class AuthRedirect extends BaseRedirect<Enum> {
  AuthRedirect({required super.redirect});
}

enum RedirectType {
  logoutSuccess,
  loginSuccess,
  loginFailure,
}
