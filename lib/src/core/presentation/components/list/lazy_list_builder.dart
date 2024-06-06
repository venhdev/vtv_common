import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../base/base_lazy_load_page_resp.dart';
import '../../../constants/typedef.dart';
import '../../../themes.dart';

const int _defaultPageSize = 10;

class LazyListBuilder<T> extends StatefulWidget {
  const LazyListBuilder({
    super.key,
    required this.lazyListController,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding,
  });

  final LazyListController<T> lazyListController;
  final Widget Function(BuildContext context, int index, T data) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final EdgeInsets? padding;

  @override
  State<LazyListBuilder<T>> createState() => _LazyListBuilderState<T>();
}

class _LazyListBuilderState<T> extends State<LazyListBuilder<T>> {
  //> scrollController dispose handled by parent
  @override
  void initState() {
    log('[LazyListBuilder] initState() --${widget.lazyListController.debugLabel ?? 'no label'}--');
    super.initState();
    // listen to the changes of the lazy controller
    widget.lazyListController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    log('[LazyListBuilder] dispose() --${widget.lazyListController.debugLabel ?? 'no label'}--');
    widget.lazyListController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // assert(widget.separatorBuilder != null || widget.lazyController.useGrid);

    log('[LazyListBuilder] build with ${widget.lazyListController.items.length} items');
    //# empty list
    if (widget.lazyListController.items.isEmpty && !widget.lazyListController.isLoading) {
      return widget.lazyListController.emptyBuilder ??
          Center(
            child: Text(
              widget.lazyListController.lastPageMessage,
              style: VTVTheme.hintText12,
            ),
          );
    }
    //! ``Deprecated note``
    //? scrollController passed from parent
    //: 1: Disable the physics of the GridView & shrinkWrap it
    //! 2: Use the parent's scrollController --no longer use internal scrollController
    return widget.lazyListController.useGrid ? _buildLazyLoadWithGridView() : _buildLazyLoadWithListView();
  }

  //> only build when [showLoadingIndicator || showLoadMoreButton] is true >> length itemCount + 1
  Widget _buildWhenScrollToEnd() {
    return Center(
        child: widget.lazyListController.isLoading
            ? widget.lazyListController.showLoadingIndicator || widget.lazyListController.showLoadMoreButton
                ? const CircularProgressIndicator()
                : Container() //show nothing when loading
            : widget.lazyListController.isReachTheEnd //# if reach the end of the list
                ? Text(widget.lazyListController.lastPageMessage)
                : widget.lazyListController.showLoadMoreButton
                    ? ElevatedButton(
                        onPressed: () => widget.lazyListController.loadNextPage(),
                        child: Text(widget.lazyListController.loadMoreButtonLabel,
                            style: widget.lazyListController.loadMoreButtonStyle),
                      )
                    : Container() // show nothing in case of not loading && not reach the end && not show load more button (rare case)
        );
  }

  ListView _buildLazyLoadWithListView() {
    final canScroll = widget.lazyListController.auto || widget.lazyListController.scrollable;
    return ListView.separated(
      separatorBuilder: widget.separatorBuilder ?? (context, index) => const SizedBox.shrink(),
      controller: canScroll ? widget.lazyListController.scrollController! : null,
      physics: canScroll ? null : const NeverScrollableScrollPhysics(),
      shrinkWrap: canScroll ? false : true,
      padding: widget.padding ?? EdgeInsets.zero,
      reverse: widget.lazyListController.reverse,
      scrollDirection: widget.lazyListController.scrollDirection,
      itemCount: widget.lazyListController.showLoadingIndicator || widget.lazyListController.showLoadMoreButton
          ? widget.lazyListController.items.length + 1
          : widget.lazyListController.items.length,
      itemBuilder: (context, index) {
        if (widget.lazyListController.items.isEmpty && widget.lazyListController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == widget.lazyListController.items.length) {
          return _buildWhenScrollToEnd();
        } else {
          return widget.itemBuilder(context, index, widget.lazyListController.items[index]);
        }
      },
    );
  }

