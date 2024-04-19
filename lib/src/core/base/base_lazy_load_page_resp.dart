import 'package:equatable/equatable.dart';

abstract class IBasePageResp<T> extends Equatable {
  const IBasePageResp({
    required this.items,
    this.count,
    this.page,
    this.size,
    this.totalPage,
  });

  final List<T> items;
  final int? count;
  final int? page;
  final int? size;
  final int? totalPage;

  @override
  List<Object?> get props => [
        items,
        count,
        page,
        size,
        totalPage,
      ];
}
