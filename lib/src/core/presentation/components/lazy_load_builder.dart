import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../base/base_lazy_load_page_resp.dart';
import '../../constants/typedef.dart';

// OK_BUG rebuild when the parent long list is scrolled >> lost data + rebuild lazy load
//: DONE create a controller to keep the data + current page

class LazyController<T> extends ChangeNotifier {
  LazyController({
    required this.items,
    required this.paginatedData,
    this.scrollController,
    this.auto = false,
    this.useGrid = true,
    this.crossAxisCount = 2,
    this.showPageIndicator = false,
    this.showLoadingIndicator = false,
    this.showLoadMoreButton = false,
    this.lastPageMessage = 'Cuối trang',
    this.loadMoreButtonLabel = 'Xem thêm',
    this.loadMoreButtonStyle,
  })  : currentPage = 0,
        isLoading = false,
        isReachTheEnd = false,
        assert(useGrid && crossAxisCount > 0 || !useGrid),
        assert(!auto || auto && scrollController != null);

  // load more button getter
  Widget get loadMoreButton => ElevatedButton(
        onPressed: loadNextPage,
        child: Text(loadMoreButtonLabel, style: loadMoreButtonStyle),
      );

  //# required fields
  final FRespData<IBasePageResp<T>> Function(int page) paginatedData;
  final ScrollController? scrollController;
  List<T> items;
  int currentPage;

  //# control fields
  bool isLoading;
  bool isReachTheEnd;

  /// auto load next page when reach the end, default is false
  /// - if true, the [loadNextPage] will be called when the scroll reach the end of the list.
  /// [scrollController] must be provided,
  /// and do not pass this controller to any other widget.
  /// - if false, the [loadNextPage] will be called manually.
  bool auto;

  //# style fields
  /// Message to show when the list is empty (reach the end of the list or no data)
  final String lastPageMessage;

  /// Show loading indicator when loading more items (default is false)
  final bool showLoadingIndicator; //> use with auto load is true

  /// Show load more button when loading more items (default is false)
  final bool showLoadMoreButton; //> use with auto load is false

  /// Show bottom page indicator to indicate the current page (default is false)
  final bool showPageIndicator; // to-do: --not implement yet

  /// Use GridView or ListView (default is GridView)
  final bool useGrid;
  final int crossAxisCount; // only for GridView

  final String loadMoreButtonLabel;
  final TextStyle? loadMoreButtonStyle;

  //# methods
  void init() {
    currentPage = 0;
    items.clear();
    loadNextPage();

    if (auto) {
      log('[LazyLoadController] auto load');
      scrollController!.addListener(() {
        if (scrollController!.position.pixels == scrollController!.position.maxScrollExtent) {
          log('[LazyLoadController] Reach the end of the list, load next page (auto: $auto)');
          loadNextPage();
        }
      });
    }
  }

  // refresh
  FutureOr<void> refresh() {
    currentPage = 0;
    items.clear();
    isReachTheEnd = false;
    notifyListeners();
    loadNextPage();
  }

  // load next page
  Future<void> loadNextPage() async {
    if (isReachTheEnd) {
      log('[LazyLoadController] Already reach the end at page $currentPage, no call API anymore');
      return;
    }

    if (!isLoading) {
      isLoading = true;
      notifyListeners();

      final dataEither = await paginatedData(currentPage + 1);
      dataEither.fold(
        (error) {
          // Fluttertoast.showToast(msg: '${error.message}');
          log('[LazyLoadController] Error: ${error.message}');
        },
        (dataResp) {
          final newItems = dataResp.data!.items;
          if (newItems.isEmpty) {
            log('[LazyLoadController] Reach the end at page $currentPage');
            isReachTheEnd = true;
          } else {
            currentPage++;
            isReachTheEnd = false;
          }
          log('[LazyLoadController] Load ${newItems.length} items at page $currentPage ');
          items.addAll(newItems);
        },
      );

      isLoading = false;
      notifyListeners();
    }
  }

  //add
  void addItems(List<T> newItems) {
    items.addAll(newItems);
    notifyListeners();
  }

  void removeAt(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  @override
  String toString() {
    return 'LazyLoadController(showIndicator: $showLoadingIndicator, useGrid: $useGrid, crossAxisCount: $crossAxisCount, itemLength: ${items.length})';
  }
}

class LazyLoadBuilder<T> extends StatefulWidget {
  const LazyLoadBuilder({
    super.key,
    required this.lazyController,
    required this.itemBuilder,
  });

  final LazyController<T> lazyController;
  final Widget Function(BuildContext context, int index, T data) itemBuilder;

