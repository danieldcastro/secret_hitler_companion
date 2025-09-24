import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/core/utils/widgets/app_scaffold.dart';
import 'package:secret_hitler_companion/core/utils/widgets/footer_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/table_edge_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/envelope_widget.dart';

class RolePage extends StatelessWidget {
  final RoleBloc bloc;
  const RolePage({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    final sizedBox = SizedBox(
      width: 50,
      height: 70,
      child: EnvelopeWidget(voterName: 'Marciano'),
    );
    return AppScaffold(
      onBack: () => Globals.nav.navigate(NestedRoutes.roster),
      showBackButton: true,
      body: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 20,
              spacing: 20,
              children: List.generate(10, (index) => sizedBox),
            ),
          ),
          TableEdgeWidget(),
          FooterWidget(onTap: () {}, backgroundColor: AppColors.darkPropRed),
        ],
      ),
    );
  }
}
