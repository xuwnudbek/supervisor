import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/department/pages/add_department.dart';
import 'package:supervisor/ui/department/provider/department_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_department_card.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DepartmentProvider>(
      create: (context) => DepartmentProvider(),
      builder: (context, snapshot) {
        return Consumer<DepartmentProvider>(
          builder: (context, provider, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Title
                  Row(
                    children: [
                      const Text(
                        "Departamentlar",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        color: primary,
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          provider.initialize();
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        color: primary,
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          var res = await Get.to(() => AddDepartment());

                          if (res ?? false) {
                            provider.initialize();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: provider.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : provider.departments.isEmpty
                                ? Center(
                                    child: Text(
                                      "Hech qanday departament topilmadi",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: dark.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      child: StaggeredGrid.count(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        children: [
                                          ...List.generate(
                                            provider.departments.length,
                                            (index) => CustomDepartmentCard(
                                              index: index,
                                              department: provider.departments[index],
                                              onTap: () async {
                                                await Get.to(() => AddDepartment(department: provider.departments[index]))?.then((value) {
                                                  if (value) {
                                                    provider.initialize();
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
