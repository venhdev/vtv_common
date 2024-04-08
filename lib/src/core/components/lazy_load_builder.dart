import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../base/base_lazy_load_resp.dart';
import '../constants/typedef.dart';

class LazyLoadBuilder<T> extends StatefulWidget {
  const LazyLoadBuilder({
    super.key,
    required this.dataCallback,
    this.scrollController,
    this.crossAxisCount = 2,
    this.emptyMessage = 'Trống',
    required this.itemBuilder,
    this.showIndicator = false,
  }) : assert(crossAxisCount > 0);

  final Future<RespData<IBasePageResp<T>>> Function(int page) dataCallback;
  final int crossAxisCount;
  final String emptyMessage;
  final ScrollController? scrollController; //: null -> use internal scrollController
  final Widget Function(BuildContext context, int index, T data) itemBuilder;

  /// Show loading indicator at the end of the list
  final bool showIndicator;

  @override
  State<LazyLoadBuilder<T>> createState() => _LazyLoadBuilderState<T>();
}

class _LazyLoadBuilderState<T> extends State<LazyLoadBuilder<T>> {
  late ScrollController _scrollController;
  late int _currentPage;
  bool _isLoading = false;
  String? _message;
  final List<T> _items = [];

  @override
  void dispose() {
    //> dispose the scrollController if it's internal
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
    } else {
      _scrollController = ScrollController();
    }
    _currentPage = 1;
    _loadData(_currentPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
        _loadData(_currentPage);
      }
    });
  }

  Future<void> _loadData(int page) async {
    if (!_isLoading) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      await Future.delayed(const Duration(milliseconds: 500));

      List<T> data;
      final dataEither = await widget.dataCallback(page);
      data = dataEither.fold(
        (error) {
          Fluttertoast.showToast(msg: '${error.message}');
          return [];
        },
        (dataResp) {
          final newItems = dataResp.data.listData;
          if (newItems.isEmpty) {
            log('[LazyLoadBuilder] No more items at page $page');
            _message = 'No more items';
          } else {
            _currentPage++; // After loading data, increase the current page by 1
          }
          return newItems;
        },
      );

      if (mounted) {
        setState(() {
          log('[LazyLoadBuilder] load more ${data.length} items at page $page');
          _items.addAll(data);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log('[LazyLoadBuilder] build with ${_items.length} items');
    if (_items.isEmpty && !_isLoading) {
      return Center(
        child: Text(
          widget.emptyMessage,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }
    //? If parent passes the scrollController
    //: 1: Disable the physics of the GridView & shrinkWrap it
    //: 2: Use the parent's scrollController
    return ListView.builder(
      controller: widget.scrollController != null ? null : _scrollController,
      physics: widget.scrollController != null ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: widget.scrollController != null ? true : false,
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: widget.crossAxisCount,
      //   crossAxisSpacing: 8,
      //   mainAxisSpacing: 8,
      // ),
      itemCount: widget.showIndicator ? _items.length + 1 : _items.length,
      itemBuilder: (context, index) {
        if (_items.isEmpty && _isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == _items.length) {
          return Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _message == null
                    ? Container()
                    : Text('$_message'),
          );
        } else {
          return widget.itemBuilder(context, index, _items[index]);
        }
      },
    );
  }
}
