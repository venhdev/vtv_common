import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../constants/types.dart';
import '../custom_widgets.dart';

class FutureListBuilder<T, V> extends StatefulWidget {
  const FutureListBuilder({
    super.key,
    required this.futureListController,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding,
  });

  final FutureListController<T, V> futureListController;
  final Widget Function(BuildContext context, int index, T data) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final EdgeInsets? padding;

  @override
  State<FutureListBuilder<T, V>> createState() => _FutureListBuilderState<T, V>();
}

class _FutureListBuilderState<T, V> extends State<FutureListBuilder<T, V>> {
  //> scrollController dispose handled by parent
  @override
  void initState() {
    log('[FutureListBuilder] initState() --${widget.futureListController.debugLabel ?? 'no label'}--');
    super.initState();
    // listen to the changes of the future list controller
    widget.futureListController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    log('[FutureListBuilder] dispose() --${widget.futureListController.debugLabel ?? 'no label'}--');
    widget.futureListController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('[FutureListBuilder] build with ${widget.futureListController.items.length} items');
    //# initial state
    if (widget.futureListController.isInitial) {
      return widget.futureListController.fBuilder?.initialBuilder ?? FWidgetBuilder._defaultLoadingBuilder;
    } else if (widget.futureListController.isLoading) {
      return widget.futureListController.fBuilder?.loadingBuilder ?? FWidgetBuilder._defaultLoadingBuilder;
    } else if (widget.futureListController.isLoaded) {
      return widget.futureListController.useGrid ? _buildFutureListByGridView() : _buildFutureListByListView();
    } else {
      return widget.futureListController.fBuilder?.errorBuilder ?? FWidgetBuilder._defaultErrorBuilder;
    }
  }

  ListView _buildFutureListByListView() {
    final canScroll = widget.futureListController.scrollable;
    return ListView.separated(
      separatorBuilder: widget.separatorBuilder ?? (context, index) => const SizedBox.shrink(),
      controller: canScroll ? widget.futureListController.scrollController : null,
      physics: canScroll ? null : const NeverScrollableScrollPhysics(),
      shrinkWrap: canScroll ? false : true,
      padding: widget.padding ?? EdgeInsets.zero,
      reverse: widget.futureListController.reverse,
      scrollDirection: widget.futureListController.scrollDirection,
      itemCount: widget.futureListController.items.length,
      itemBuilder: (context, index) => widget.itemBuilder(context, index, widget.futureListController.items[index]),
    );
  }

  GridView _buildFutureListByGridView() {
    final canScroll = widget.futureListController.scrollable;
    return GridView.builder(
      controller: canScroll ? widget.futureListController.scrollController! : null,
      physics: canScroll ? null : const NeverScrollableScrollPhysics(),
      shrinkWrap: canScroll ? false : true,
      padding: widget.padding ?? EdgeInsets.zero,
      reverse: widget.futureListController.reverse,
      scrollDirection: widget.futureListController.scrollDirection,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.futureListController.crossAxisCount, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: widget.futureListController.items.length,
      itemBuilder: (context, index) => widget.itemBuilder(context, index, widget.futureListController.items[index]),
    );
  }
}

//*-------------------------------------------------CONTROLLER---------------------------------------------------*//

/// - [T] is the type of each item in the list
/// - [V] is the type of the data returned from the future
class FutureListController<T, V> extends ChangeNotifier {
  FutureListController({
    required this.items,
    required this.futureCallback,
    required this.parse,
    this.fBuilder,
    this.useGrid = true,
    this.crossAxisCount = 2,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.beforeLoadCallback,
    this.afterLoadCallback,
    this.scrollable = false,
  })  : _loadStatus = LoadStatus.initial,
        assert(useGrid && crossAxisCount > 0 || !useGrid) {
    if (scrollable) scrollController = ScrollController();
    if (filterable) filteredItems = [];
  }

  //# UI
  /// when use [build] method, this method will be invoked to [fBuilder] with corresponding status
  final FWidgetBuilder<T>? fBuilder;

  //# required fields
  final Future<V> Function() futureCallback;
  final List<T>? Function(V unparsedData, void Function({VoidCallback? errorCallback, String? errorMsg}) onParseError)
      parse;
  List<T> items;

