import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                width: 600,
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
                          flex: 2,
                          child: CustomInput(
                            controller: provider.departmentData['name'],
                            hint: "Bo'lim nomi",
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          flex: 3,
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Tooltip(
                            message: "Ish boshlash vaqti",
                            child: TextButton(
                              style: TextButton.styleFrom(
                                fixedSize: const Size.fromHeight(50),
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () async {
                                await showTimePicker(
                                  context: context,
                                  initialEntryMode: TimePickerEntryMode.inputOnly,
                                  initialTime: provider.startTime ?? TimeOfDay(hour: 7, minute: 0),
                                  helpText: "Ish boshlash vaqti",
                                  confirmText: "Tanlash",
                                  cancelText: "Bekor qilish",
                                  hourLabelText: "Soat",
                                  minuteLabelText: "Daqiqa",
                                ).then((timeOfDay) {
                                  if (timeOfDay != null) {
                                    provider.onSelectStartTime(timeOfDay);
                                  }
                                });
                              },
                              child: provider.startTime != null
                                  ? Text(
                                      provider.startTime!.format(context),
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Text(
                                      "Boshlash vaqti",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          flex: 2,
                          child: Tooltip(
                            message: "Ish tugatish vaqti",
                            child: TextButton(
                              style: TextButton.styleFrom(
                                fixedSize: const Size.fromHeight(50),
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () async {
                                await showTimePicker(
                                  context: context,
                                  anchorPoint: Offset(1, 6),
                                  initialEntryMode: TimePickerEntryMode.inputOnly,
                                  initialTime: provider.endTime ?? TimeOfDay(hour: 7, minute: 0),
                                  cancelText: "Bekor qilish",
                                  confirmText: "Tanlash",
                                  barrierLabel: "Ish tugatish vaqti",
                                  minuteLabelText: "Daqiqa",
                                  hourLabelText: "Soat",
                                ).then((timeOfDay) {
                                  if (timeOfDay != null) {
                                    provider.onSelectEndTime(timeOfDay);
                                  }
                                });
                              },
                              child: provider.endTime != null
                                  ? Text(
                                      provider.endTime!.format(context),
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Text(
                                      "Tugatish vaqti",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          flex: 1,
                          child: CustomInput(
                            controller: provider.breakTime,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            hint: "Tanaffus vaqti",
                            lines: 1,
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
                            ...(provider.departmentData['groups'] ?? []).map((group) {
                              int index = (provider.departmentData['groups'] ?? []).indexOf(group);

                              return Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomInput(
                                      controller: group['name'],
                                      hint: "${index + 1}. Guruh nomi",
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    flex: 3,
                                    child: CustomDropdown(
                                      hint: "Guruh mudiri",
                                      value: group['submaster']?['id'],
                                      items: provider.userSubMasters
                                          .map((e) => DropdownMenuItem(
                                                value: e['id'],
                                                child: Text(
                                                  e['employee']['name'] ?? "Unknown",
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        provider.onSelectSubMaster(value, index);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: danger.withValues(alpha: 0.1),
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
                          await provider.createDepartment(context, isCreate: false, departmentId: department!['id']).then((value) {
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
