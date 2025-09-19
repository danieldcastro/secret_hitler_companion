import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/audio_paths.dart';
import 'package:secret_hitler_companion/core/utils/mixins/audio_mixin.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_controller.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_page_widget.dart';

class BookWidget extends StatefulWidget {
  final List<List<BookPageWidget>> pages;
  final BookController controller;
  final double pageWidth;

  const BookWidget({
    required this.pages,
    required this.controller,
    this.pageWidth = 100,
    super.key,
  });

  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget>
    with TickerProviderStateMixin, AudioMixin {
  late int _currentPage;
  late int _displayPage;

  int? _animatingPage;
  bool _animatingForward = true;
  late List<AnimationController> _controllers;

  bool _isJumping = false;
  int? _jumpTarget;
  final Set<int> _jumpingPages = {};

  int get _totalPages => widget.pages.length;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.controller.page;
    _displayPage = _currentPage;
    _controllers = List.generate(widget.pages.length, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..addStatusListener((status) => _handleAnimationStatus(i, status));

      if (i < _currentPage) {
        c.value = 1.0;
      }

      return c;
    });

    widget.controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _processRequests();
      }
    });
  }

  void _handleAnimationStatus(int index, AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_animatingPage == index && _animatingForward) {
        setState(() {
          _currentPage = (_currentPage + 1).clamp(0, widget.pages.length - 1);
          _displayPage = _currentPage;
          _animatingPage = null;
          widget.controller.setPage(_currentPage);
        });
        _continueJumpIfNeeded();
      }

      if (_jumpingPages.contains(index)) {
        _jumpingPages.remove(index);
        _checkJumpCompletion();
      }
    } else if (status == AnimationStatus.dismissed) {
      if (_animatingPage == index && !_animatingForward) {
        setState(() {
          _currentPage = _displayPage;
          _animatingPage = null;
          widget.controller.setPage(_currentPage);
        });
        _continueJumpIfNeeded();
      }

      if (_jumpingPages.contains(index)) {
        _jumpingPages.remove(index);
        _checkJumpCompletion();
      }
    }
  }

  void _continueJumpIfNeeded() {
    if (_isJumping && _jumpTarget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _processJump();
        }
      });
    }
  }

  void _processRequests() {
    if (!_isJumping) {
      final request = widget.controller.takeRequest();
      if (request != null && _animatingPage == null) {
        playAudio('pageFlip', AudioPaths.pageFlip);
        if (request.type == BookRequestType.next) {
          _nextPage();
        } else if (request.type == BookRequestType.previous) {
          _prevPage();
        } else if (request.type == BookRequestType.jump &&
            request.targetPage != null) {
          _jumpTo(request.targetPage!);
        }
      }
    }
  }

  void _checkJumpCompletion() {
    if (_jumpingPages.isEmpty && _isJumping) {
      setState(() {
        _isJumping = false;
        _jumpTarget = null;
        _displayPage = _currentPage;
      });
    }
  }

  void _nextPage() {
    if (_currentPage >= _totalPages - 1 || _isJumping) return;
    if (_animatingPage == null) {
      setState(() {
        _animatingPage = _currentPage;
        _animatingForward = true;
      });
      _controllers[_currentPage].forward(from: 0.0);
    } else if (_animatingPage == _currentPage) {
      _animatingForward = true;
      _controllers[_animatingPage!].forward();
    }
  }

  void _prevPage() {
    if (_currentPage <= 0 || _isJumping) return;
    final pageToAnimate = _currentPage - 1;
    if (_animatingPage == null) {
      setState(() {
        _animatingPage = pageToAnimate;
        _animatingForward = false;

        _displayPage = pageToAnimate;
        widget.controller.setPage(_displayPage);
      });

      _controllers[pageToAnimate].reverse(from: 1.0);
    } else if (_animatingPage == pageToAnimate) {
      _animatingForward = false;
      _controllers[_animatingPage!].reverse();
    }
  }

  void _jumpTo(int page) {
    if (page < 0 || page >= widget.pages.length || page == _currentPage) return;

    setState(() {
      _isJumping = true;
      _jumpTarget = page;
      _animatingPage = null;
      _jumpingPages.clear();
    });

    _processJump();
  }

  void _processJump() {
    if (!_isJumping || _jumpTarget == null) return;

    final target = _jumpTarget!;
    final goingForward = _displayPage < target;

    final pagesToAnimate = goingForward
        ? List.generate(target - _displayPage, (i) => _displayPage + i)
        : List.generate(_displayPage - target, (i) => _displayPage - 1 - i);

    setState(() {
      _jumpingPages.addAll(pagesToAnimate);
    });

    for (int i = 0; i < pagesToAnimate.length; i++) {
      final pageIndex = pagesToAnimate[i];
      final delay = i * 120;

      Future.delayed(Duration(milliseconds: delay), () async {
        if (!mounted || !_jumpingPages.contains(pageIndex)) return;

        if (goingForward) {
          setState(() {
            _animatingPage = pageIndex;
            _animatingForward = true;
          });
          await _controllers[pageIndex].forward(from: 0.0);
          if (!mounted) return;

          setState(() {
            _jumpingPages.remove(pageIndex);
            _animatingPage = null;

            _displayPage = pageIndex + 1;
          });
        } else {
          setState(() {
            _animatingPage = pageIndex;
            _animatingForward = false;
            _displayPage = pageIndex;
            _jumpingPages.remove(pageIndex);
          });
          await _controllers[pageIndex].reverse(from: 1.0);
          if (!mounted) return;
          setState(() {
            _animatingPage = null;
          });
        }

        if (pageIndex == pagesToAnimate.last) {
          setState(() {
            _currentPage = target;
            _displayPage = _currentPage;
            _isJumping = false;
            _jumpTarget = null;
            widget.controller.setPage(_currentPage);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    disposeAudios();
    widget.controller.removeListener(_onControllerUpdate);
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildAnimatedPage(int index) => AnimatedBuilder(
    animation: _controllers[index],
    builder: (_, child) {
      final value = _controllers[index].value;
      final angle = value * pi;
      final isFlipped = value > 0.5;

      final content = isFlipped
          ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(pi),
              child: widget.pages[index][1],
            )
          : widget.pages[index][0];

      final perspective = _isJumping ? 0.0008 : 0.001;

      return Positioned(
        right: 0,
        child: Transform(
          alignment: Alignment.centerLeft,
          transform: Matrix4.identity()
            ..setEntry(3, 2, perspective)
            ..rotateY(angle),
          child: content,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    _processRequests();

    final List<int> staticOrder = [];

    for (int i = 0; i < _displayPage; i++) {
      staticOrder.add(i);
    }

    for (int i = _totalPages - 1; i >= _displayPage; i--) {
      staticOrder.add(i);
    }

    if (_animatingPage != null) staticOrder.remove(_animatingPage);

    final List<int> animatingIndices = [];
    for (int i = 0; i < _totalPages; i++) {
      final v = _controllers[i].value;
      if (v > 0.0 && v < 1.0) animatingIndices.add(i);
    }
    if (_animatingPage != null && !animatingIndices.contains(_animatingPage)) {
      animatingIndices.add(_animatingPage!);
    }

    if (_isJumping && _jumpTarget != null) {
      final goingForward = _displayPage < _jumpTarget!;
      if (goingForward) {
        animatingIndices.sort((a, b) => a.compareTo(b));
      } else {
        animatingIndices.sort((a, b) => b.compareTo(a));
      }
    } else {
      animatingIndices.sort(
        (a, b) => _controllers[b].value.compareTo(_controllers[a].value),
      );
    }

    final children = <Widget>[
      for (final idx in staticOrder) _buildAnimatedPage(idx),
      for (final idx in animatingIndices) _buildAnimatedPage(idx),
    ];

    return SizedBox(
      width: widget.pageWidth * 2,
      child: Stack(children: children),
    );
  }
}
