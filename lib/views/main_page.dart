import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income_expenses/themes/theme_helper.dart';
import 'package:income_expenses/utils/dimensions.dart';
import 'package:income_expenses/views/home_page.dart';
import 'package:income_expenses/views/report_page.dart';
import 'package:income_expenses/views/setting_page.dart';
import 'package:income_expenses/views/dashboard_page.dart';
import 'package:income_expenses/widgets/icon_reusable.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Store GlobalKeys for reloading state in each tab
  final GlobalKey<DashboardPageState> dashboardKey =
      GlobalKey<DashboardPageState>();
  final GlobalKey<HomePageState> homeKey = GlobalKey<HomePageState>();
  final GlobalKey<ReportPageState> reportKey = GlobalKey<ReportPageState>();
  final GlobalKey<SettingPageState> settingKey = GlobalKey<SettingPageState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(key: dashboardKey),
      HomePage(key: homeKey),
      ReportPage(key: reportKey),
      SettingPage(key: settingKey),
    ];
  }

  // Reload data in the current page
  void _reloadCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        dashboardKey.currentState?.reloadData();
        break;
      case 1:
        homeKey.currentState?.reloadData();
        break;
      case 2:
        reportKey.currentState?.reloadData();
        break;
      case 3:
        settingKey.currentState?.reloadData();
        break;
    }
  }

  // Get item color for the selected and unselected state
  Color _getItemColor(int index) {
    final isDarkMode = Get.find<ThemeHelper>().isDarkMode;
    final theme = Theme.of(context);
    return _selectedIndex == index
        ? (isDarkMode ? theme.colorScheme.primary : Colors.white)
        : (!isDarkMode ? theme.colorScheme.secondary : Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.background,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        height: dimensions.height20 * 3,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        items: [
          CurvedNavigationBarItem(
            child: IconReusable(
              icon: Icons.dashboard_rounded,
              sizeIcon: dimensions.fontSize15 * 2.2,
              color: _getItemColor(0),
            ),
            label: 'bottom_nav_0'.tr,
          ),
          CurvedNavigationBarItem(
            child: IconReusable(
              icon: Icons.home_rounded,
              sizeIcon: dimensions.fontSize15 * 2.2,
              color: _getItemColor(1),
            ),
            label: 'bottom_nav_1'.tr,
          ),
          CurvedNavigationBarItem(
            child: IconReusable(
              icon: Icons.bar_chart_rounded,
              sizeIcon: dimensions.fontSize15 * 2.2,
              color: _getItemColor(2),
            ),
            label: 'bottom_nav_2'.tr,
          ),
          CurvedNavigationBarItem(
            child: IconReusable(
              icon: Icons.settings_rounded,
              sizeIcon: dimensions.fontSize15 * 2.2,
              color: _getItemColor(3),
            ),
            label: 'bottom_nav_3'.tr,
          ),
        ],
        onTap: (index) {
          setState(() {
            if (_selectedIndex == index) {
              // If the same tab is selected, reload its data
              _reloadCurrentPage();
            }
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
