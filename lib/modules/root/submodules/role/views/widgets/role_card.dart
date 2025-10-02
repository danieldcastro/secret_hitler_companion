import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/objects/entities/fascist_voter_entity.dart';
import 'package:secret_hitler_companion/core/objects/entities/liberal_voter_entity.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/core/objects/enums/font_family_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/widgets/images/logo_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/utils/burned_edge_clipper.dart';

class RoleCard extends StatelessWidget {
  final Offset offset;
  final BoxConstraints constraints;
  final bool isBurned;
  final VoterEntity voter;
  const RoleCard({
    required this.offset,
    required this.constraints,
    required this.voter,
    this.isBurned = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnimatedSlide(
    duration: const Duration(milliseconds: 500),
    offset: offset,
    curve: Curves.elasticOut,
    child: ClipPath(
      clipper: isBurned ? BurnedEdgeClipper() : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: AssetImage(voter.cardImage),
            fit: BoxFit.fitWidth,
            alignment: Alignment(2, -0.3),
          ),
        ),
        width: constraints.maxWidth - 7,
        height: constraints.maxHeight * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            spacing: 2,
            children: [
              FittedBox(
                child: Text(
                  context.loc.roleCardMessage.toUpperCase(),
                  style: AppTextStyles.labelSmall().copyWith(fontSize: 5),
                ),
              ),
              if (voter is FascistVoterEntity &&
                  (voter as FascistVoterEntity).isHitler)
                SizedBox(
                  width: 50,
                  height: 40,
                  child: LogoWidget(
                    color: AppColors.propRed,
                    showSubtitle: false,
                    showSecretLabel: false,
                  ),
                )
              else
                FittedBox(
                  child: Transform.rotate(
                    angle: -0.15,
                    child: Stack(
                      children: [
                        Text(
                          _getRoleName(context, voter),
                          style:
                              AppTextStyles.bodyMedium(
                                fontFamily: FontFamilyEnum.display,
                                fontWeight: FontWeight.w900,
                                color: _getRoleColor(voter),
                              ).copyWith(
                                shadows: [
                                  Shadow(
                                    offset: Offset(
                                      1,
                                      1,
                                    ), // deslocamento da sombra
                                    blurRadius: 3, // desfoque
                                    color: AppColors.black, // cor da sombra
                                  ),
                                ],
                              ),
                        ),
                        Text(
                          _getRoleName(context, voter),
                          style:
                              AppTextStyles.bodyMedium(
                                fontFamily: FontFamilyEnum.display,
                                fontWeight: FontWeight.w900,
                              ).copyWith(
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = _getRoleStrokeColor(voter),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );

  Color _getRoleColor(VoterEntity voter) {
    if (voter is FascistVoterEntity) {
      return AppColors.darkPropRed;
    } else {
      return AppColors.darkCyan;
    }
  }

  Color _getRoleStrokeColor(VoterEntity voter) {
    if (voter is FascistVoterEntity) {
      return AppColors.propRed;
    } else {
      return AppColors.lightCyan;
    }
  }

  String _getRoleName(BuildContext context, VoterEntity voter) {
    String role = '';

    if (voter is FascistVoterEntity && voter.isHitler) {
      role = context.loc.hitlerLabel;
    } else if (voter is FascistVoterEntity) {
      role = context.loc.fascistLabel;
    } else if (voter is LiberalVoterEntity) {
      role = context.loc.liberalLabel;
    }

    return role.toUpperCase();
  }
}
