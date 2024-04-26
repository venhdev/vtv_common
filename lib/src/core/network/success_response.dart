import '../base/base_response.dart';

class SuccessResponse<T extends Object?> extends BaseHttpResponse {
  const SuccessResponse({
    super.code,
    super.message,
    super.status,
    this.data,
  });

  final T? data;

  @override
  List<Object?> get props => [
        data,
        code,
        message,
        status,
      ];

  @override
  bool get stringify => true;
}


// class SuccessResponse<T> extends SuccessResponse {
//   const SuccessResponse(
//     this.data, {
//     super.code,
//     super.message,
//     super.status,
//   });

//   final T data;

//   @override
//   List<Object?> get props => [
//         code,
//         message,
//         status,
//         data,
//       ];

//   @override
//   bool get stringify => true;
// }
