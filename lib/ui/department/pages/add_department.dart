import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/department/provider/add_department_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';

class AddDepartment extends StatelessWidget {
  const AddDepartment({
    super.key,
    this.department,
  });

  final Map? department;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddDepartmentProvider>(
      create: (context) => AddDepartmentProvider(department),
      builder: (context, snapshot) {
        return Consumer<AddDepartmentProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              body: CustomDialog(
                width: 450,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bo'lim${department != null ? 'ni o\'zgartirish' : ' qo\'shish'}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: provider.departmentData['name'],
                            hint: "Bo'lim nomi",
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: CustomDropdown(
                            hint: "Bo'lim mudiri",
                            value: provider.departmentData['master']?['id'],
                            items: provider.userMasters
                                .map(
                                  (master) => DropdownMenuItem(
                                    value: master['id'],
                                    child: Text(
                                      master['employee']?['name'] ?? "Unknown",
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              provider.onSelectMaster(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Guruhlar",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...(provider.departmentData['groups'] ?? [])
                                .map((group) {
                              int index =
                                  (provider.departmentData['groups'] ?? [])
                                      .indexOf(group);

                              return Row(
                                children: [
                                  Expanded(
                                    child: CustomInput(
                                      controller: group['name'],
                                      hint: "${index + 1}. Guruh nomi",
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: CustomDropdown(
                                      hint: "Guruh mudiri",
                                      value: group['submaster']?['id'],
                                      items: provider.userSubMasters
                                          .map((e) => DropdownMenuItem(
                                                value: e['id'],
                                                child: Text(
                                                  e['employee']['name'] ??
                                                      "Unknown",
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        provider.onSelectSubMaster(
                                            value, index);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor:
                                          danger.withValues(alpha: 0.1),
                                      foregroundColor: danger,
                                    ),
                                    onPressed: () {
                                      provider.removeGroup(index);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ).marginOnly(bottom: 4);
                            }),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    provider.addGroup(context);
                                  },
                                  icon: Row(
                                    children: [
                                      SizedBox(width: 4),
                                      const Icon(Icons.add),
                                      SizedBox(width: 4),
                                      Text(
                                        "Guruh qo'shish",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: primary,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        if ((department ?? {}).isNotEmpty) {
                          await provider
                              .createDepartment(context,
                                  isCreate: false,
                                  departmentId: department!['id'])
                              .then((value) {
                            if (value == true) {
                              Get.back(result: true);
                            }
                          });
                          return;
                        }

                        await provider.createDepartment(context).then((value) {
                          if (value == true) {
                            Get.back(result: true);
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (provider.isCreating)
                            const SizedBox.square(
                              dimension: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              ),
                            )
                          else
                            Text(
                              department != null ? "Yangilash" : "Qo'shish",
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
