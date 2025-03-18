import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/ui/warehouse/provider/warehouse_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddWarehouse extends StatefulWidget {
  const AddWarehouse({
    super.key,
    required this.provider,
    this.warehouse,
  });

  final WarehouseProvider provider;
  final Map? warehouse;

  @override
  State<AddWarehouse> createState() => _AddModelState();
}

class _AddModelState extends State<AddWarehouse> {
  WarehouseProvider get provider => widget.provider;
  Map get warehouse => widget.warehouse ?? {};

  final List _selectedUsers = [];
  List get selectedUsers => _selectedUsers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    setState(() {
      _isLoading = value;
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (warehouse.isNotEmpty) {
      nameController.text = warehouse['name'];
      addressController.text = warehouse['location'];
      _selectedUsers.addAll(warehouse['users']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDialog(
        width: 500,
        maxHeight: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ombor qo'shish",
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
                  flex: 4,
                  child: CustomInput(
                    hint: "Ombor nomi",
                    controller: nameController,
                    lines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: CustomInput(
                    hint: "Ombor manzili",
                    controller: addressController,
                    lines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...provider.warehouseUsers.map((user) {
                        bool isSelected = selectedUsers.contains(user);

                        return ChoiceChip(
                          label: Text(
                            user['employee']?['name'] ?? "Unknown",
                          ),
                          selected: selectedUsers.contains(user),
                          onSelected: (value) => onSelectUser(user),
                          color: WidgetStatePropertyAll(isSelected ? primary : Colors.grey.shade300),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                if (isLoading) return;

                if (nameController.text.isEmpty) {
                  CustomSnackbars(context).warning("Ombor nomini kiriting");
                  return;
                }

                isLoading = true;

                var res = await HttpService.post(warehouseUrl, {
                  "name": nameController.text.trim(),
                  "location": addressController.text.trim(),
                  "users": selectedUsers.map((e) => e['id']).toList(),
                });

                isLoading = false;

                if (res['status'] == Result.success) {
                  CustomSnackbars(context).success("Ombor muvaffaqiyatli qo'shildi!");
                  Get.back(result: true);
                } else {
                  CustomSnackbars(context).error("Ombor qo'shishda xatolik yuz berdi!");
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox.square(
                      dimension: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Text(
                      widget.warehouse != null ? "Yangilash" : "Qo'shish",
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSelectUser(Map value) {
    setState(() {
      if (_selectedUsers.contains(value)) {
        _selectedUsers.remove(value);
      } else {
        _selectedUsers.add(value);
      }
    });
  }
}
