import 'package:flutter/material.dart';

class CameraTableScreen extends StatefulWidget {
  const CameraTableScreen({super.key});

  @override
  _CameraTableScreenState createState() => _CameraTableScreenState();
}

class _CameraTableScreenState extends State<CameraTableScreen>
    with TickerProviderStateMixin {
  int? focusedCardIndex;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _perspectiveAnimation;
  late Animation<Offset> _offsetAnimation;

  final List<String> cards = List.generate(12, (i) => 'Carta ${i + 1}');

  final double cardWidth = 120.0;
  final double cardHeight = 168.0;
  final double spacing = 16.0;
  final double targetZoom = 3.5;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      reverseDuration: Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: targetZoom).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _perspectiveAnimation = Tween<double>(begin: -0.4, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Calcula posições tipo "wrap"
  List<Offset> _generateCardPositions(Size screenSize) {
    final positions = <Offset>[];
    final cardsPerRow = (screenSize.width ~/ (cardWidth + spacing)).clamp(
      1,
      cards.length,
    );
    for (int i = 0; i < cards.length; i++) {
      final int row = i ~/ cardsPerRow;
      final int col = i % cardsPerRow;
      final double x = col * (cardWidth + spacing);
      final double y = row * (cardHeight + spacing);
      positions.add(Offset(x, y));
    }

    // Para centralizar o conjunto de cartas na tela
    final int totalRows = (cards.length / cardsPerRow).ceil();
    final double gridWidth = (cardsPerRow * (cardWidth + spacing)) - spacing;
    final double gridHeight = (totalRows * (cardHeight + spacing)) - spacing;
    final Offset centerOffset = Offset(
      (screenSize.width - gridWidth) / 2,
      (screenSize.height - gridHeight) / 2,
    );

    return positions.map((pos) => pos + centerOffset).toList();
  }

  void _focusOnCard(int cardIndex, Size screenSize) {
    final screenCenter = Offset(screenSize.width / 2, screenSize.height / 2);
    final positions = _generateCardPositions(screenSize);

    if (focusedCardIndex == cardIndex) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            focusedCardIndex = null;
          });
        }
      });
    } else {
      setState(() {
        focusedCardIndex = cardIndex;

        final cardCenter = Offset(
          positions[cardIndex].dx + cardWidth / 2,
          positions[cardIndex].dy + cardHeight / 2,
        );

        final targetOffset = Offset(
          screenCenter.dx / targetZoom - cardCenter.dx,
          screenCenter.dy / targetZoom - cardCenter.dy,
        );

        _offsetAnimation =
            Tween<Offset>(
              begin: _offsetAnimation.value,
              end: targetOffset,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOutCubic,
              ),
            );
      });

      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final positions = _generateCardPositions(screenSize);

    return Scaffold(
      backgroundColor: Colors.green[800],
      body: GestureDetector(
        onTap: () {
          if (focusedCardIndex != null) {
            _focusOnCard(focusedCardIndex!, screenSize);
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: _offsetAnimation.value,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.green[600]!, Colors.green[800]!],
                  ),
                ),
                child: Stack(
                  children: [
                    // Mesa
                    Center(
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(_perspectiveAnimation.value),
                        child: Container(
                          width: 400,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Cartas dinâmicas
                    ...cards.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final String cardLabel = entry.value;
                      final Offset position = positions[index];
                      final bool isFocused = focusedCardIndex == index;

                      return Positioned(
                        left: position.dx,
                        top: position.dy,
                        child: _buildCard(cardLabel, index, isFocused),
                      );
                    }),

                    if (focusedCardIndex != null)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 16,
                        child: AnimatedOpacity(
                          opacity: _animationController.value,
                          duration: Duration(milliseconds: 400),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () =>
                                  _focusOnCard(focusedCardIndex!, screenSize),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String cardLabel, int index, bool isFocused) =>
      GestureDetector(
        onTap: () => _focusOnCard(index, MediaQuery.of(context).size),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.004)
            ..rotateX(_perspectiveAnimation.value),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isFocused ? 0.5 : 0.3),
                  blurRadius: isFocused ? 20 : 8,
                  offset: Offset(0, isFocused ? 8 : 4),
                ),
              ],
              border: isFocused
                  ? Border.all(color: Colors.yellow[400]!, width: 3)
                  : null,
            ),
            child: Center(
              child: Text(
                cardLabel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      );
}