  Widget _buildLazyLoadWithGridView() {
    final canScroll = widget.lazyListController.auto || widget.lazyListController.scrollable;
    return GridView.builder(
      controller: canScroll ? widget.lazyListController.scrollController! : null,
      physics: canScroll ? null : const NeverScrollableScrollPhysics(),
      shrinkWrap: canScroll ? false : true,
      padding: widget.padding ?? EdgeInsets.zero,
      reverse: widget.lazyListController.reverse,
      scrollDirection: widget.lazyListController.scrollDirection,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.lazyListController.crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.lazyListController.showLoadingIndicator || widget.lazyListController.showLoadMoreButton
          ? widget.lazyListController.items.length + 1
          : widget.lazyListController.items.length,
      itemBuilder: (context, index) {
        if (widget.lazyListController.items.isEmpty && widget.lazyListController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == widget.lazyListController.items.length) {
          return _buildWhenScrollToEnd();
        } else {
          return widget.itemBuilder(context, index, widget.lazyListController.items[index]);
        }
      },
    );
  }
}

/// Call `init()` with [auto] set to true for auto load next page when reach the end of the list.
///
/// Use [itemCount] instead of `items.length`
class LazyListController<T> extends ChangeNotifier {
  LazyListController({
    required this.items,
    required this.paginatedData,
    this.size = _defaultPageSize,
    this.itemBuilder,
    this.emptyBuilder,
    this.scrollController,
    this.auto = false,
    this.useGrid = true,
    this.crossAxisCount = 2,
    this.showPageIndicator = false,
    this.showLoadingIndicator = false,
    this.showLoadMoreButton = false,
    this.lastPageMessage = 'Đã đến cuối trang',
    this.loadMoreButtonLabel = 'Xem thêm',
    this.loadMoreButtonStyle,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.callBackBeforeLoadNextPage,
    this.scrollable = false,
  })  : currentPage = 0,
        isLoading = false,
        isReachTheEnd = false,
        debugLabel = null,
        assert(useGrid && crossAxisCount > 0 || !useGrid),
        assert(!auto || auto && scrollController != null);

  //> sliver version: only need this controller passed SliverList in CustomScrollView
  // SliverList.separated(
  //   itemCount: _lazyListController.items.length,
  //   itemBuilder: _lazyListController.build,
  //   separatorBuilder: (context, index) => const Divider(),
  // ),
  LazyListController.sliver({
    required this.items,
    required this.paginatedData,
    this.size = _defaultPageSize,
    this.itemBuilder,
    this.emptyBuilder,
    this.scrollController,
    this.showLoadingIndicator = false,
    this.showLoadMoreButton = false,
    this.lastPageMessage = 'Đã đến cuối trang',
    this.loadMoreButtonLabel = 'Xem thêm',
    this.loadMoreButtonStyle,
    this.crossAxisCount = 2,
    this.useGrid = true,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.callBackBeforeLoadNextPage,
    this.scrollable = false,
  })  : currentPage = 0,
        showPageIndicator = false,
        auto = false,
        isLoading = false,
        isReachTheEnd = false,
        debugLabel = null;

  LazyListController.static({
    required this.items,
    this.itemBuilder,
    this.emptyBuilder,
    this.lastPageMessage = 'Đã đến cuối trang',
    this.crossAxisCount = 2,
    this.useGrid = true,
    this.reverse = false,
    this.scrollable = false,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
  })  : currentPage = 0,
        showLoadMoreButton = false,
        showLoadingIndicator = false,
        loadMoreButtonLabel = '',
        callBackBeforeLoadNextPage = null,
        loadMoreButtonStyle = null,
        size = _defaultPageSize,
        paginatedData = null,
        showPageIndicator = false,
        auto = false,
        isLoading = false,
        isReachTheEnd = false,
        debugLabel = null;

  /// when use [build] method, this method will be invoked to build the item
  final Widget Function(BuildContext context, int index, T data)? itemBuilder;
  final Widget? emptyBuilder;

  //# required fields
  final FRespData<IBasePageResp<T>> Function(int page, int size)? paginatedData;
  final ScrollController? scrollController;
  List<T> items;
  int currentPage;
  final int size;