  //# filter fields
  bool get filterable => _filterCallback != null;
  List<T> Function(List<T> currentItems, List<T> currentFilteredItems)? _filterCallback;
  List<T>? filteredItems;
  void setFilterCallback(List<T> Function(List<T> currentItems, List<T> currentFilteredItems) filterCallback) {
    _filterCallback = filterCallback;
    filteredItems ??= [];
  }

  //# control fields
  final bool scrollable;
  ScrollController? scrollController;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  LoadStatus _loadStatus;
  bool get isInitial => _loadStatus == LoadStatus.initial;
  bool get isLoading => _loadStatus == LoadStatus.loading;
  bool get isLoaded => _loadStatus == LoadStatus.loaded;
  bool get isError => _loadStatus == LoadStatus.error;

  //# style fields
  final bool reverse;
  final Axis scrollDirection;

  /// Use GridView or ListView (default is GridView)
  final bool useGrid;
  final int crossAxisCount; // only for GridView

  final Future<void> Function()? beforeLoadCallback;
  final Future<void> Function()? afterLoadCallback;

  //# debug
  String? debugLabel;

  //# methods
  /// set [clear] to false if there are some initial items
  void init({bool clear = true}) {
    if (clear) items.clear();
    loadData().then((_) {
      afterLoadCallback?.call();
    });
  }

  void refresh() {
    if (isLoading) return;
    loadData();
  }

  void performFilter() {
    if (filterable) {
      filteredItems = _filterCallback!(items, filteredItems!);
      notifyListeners();
    }
  }

  Future<void> loadData({bool clear = true}) async {
    //> if already loading, do nothing ?? only load when: initial, loaded, error
    if (isLoading) return;

    _loadStatus = LoadStatus.loading;
    notifyListeners();

    //> callback before load next page
    await beforeLoadCallback?.call();

    final response = await futureCallback();

    final List<T>? parsed = parse(response, ({errorCallback, errorMsg}) {
      log('[FutureListController--$debugLabel--] Error when parsing data: $errorMsg');
      errorCallback?.call();
    });

    if (parsed == null) {
      _loadStatus = LoadStatus.error;
      return;
    } else {
      if (clear) items.clear();
      items.addAll(parsed);
      _loadStatus = LoadStatus.loaded;
    }

    notifyListeners();
  }

  //*---------------------Control Items-----------------------*//
  void addAll(List<T> newItems) {
    items.addAll(newItems);
    notifyListeners();
  }

  void insertAt(int index, T item) {
    items.insert(index, item);
    notifyListeners();
  }

  void removeAt(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  void updateAt(int index, T item) {
    items[index] = item;
    notifyListeners();
  }

  void clear() {
    items.clear();
    notifyListeners();
  }

  //*---------------------UI-----------------------*//
  /// Build the item widget at index with corresponding load status -- [fBuilder] must be provided
  Widget build(BuildContext context, int index) {
    assert(fBuilder != null, 'fBuilder must be provided when use "build" method');

    if (items.isEmpty && isInitial) {
      return fBuilder!.initialBuilder;
    } else if (items.isEmpty && isLoading) {
      return fBuilder!.loadingBuilder;
    } else if (items.isEmpty && isLoaded) {
      return fBuilder!.emptyBuilder;
    } else if (items.isNotEmpty && isLoaded) {
      return fBuilder!.itemBuilder(context, index, items[index]);
    } else {
      return fBuilder!.errorBuilder;
    }
  }
}

class FWidgetBuilder<T> {
  static const _defaultLoadingBuilder = Center(child: CircularProgressIndicator());
  static const _defaultEmptyBuilder =
      MessageScreen(message: 'Danh sách trống', textStyle: TextStyle(fontSize: 12, color: Colors.grey));
  static const _defaultErrorBuilder =
      MessageScreen(message: 'Đã xảy ra lỗi', textStyle: TextStyle(fontSize: 12, color: Colors.red));

  FWidgetBuilder({
    this.initialBuilder = _defaultLoadingBuilder,
    this.loadingBuilder = _defaultLoadingBuilder,
    required this.itemBuilder,
    this.emptyBuilder = _defaultEmptyBuilder,
    this.errorBuilder = _defaultErrorBuilder,
  });

  Widget initialBuilder;
  Widget loadingBuilder;
  final Widget Function(BuildContext context, int index, T data) itemBuilder;
  Widget emptyBuilder;
  Widget errorBuilder;
}
