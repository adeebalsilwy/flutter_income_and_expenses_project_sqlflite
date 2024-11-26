import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income_expenses/utils/constants.dart';
import 'package:income_expenses/utils/dimensions.dart';
import 'package:income_expenses/widgets/container_reusable.dart';
import 'package:income_expenses/widgets/icon_reusable.dart';
import 'package:income_expenses/widgets/text_reusable.dart';

import '../utils/share_preferences.dart';

class SettingLanguagePage extends StatelessWidget {
  const SettingLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions(context);

    Future<void> _setLanguage(String language) async {
      await SharePreferencesUtils.saveAppLanguage(language);
      Get.updateLocale(Locale(language)); // Update app locale
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: IconReusable(
            icon: Icons.arrow_back_ios_new_outlined,
            sizeIcon: dimensions.iconSize17,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                TextReusable(
                  text: "Choose Your Language".tr,
                  fontSize: dimensions.fontSize20,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
                //
                SizedBox(height: dimensions.height10),
                //
                GestureDetector(
                  onTap: () => _setLanguage('kh'),
                  child: ContainerReusable(
                    width: dimensions.width20 * 10,
                    radius: dimensions.radius10,
                    color: Colors.black26,
                    horizontalMargin: 0,
                    verticalMargin: 0,
                    child: Padding(
                      padding: EdgeInsets.all(dimensions.width10),
                      child: ItemLanguageReusable(
                        dimensions: dimensions,
                        imgPath: "${Constants.assetPath}/cambodia.png",
                        textLanguage: "Khmer",
                      ),
                    ),
                  ),
                ),
                SizedBox(height: dimensions.height10),
                //
                GestureDetector(
                  onTap: () => _setLanguage('en'),
                  child: ContainerReusable(
                    width: dimensions.width20 * 10,
                    radius: dimensions.radius10,
                    color: Colors.black26,
                    horizontalMargin: 0,
                    verticalMargin: 0,
                    child: Padding(
                      padding: EdgeInsets.all(dimensions.width10),
                      child: ItemLanguageReusable(
                        dimensions: dimensions,
                        imgPath: "${Constants.assetPath}/united_kingdom.png",
                        textLanguage: "English",
                      ),
                    ),
                  ),
                ),
                SizedBox(height: dimensions.height10),
                //
                GestureDetector(
                  onTap: () => _setLanguage('ar'),
                  child: ContainerReusable(
                    width: dimensions.width20 * 10,
                    radius: dimensions.radius10,
                    color: Colors.black26,
                    horizontalMargin: 0,
                    verticalMargin: 0,
                    child: Padding(
                      padding: EdgeInsets.all(dimensions.width10),
                      child: ItemLanguageReusable(
                        dimensions: dimensions,
                        imgPath: "${Constants.assetPath}/saudi_arabia.png",
                        textLanguage: "العربية",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemLanguageReusable extends StatelessWidget {
  final String imgPath;
  final String textLanguage;

  const ItemLanguageReusable({
    super.key,
    required this.dimensions,
    required this.imgPath,
    required this.textLanguage,
  });

  final Dimensions dimensions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imgPath,
          width: dimensions.width20 * 3,
          height: dimensions.height20 * 2,
        ),
        SizedBox(width: dimensions.width10),
        //
        TextReusable(
          text: textLanguage,
          fontSize: dimensions.fontSize20,
          color: Colors.white,
        ),
      ],
    );
  }
}
