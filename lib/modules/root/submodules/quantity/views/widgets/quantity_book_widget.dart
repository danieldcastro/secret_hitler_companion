import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/helpers/game_setup.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_controller.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_page_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_widget.dart';

class QuantityBookWidget extends StatelessWidget {
  final BookController controller;

  const QuantityBookWidget({required this.controller, super.key});

  BookPageWidget _buildPlayerCountPage(int playerCount) => BookPageWidget(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 6),
        _buildPageLineDivider(),
        _buildDescriptionPageText('$playerCount'),
        _buildPageLineDivider(),
        _buildDescriptionPageText('votantes'),
        _buildPageLineDivider(),
        const SizedBox(height: 15),
        _buildPageLineDivider(),
      ],
    ),
  );

  BookPageWidget _buildDetailsPage(int playerCount) {
    final fascistCount = GameSetup.fascistCount(
      GameSetup.gameSetups.firstWhere((setup) => setup.length == playerCount),
    );
    final liberalCount = GameSetup.liberalCount(
      GameSetup.gameSetups.firstWhere((setup) => setup.length == playerCount),
    );

    return BookPageWidget(
      child: Row(
        children: [
          Container(
            height: 80,
            width: 2,
            color: AppColors.black.withAlpha(100),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                _buildPageLineDivider(),
                _buildDescriptionPageText('$liberalCount liberais'),
                _buildPageLineDivider(),
                _buildDescriptionPageText('$fascistCount Fascistas'),
                _buildPageLineDivider(),
                _buildDescriptionPageText('1 Hitler'),
                _buildPageLineDivider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildDescriptionPageText(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Text(text, style: AppTextStyles.titleSmall().copyWith(height: 1)),
  );

  Widget _buildPageLineDivider() => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Divider(
      height: 0,
      indent: 10,
      endIndent: 10,
      color: AppColors.black.withAlpha(100),
    ),
  );

  BookPageWidget _buildBlankPage() =>
      const BookPageWidget(child: SizedBox.shrink());

  @override
  Widget build(BuildContext context) {
    final pages = <List<BookPageWidget>>[];
    final setups = GameSetup.gameSetups;

    pages.add([_buildBlankPage(), _buildPlayerCountPage(setups[0].length)]);

    for (int i = 0; i < setups.length; i++) {
      final currentPlayerCount = setups[i].length;
      final hasNext = i + 1 < setups.length;

      pages.add([
        _buildDetailsPage(currentPlayerCount),
        hasNext
            ? _buildPlayerCountPage(setups[i + 1].length)
            : _buildBlankPage(),
      ]);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 308,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.beige,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(100),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 300,
          height: 80,
          child: BookWidget(controller: controller, pages: pages),
        ),
      ],
    );
  }
}
