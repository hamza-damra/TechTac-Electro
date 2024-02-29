import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key, this.fontSize = 30});
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 10),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      child: TitlesTextWidget(label: "Shop Smart", fontSize: fontSize),
    );
  }
}
