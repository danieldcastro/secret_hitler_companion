import 'package:flutter/foundation.dart';

class BookController extends ChangeNotifier {
  int _page;

  BookController({int initialPage = 0}) : _page = initialPage;

  int get page => _page;

  void setPage(int value) {
    if (_page != value) {
      _page = value;
      notifyListeners();
    }
  }

  void nextPage() {
    _addRequest(BookRequest.next());
  }

  void previousPage() {
    _addRequest(BookRequest.previous());
  }

  void goToPage(int index) {
    if (index != _page) {
      _addRequest(BookRequest.jump(index));
    }
  }

  void goToFirstPage() {
    goToPage(0);
  }

  void goToLastPage(int totalPages) {
    goToPage(totalPages);
  }

  bool canGoNext(int totalPages) => _page < totalPages;

  bool canGoPrevious() => _page > 0;

  bool get hasRequests => _requests.isNotEmpty;

  final List<BookRequest> _requests = [];

  void _addRequest(BookRequest request) {
    if (_requests.isNotEmpty) {
      final lastRequest = _requests.last;

      if (request.type == BookRequestType.jump &&
          lastRequest.type == BookRequestType.jump) {
        _requests
          ..removeLast()
          ..add(request);
        notifyListeners();
        return;
      }

      if ((request.type == BookRequestType.next &&
              lastRequest.type == BookRequestType.next) ||
          (request.type == BookRequestType.previous &&
              lastRequest.type == BookRequestType.previous)) {
        return;
      }

      if ((request.type == BookRequestType.next &&
              lastRequest.type == BookRequestType.previous) ||
          (request.type == BookRequestType.previous &&
              lastRequest.type == BookRequestType.next)) {
        _requests.removeLast();
        return;
      }
    }

    _requests.add(request);
    notifyListeners();
  }

  BookRequest? takeRequest() {
    if (_requests.isEmpty) return null;
    return _requests.removeAt(0);
  }

  void clearRequests() {
    _requests.clear();
  }

  @override
  void dispose() {
    clearRequests();
    super.dispose();
  }
}

class BookRequest {
  final int? targetPage;
  final BookRequestType type;

  BookRequest(this.type, [this.targetPage]);

  BookRequest.next() : type = BookRequestType.next, targetPage = null;
  BookRequest.previous() : type = BookRequestType.previous, targetPage = null;
  BookRequest.jump(int page) : type = BookRequestType.jump, targetPage = page;

  @override
  String toString() =>
      'BookRequest(${type.name}${targetPage != null ? ', target: $targetPage' : ''})';
}

enum BookRequestType { next, previous, jump }
