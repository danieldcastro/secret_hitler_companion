import 'package:flutter/material.dart';
import 'package:flutter_fy/utils/extensions/string_extensions/string_extensions.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/helpers/game_setup.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_controller.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_page_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_widget.dart';

class QuantityBookWidget extends StatelessWidget {
  final BookController controller;

  const QuantityBookWidget({required this.controller, super.key});

  Widget _buildTextColumn(
    List<String> lines, {
    CrossAxisAlignment align = CrossAxisAlignment.center,
  }) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: align,
    children: [
      const SizedBox(height: 6),
      for (var i = 0; i < lines.length; i++) ...[
        _buildPageLineDivider(),
        _buildDescriptionPageText(lines[i]),
      ],
      _buildPageLineDivider(),
    ],
  );

  BookPageWidget _buildPlayerCountPage(BuildContext context, int playerCount) =>
      BookPageWidget(
        child: _buildTextColumn([
          '$playerCount',
          context.loc.voterLabel.toLowerCase().pluralize(playerCount),
        ]),
      );

  BookPageWidget _buildDetailsPage(BuildContext context, int playerCount) {
    final setup = GameSetup.gameSetups.firstWhere(
      (s) => s.length == playerCount,
    );
    final fascistCount = GameSetup.fascistCount(setup);
    final liberalCount = GameSetup.liberalCount(setup);

    return BookPageWidget(
      child: Row(
        children: [
          Container(
            height: 80,
            width: 2,
            decoration: BoxDecoration(
              color: AppColors.black.withAlpha(50),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: _buildTextColumn([
              '$liberalCount ${context.loc.liberalsLabel.toLowerCase()}',
              '${fascistCount - 1} ${context.loc.fascistLabel.toLowerCase()}'
                  .pluralize(fascistCount - 1),
              '1 ${context.loc.hitlerLabel}',
            ], align: CrossAxisAlignment.start),
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
    final setups = GameSetup.gameSetups;
    final pages = <List<BookPageWidget>>[
      [_buildBlankPage(), _buildPlayerCountPage(context, setups[0].length)],
    ];

    for (int i = 0; i < setups.length; i++) {
      final currentPlayerCount = setups[i].length;
      final hasNext = i + 1 < setups.length;

      pages.add([
        _buildDetailsPage(context, currentPlayerCount),
        hasNext
            ? _buildPlayerCountPage(context, setups[i + 1].length)
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
