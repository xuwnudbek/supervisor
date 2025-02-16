import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/ui/razryad/provider/razryad_provider.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddRazryad extends StatefulWidget {
  const AddRazryad({
    super.key,
    required this.provider,
    this.razryad,
  });

  final RazryadProvider provider;
  final Map? razryad;

  @override
  State<AddRazryad> createState() => _AddModelState();
}

class _AddModelState extends State<AddRazryad> {
  RazryadProvider get provider => widget.provider;

  Map razryad = {
    "name": TextEditingController(),
    "salary": TextEditingController(),
  };

  @override
  void initState() {
    () async {
      if (widget.razryad != null) {
        razryad = {
          "name": TextEditingController(text: widget.razryad!['name']),
          "salary": TextEditingController(text: widget.razryad!['salary'].toString()),
        };
      }
      setState(() {});
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDialog(
        width: 400,
        maxHeight: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Razryad qo'shish",
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
                  flex: 3,
                  child: CustomInput(
                    controller: razryad['name'],
                    hint: "Razryad nomi",
                    lines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: CustomInput(
                    controller: razryad['salary'],
                    hint: "Summa / sekund",
                    lines: 1,
                  ),
                ),
                if (widget.razryad == null) const SizedBox(width: 8),
              ],
            ).marginOnly(bottom: 8),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                if (razryad['name'].text.isEmpty || razryad['salary'].text.isEmpty) {
                  CustomSnackbars(context).error("Iltimos, barcha maydonlarni to'ldiring!");
                  return;
                }

                if (widget.razryad != null) {
                  await provider.updateRazryad(widget.razryad!['id'], {
                    "name": razryad['name'].text,
                    "salary": razryad['salary'].text,
                  });
                  Get.back(result: true);
                  return;
                }

                await provider.createRazryad({
                  "name": razryad['name'].text,
                  "salary": razryad['salary'].text,
                });

                Get.back(result: true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.razryad != null ? "Yangilash" : "Qo'shish",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
