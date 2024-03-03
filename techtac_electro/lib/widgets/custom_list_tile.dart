import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.imagesPath,
      required this.text,
      required this.function});
  final String imagesPath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Image.asset(
        imagesPath,
        height: 30,
      ),
      title: SubtitleTextWidget(label: text),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
