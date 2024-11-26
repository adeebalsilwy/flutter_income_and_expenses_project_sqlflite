// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
// import 'package:income_expenses/routes/route_hepler.dart';
// import 'package:income_expenses/utils/app_color.dart';
// import 'package:income_expenses/utils/constants.dart';
// import 'package:income_expenses/utils/dimensions.dart';
// import 'package:income_expenses/widgets/icon_reusable.dart';
// import '../themes/theme_helper.dart';
// import '../widgets/text_reusable.dart';

// class SettingPage extends StatefulWidget {
//   const SettingPage({super.key});

//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage>
//     with SingleTickerProviderStateMixin {
//   final ThemeHelper _themeHelper = Get.find<ThemeHelper>();
//   late ValueNotifier<bool> _switchValue;

//   late AnimationController _controller;
//   late List<Animation<Offset>> _animations;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize switch state based on the current theme
//     _switchValue = ValueNotifier<bool>(_themeHelper.isDarkMode);

//     int numberOfContainers = 6;
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3000),
//     );

//     _animations = [];

//     for (int i = 0; i < numberOfContainers; i++) {
//       double start = (i * 0.15);
//       double end = start + 0.15;

//       Animation<Offset> animation = Tween<Offset>(
//         begin: const Offset(-1.0, 0.0),
//         end: Offset.zero,
//       ).animate(
//         CurvedAnimation(
//           parent: _controller,
//           curve: Interval(
//             start,
//             end,
//             curve: Curves.easeOut,
//           ),
//         ),
//       );

//       _animations.add(animation);
//     }

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dimensions = Dimensions(context);

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: TextReusable(
//           text: "title_setting_text".tr,
//           fontSize: dimensions.fontSize20 * 1.5,
//           color: _themeHelper.isDarkMode ? Colors.amber : Colors.black,
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(dimensions.width10),
//         child: Column(
//           children: [
//             // Profile setting container
//             SlideTransition(
//               position: _animations[0],
//               child: ContainerSettingReusable(
//                 dimensions: dimensions,
//                 text1: "text_container_1".tr,
//                 text2: "sub_text_container_1".tr,
//                 myChild: CircleAvatar(
//                   radius: dimensions.radius15 * 2,
//                   backgroundImage:
//                       const AssetImage("${Constants.assetPath}/profile.png"),
//                 ),
//                 bgColor: Colors.black38,
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getSettingProfilePage());
//                 },
//               ),
//             ),
//             SizedBox(height: dimensions.height10),
//             // Category setting container
//             SlideTransition(
//               position: _animations[1],
//               child: ContainerSettingReusable(
//                 dimensions: dimensions,
//                 text1: "text_container_2".tr,
//                 text2: "sub_text_container_2".tr,
//                 myChild: IconReusable(
//                   icon: Icons.language_outlined,
//                   sizeIcon: dimensions.iconSize17,
//                   color: Colors.amber,
//                 ),
//                 bgColor: Colors.transparent,
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getSettingCategoryPage());
//                 },
//               ),
//             ),
//             SizedBox(height: dimensions.height10),
//             // Language setting container
//             SlideTransition(
//               position: _animations[2],
//               child: ContainerSettingReusable(
//                 dimensions: dimensions,
//                 text1: "text_container_3".tr,
//                 text2: "sub_text_container_3".tr,
//                 myChild: IconReusable(
//                   icon: Icons.category_outlined,
//                   sizeIcon: dimensions.iconSize17,
//                   color: Colors.amber,
//                 ),
//                 bgColor: Colors.transparent,
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getSettingLanguagesPage());
//                 },
//               ),
//             ),
//             SizedBox(height: dimensions.height10),
//             // Dark mode toggle using AdvancedSwitch
//             SlideTransition(
//               position: _animations[3],
//               child: ContainerSettingReusable(
//                 dimensions: dimensions,
//                 text1: "text_container_4".tr,
//                 text2: "sub_text_container_4".tr,
//                 myChild: IconReusable(
//                   icon: Icons.dark_mode,
//                   sizeIcon: dimensions.iconSize17,
//                   color: Colors.amber,
//                 ),
//                 isSwitch: true,
//                 switchController: _switchValue,
//                 onTap: () {},
//                 onSwitchToggle: (value) {
//                   setState(() {
//                     _themeHelper.toggleChangeThemeMode(); // Toggle theme
//                     _switchValue.value = value; // Update switch value
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: dimensions.height10),
//             // Download setting container
//             SlideTransition(
//               position: _animations[4],
//               child: ContainerSettingReusable(
//                 dimensions: dimensions,
//                 text1: "text_container_5".tr,
//                 text2: "sub_text_container_5".tr,
//                 myChild: IconReusable(
//                   icon: Icons.download,
//                   sizeIcon: dimensions.iconSize17,
//                   color: Colors.amber,
//                 ),
//                 bgColor: Colors.transparent,
//                 onTap: () {
//                   Get.toNamed(RouteHelper.getSettingRetrieveDataToExcel());
//                 },
//               ),
//             ),
//             SizedBox(height: dimensions.height10),
//             // Delete data setting container
//             SlideTransition(
//               position: _animations[5],
//               child: ContainerSettingReusable(
//                 dimensions: dimensions,
//                 text1: "text_container_6".tr,
//                 text2: "sub_text_container_6".tr,
//                 myChild: IconReusable(
//                   icon: Icons.delete,
//                   sizeIcon: dimensions.iconSize17,
//                   color: Colors.amber,
//                 ),
//                 bgColor: Colors.transparent,
//                 onTap: () {},
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ContainerSettingReusable extends StatefulWidget {
//   final Dimensions dimensions;
//   final String text1;
//   final String text2;
//   final Color? bgColor;
//   final Widget? myChild;
//   final bool isSwitch;
//   final ValueNotifier<bool>? switchController;
//   final ValueChanged<bool>? onSwitchToggle; // Added callback for switch toggle
//   final VoidCallback onTap;

//   const ContainerSettingReusable({
//     super.key,
//     required this.dimensions,
//     required this.text1,
//     required this.text2,
//     this.bgColor,
//     this.myChild,
//     this.isSwitch = false,
//     this.switchController,
//     this.onSwitchToggle,
//     required this.onTap,
//   });

//   @override
//   _ContainerSettingReusableState createState() =>
//       _ContainerSettingReusableState();
// }

// class _ContainerSettingReusableState extends State<ContainerSettingReusable> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         decoration: BoxDecoration(
//           color: AppColor.colorLikeDark,
//           borderRadius: BorderRadius.circular(widget.dimensions.radius10),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: widget.dimensions.width10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   if (widget.myChild != null)
//                     Container(
//                       width: widget.dimensions.width20 * 3,
//                       height: widget.dimensions.height20 * 3,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: widget.bgColor ?? Colors.transparent,
//                       ),
//                       child: widget.myChild,
//                     ),
//                   SizedBox(width: widget.dimensions.width10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextReusable(
//                         text: widget.text1,
//                         fontSize: widget.dimensions.fontSize15,
//                       ),
//                       TextReusable(
//                         text: widget.text2,
//                         fontSize: widget.dimensions.fontSize15,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               widget.isSwitch && widget.switchController != null
//                   ? ValueListenableBuilder<bool>(
//                       valueListenable: widget.switchController!,
//                       builder: (context, value, child) {
//                         return Switch(
//                           value: value,
//                           onChanged: widget.onSwitchToggle,
//                         );
//                       },
//                     )
//                   : IconReusable(
//                       icon: Icons.arrow_forward_ios_outlined,
//                       sizeIcon: widget.dimensions.iconSize17,
//                       color: Colors.white,
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
