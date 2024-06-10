import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';

showToastResult(
  RespData resp, {
  String successMsg = 'Thành công',
  String errorMsg = 'Có lỗi xảy ra, vui lòng thử lại sau!',
  VoidCallback? onSuccess,
  VoidCallback? onError,
  VoidCallback? onFinished,
}) {
  resp.fold(
    (error) {
      Fluttertoast.showToast(msg: error.message ?? errorMsg);
      onError?.call();
    },
    (ok) {
      Fluttertoast.showToast(msg: ok.message ?? successMsg);
      onSuccess?.call();
    },
  );
  onFinished?.call();
}
