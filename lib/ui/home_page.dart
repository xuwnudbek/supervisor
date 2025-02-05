import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/provider/home_provider.dart';
import 'package:supervisor/ui/splash/splash_page.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/app/custom_sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Supervisior'),
              elevation: 20,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Siderbar
                  CustomSidebar(),

                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: provider.selectedView,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
