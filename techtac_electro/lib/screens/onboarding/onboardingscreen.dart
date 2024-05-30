import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:techtac_electro/screens/onboarding/onboardingInfo.dart';
import 'package:techtac_electro/screens/root_screen.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = OnboardingItems();
  final pageCotroller = PageController();
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: isLastPage
            ? getStarted()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      pageCotroller.jumpToPage(controller.items.length - 1);
                    },
                    child: const Text('Skip'),
                  ),

                  //indicator
                  SmoothPageIndicator(
                    controller: pageCotroller,
                    count: controller.items.length,
                    onDotClicked: (index) => pageCotroller.animateToPage(
                      index,
                      duration: const Duration(microseconds: 600),
                      curve: Curves.easeIn,
                    ),
                    effect: const WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: Color(0xFF7357a4),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      pageCotroller.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeIn);
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
            onPageChanged: (index) => setState(
                () => isLastPage = controller.items.length - 1 == index),
            itemCount: controller.items.length,
            controller: pageCotroller,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(controller.items[index].image),
                  const SizedBox(
                    height: 15,
                  ),
                  TitlesTextWidget(
                    label: controller.items[index].title,
                    fontSize: 30,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SubtitleTextWidget(
                    label: controller.items[index].description,
                    textAlign: TextAlign.center,
                    color: Colors.grey,
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF7357a4),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 55,
      child: TextButton(
        onPressed: () async {
          final pres = await SharedPreferences.getInstance();
          pres.setBool('onboarding', true);
          // After we press get started button this onboarding value become true

          if (!mounted) return;
          Navigator.pushReplacementNamed(context, RootScreen.routName);
        },
        child: const Text('Get started', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
