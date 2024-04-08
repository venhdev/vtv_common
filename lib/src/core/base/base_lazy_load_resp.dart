import 'package:equatable/equatable.dart';

abstract class IBasePageResp<T> extends Equatable {
  const IBasePageResp({
    required this.listData,
    this.count,
    this.page,
    this.size,
    this.totalPage,
  });

  final List<T> listData;
  final int? count;
  final int? page;
  final int? size;
  final int? totalPage;

  @override
  List<Object?> get props => [
        listData,
        count,
        page,
        size,
        totalPage,
      ];
}