  @override
  State<LazyLoadBuilder<T>> createState() => _LazyLoadBuilderState<T>();
}

class _LazyLoadBuilderState<T> extends State<LazyLoadBuilder<T>> {
  //> scrollController dispose handled by parent
  @override
  void initState() {
    log('[LazyLoadBuilder] initState()');
    super.initState();
    // listen to the changes of the lazy controller
    widget.lazyController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    log('[LazyLoadBuilder] dispose()');
    widget.lazyController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('[LazyLoadBuilder] build with ${widget.lazyController.items.length} items');
    //# empty list
    if (widget.lazyController.items.isEmpty && !widget.lazyController.isLoading) {
      return Center(
        child: Text(
          widget.lazyController.lastPageMessage,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }
    // REVIEW here
    //? scrollController passed from parent
    //: 1: Disable the physics of the GridView & shrinkWrap it
    //! 2: Use the parent's scrollController --no longer use internal scrollController
    return widget.lazyController.useGrid ? _buildLazyLoadWithGridView() : _buildLazyLoadWithListView();
  }

  ListView _buildLazyLoadWithListView() {
    return ListView.builder(
      controller: widget.lazyController.auto ? widget.lazyController.scrollController! : null,
      physics: widget.lazyController.auto ? null : const NeverScrollableScrollPhysics(),
      shrinkWrap: widget.lazyController.auto ? false : true,
      padding: EdgeInsets.zero,
      itemCount: widget.lazyController.showLoadingIndicator || widget.lazyController.showLoadMoreButton
          ? widget.lazyController.items.length + 1
          : widget.lazyController.items.length,
      itemBuilder: (context, index) {
        if (widget.lazyController.items.isEmpty && widget.lazyController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == widget.lazyController.items.length) {
          return Center(
              // child: widget.lazyController.isLoading
              //     ? const CircularProgressIndicator()
              //     : !widget.lazyController.isReachTheEnd
              //         ? Container() //??
              //         : Text(widget.lazyController.lastPageMessage),
              child: widget.lazyController.isLoading
                  ? widget.lazyController.showLoadingIndicator || widget.lazyController.showLoadMoreButton
                      ? const CircularProgressIndicator()
                      : Container() //show nothing when loading
                  : widget.lazyController.isReachTheEnd //# end of list when not loading
                      ? Text(widget.lazyController.lastPageMessage)
                      // : Container() //show nothing when reach the end
                      : widget.lazyController.showLoadMoreButton
                          ? ElevatedButton(
                              onPressed: () {
                                widget.lazyController.loadNextPage();
                              },
                              child: Text(widget.lazyController.loadMoreButtonLabel,
                                  style: widget.lazyController.loadMoreButtonStyle),
                            )
                          : Container() // show nothing in case of not loading && not reach the end && not show load more button (rare case)
              );
        } else {
          return widget.itemBuilder(context, index, widget.lazyController.items[index]);
        }
      },
    );
  }

  Widget _buildLazyLoadWithGridView() {
    return GridView.builder(
      controller: widget.lazyController.auto ? widget.lazyController.scrollController! : null,
      physics: widget.lazyController.auto ? null : const NeverScrollableScrollPhysics(),
      shrinkWrap: widget.lazyController.auto ? false : true,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.lazyController.crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.lazyController.showLoadingIndicator || widget.lazyController.showLoadMoreButton
          ? widget.lazyController.items.length + 1
          : widget.lazyController.items.length,
      itemBuilder: (context, index) {
        if (widget.lazyController.items.isEmpty && widget.lazyController.isLoading) {
          //> show when [items] is empty and [isLoading] is true
          return const Center(child: CircularProgressIndicator());
        } else if (index == widget.lazyController.items.length) {
          //> only show when [showLoadingIndicator || showLoadMoreButton] is true >> length + 1
          return Center(
              // child: widget.lazyController.isLoading
              //     ? const CircularProgressIndicator()
              //     : !widget.lazyController.isReachTheEnd
              //         ? Container() //show nothing when loading
              //         : Text(widget.lazyController.lastPageMessage),

              child: widget.lazyController.isLoading
                  ? widget.lazyController.showLoadingIndicator || widget.lazyController.showLoadMoreButton
                      ? const CircularProgressIndicator()
                      : Container() //show nothing when loading
                  : widget.lazyController.isReachTheEnd //# end of list when not loading
                      ? Text(widget.lazyController.lastPageMessage)
                      // : Container() //show nothing when reach the end
                      : widget.lazyController.showLoadMoreButton
                          ? ElevatedButton(
                              onPressed: () {
                                widget.lazyController.loadNextPage();
                              },
                              child: Text(widget.lazyController.loadMoreButtonLabel,
                                  style: widget.lazyController.loadMoreButtonStyle),
                            )
                          : Container() // show nothing in case of not loading && not reach the end && not show load more button (rare case)
              );
        } else {
          return widget.itemBuilder(context, index, widget.lazyController.items[index]);
        }
      },
    );
  }
}
