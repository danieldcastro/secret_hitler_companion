import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Root Page')),
    body: Container(child: Text('', style: AppTextStyles.bodyText1())),
  );
}