  //# control fields
  int get itemCount {
    if (showLoadMoreButton || showLoadingIndicator) {
      return items.length + 1;
    } else {
      return items.length;
    }
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  bool isLoading;
  bool isReachTheEnd;

  /// auto load next page when reach the end, default is false
  /// - if true, the [loadNextPage] will be called when the scroll reach the end of the list.
  /// [scrollController] must be provided, and do not pass this controller to any other widget.
  /// - if false, the [loadNextPage] will be called manually.
  final bool auto;
  final bool scrollable;

  //# style fields
  final bool reverse;
  final Axis scrollDirection;

  /// Message to show when the list is empty (reach the end of the list or no data)
  final String lastPageMessage;

  /// Show loading indicator when loading more items (default is false)
  final bool showLoadingIndicator; //> use with auto load is true

  /// Show load more button when loading more items (default is false)
  final bool showLoadMoreButton; //> use with auto load is false

  /// Show bottom page indicator to indicate the current page (default is false)
  final bool showPageIndicator; //TODO: --not implement yet

  /// Use GridView or ListView (default is GridView)
  final bool useGrid;
  final int crossAxisCount; // only for GridView

  final String loadMoreButtonLabel;
  final TextStyle? loadMoreButtonStyle;
  final Future<void> Function()? callBackBeforeLoadNextPage;

  //# debug
  String? debugLabel;
  void setDebugLabel(String label) {
    debugLabel = label;
  }

  //# methods
  void init({VoidCallback? onInitCompleted, bool clear = true}) {
    if (clear) {
      currentPage = 0;
      items.clear();
    }
    loadNextPage().then((_) {
      onInitCompleted?.call();
    });

    if (auto) {
      log('[LazyListController] auto load');
      // remove all listeners before add new one
      scrollController!.removeListener(() {});
      scrollController!.addListener(() {
        if (scrollController!.position.pixels == scrollController!.position.maxScrollExtent) {
          log('[LazyListController] auto load - Reach the end of the list, load next page (auto: $auto)');
          loadNextPage();
        }
      });
    }
  }

  /// clear the current data and load the first page
  FutureOr<void> refresh() {
    currentPage = 0;
    items.clear();
    isReachTheEnd = false;
    notifyListeners();
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (isReachTheEnd) {
      log('[LazyListController] Already reach the end at page $currentPage, no call API anymore');
      return;
    }

    if (!isLoading) {
      if (paginatedData == null) {
        log('[LazyListController] paginatedData is null, use other constructor (not static) to use loadNextPage() method');
        return;
      }
      isLoading = true;
      notifyListeners();

      //> callback before load next page
      await callBackBeforeLoadNextPage?.call();

      final dataEither = await paginatedData!(currentPage + 1, size);
      dataEither.fold(
        (error) {
          // Fluttertoast.showToast(msg: '${error.message}');
          log('[LazyListController] Error: ${error.message}');
        },
        (dataResp) {
          final newItems = dataResp.data!.items;
          if (newItems.isEmpty) {
            log('[LazyListController] Reach the end at page $currentPage');
            isReachTheEnd = true;
          } else {
            currentPage++;
            isReachTheEnd = false;
          }
          log('[LazyListController] Load ${newItems.length} items at page $currentPage ');
          items.addAll(newItems);
        },
      );

      isLoading = false;
      notifyListeners();
    }
  }

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

  //!! UI
  // load more button getter
  Widget get loadMoreButton => ElevatedButton(
        onPressed: loadNextPage,
        child: Text(loadMoreButtonLabel, style: loadMoreButtonStyle),
      );

  /// build the item widget at index [itemBuilder] must be provided
  Widget build(BuildContext context, int index) {
    assert(itemBuilder != null, 'itemBuilder must be provided when use this method');

    if (this.items.isEmpty && this.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (index == this.items.length) {
      //> show loading indicator or load more button
      return Center(
          child: this.isLoading
              ? this.showLoadingIndicator || this.showLoadMoreButton
                  ? const CircularProgressIndicator()
                  : const SizedBox() //show nothing when loading
              : this.isReachTheEnd //# end of list when not loading (no more data)
                  ? Text(this.lastPageMessage)
                  : this.showLoadMoreButton
                      ? ElevatedButton(
                          onPressed: () {
                            this.loadNextPage();
                          },
                          child: Text(this.loadMoreButtonLabel, style: this.loadMoreButtonStyle),
                        )
                      : const SizedBox() // show nothing in case of not loading && not reach the end && not show load more button (rare case)
          );
    } else {
      return itemBuilder!(context, index, this.items[index]);
    }
  }
}
