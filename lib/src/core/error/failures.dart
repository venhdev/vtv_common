import 'package:equatable/equatable.dart';

import '../network/error_response.dart';

// General failure message
const String failureMessage = 'Có lỗi xảy ra, vui lòng thử lại sau';
const String connectionFailureMessage = 'Lỗi kết nối';
const String cacheFailureMessage = 'Lỗi lưu trữ cục bộ';

class Failure extends Equatable {
  factory Failure.fromResp(ErrorResponse resp) {
    return Failure(message: resp.message ?? 'Lỗi không xác định từ server');
  }
  const Failure({
    this.message = failureMessage,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}

// General failure message
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = failureMessage,
  });
}

// No code failure
class ConnectionFailure extends Failure {
  const ConnectionFailure({
    super.message = connectionFailureMessage,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = cacheFailureMessage,
  });
}
