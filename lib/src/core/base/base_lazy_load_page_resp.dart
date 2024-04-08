import 'package:equatable/equatable.dart';

abstract class IBasePageResp<T> extends Equatable {
  const IBasePageResp({
    required this.listItem,
    this.count,
    this.page,
    this.size,
    this.totalPage,
  });

  final List<T> listItem;
  final int? count;
  final int? page;
  final int? size;
  final int? totalPage;

  @override
  List<Object?> get props => [
        listItem,
        count,
        page,
        size,
        totalPage,
      ];
}
