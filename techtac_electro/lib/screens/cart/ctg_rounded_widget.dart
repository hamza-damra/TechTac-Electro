import 'package:flutter/material.dart';
import 'package:techtac_electro/screens/search_screen.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget({
    super.key,
    required this.image,
    required this.name,
  });
  final String image, name;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          SearchScreen.routName,
          arguments: name,
        );
      },
      child: Column(
        children: [
          Image.asset(
            image,
            height: 50,
            width: 50,
          ),
          const SizedBox(height: 15),
          SubtitleTextWidget(
            label: name,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
