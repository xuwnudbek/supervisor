import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/provider/home_provider.dart';
import 'package:supervisor/ui/splash/splash_page.dart';
import 'package:supervisor/utils/themes/app_colors.dart';

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({super.key});

  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...List.generate(
                    provider.menu.length,
                    (index) {
                      bool isActive = provider.selectedIndex == index;
                      Map item = provider.menu[index];

                      return TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: isActive ? primary : light,
                          foregroundColor: isActive ? Colors.white : dark,
                        ),
                        onPressed: () {
                          provider.selectedIndex = index;
                        },
                        child: Row(
                          children: [
                            Text(
                              item['title'] ?? '',
                              style: TextTheme.of(context).titleMedium?.copyWith(
                                    color: isActive ? Colors.white : dark.withValues(alpha: .8),
                                  ),
                            ),
                          ],
                        ),
                      ).paddingOnly(bottom: 4);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: danger.withValues(alpha: .1),
                foregroundColor: danger,
              ),
              onPressed: () async {
                await provider.logout();
                Get.offAll(() => const SplashPage());
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: danger,
                  ),
                  SizedBox(width: 8),
                  Text('Chiqish'),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
