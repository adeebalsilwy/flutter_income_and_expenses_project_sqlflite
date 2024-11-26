import 'package:flutter/material.dart';
import 'package:income_expenses/routes/route_hepler.dart';
import 'package:income_expenses/themes/theme_helper.dart';
import 'package:income_expenses/utils/constants.dart';
import 'package:get/get.dart';
import 'package:income_expenses/utils/dimensions.dart';
import 'package:income_expenses/widgets/text_reusable.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();

    // Start the scaling animation and navigate to the HomePage after 3 seconds
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _scale = 1.2; // Scale up the image a bit
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed(RouteHelper.getMainPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: _scale,
              duration: const Duration(seconds: 1),
              child: Image.asset(
                "${Constants.assetPath}/money.png",
                width: dimensions.width20 * 8,
                height: dimensions.width20 * 8,
              ),
            ),
            // a bit space
            SizedBox(height: dimensions.height20),
            //
            TextReusable(
              text: "splash_text".tr,
              fontSize: dimensions.fontSize21,
              fontWeight: FontWeight.bold,
              color: Get.find<ThemeHelper>().isDarkMode
                  ? Colors.amber
                  : Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
