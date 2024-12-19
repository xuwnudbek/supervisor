import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/provider/home_provider.dart';
import 'package:supervisor/ui/splash/splash_page.dart';
import 'package:supervisor/utils/rgb.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(),
      builder: (context, snapshot) {
        return Consumer<HomeProvider>(builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Super Visior'),
              elevation: 20,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Siderbar
                  Container(
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
                                      backgroundColor: isActive ? primary : primary.withOpacity(.1),
                                      foregroundColor: isActive ? Colors.white : primary,
                                    ),
                                    onPressed: () {
                                      provider.selectedIndex = index;
                                    },
                                    child: Row(
                                      children: [
                                        Text(item['title']),
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
                            backgroundColor: danger.withOpacity(.1),
                            foregroundColor: danger,
                          ),
                          onPressed: () async {
                            await provider.logout();
                            Get.offAll(() => const SplashPage());
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 8),
                              Text('Chiqish'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: provider.selectedView,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
