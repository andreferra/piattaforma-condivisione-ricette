// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';

class GamingScreen extends ConsumerWidget {
  const GamingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: const [
          Header(),
          Text('Gaming Screen'),
        ],
      ),
    );
  }
}
