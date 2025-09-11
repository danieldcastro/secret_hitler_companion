import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Root Page')),
    body: Center(
      child: Text(
        'Welcome to the Root Page',
        style: AppTextStyles.headlineLarge(),
      ),
    ),
  );
}
