import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/extensions/string_extension.dart';
import 'package:supervisor/utils/rgb.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({
    super.key,
    this.provider,
  });

  final OrderProvider? provider;

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  int counter = 0;

  List<Map> models = [];
  List<int> quantities = [];

  Map selectedModel = {};
  TextEditingController modelQuantityController = TextEditingController();

  void addModelWithQuant(Map model, int quantity) {
    setState(() {
      models.add(model);
      quantities.add(quantity);
    });
  }

  void removeModelWithQuant(int index) {
    setState(() {
      models.removeAt(index);
      quantities.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDialog(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Buyurtma qo'shish",
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
                    controller: nameController,
                    hint: "Nomi",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomInput(
                    controller: quantityController,
                    hint: "Miqdori",
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                SizedBox(width: 6),
                Text(
                  "Modellar",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              children: [
                if (models.isEmpty) ...[
                  Row(
                    children: [
                      const SizedBox(width: 6),
                      Text(
                        "Model tanlanmagan",
                        style: TextStyle(
                          color: dark,
                        ),
                      ),
                    ],
                  )
                ] else
                  ...List.generate(models.length, (index) {
                    final model = models[index];
                    final quantity = quantities[index];

                    return Container(
                      height: 40,
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: secondary.withOpacity(.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${model['name']} / ${model['color']}",
                            style: TextStyle(
                              color: dark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("($quantity)"),
                          const SizedBox(width: 8),
                          SizedBox.square(
                            dimension: 28,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: danger.withOpacity(.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(150),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              iconSize: 16,
                              color: danger,
                              onPressed: () {
                                removeModelWithQuant(index);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: secondary.withOpacity(.8)),
            Column(children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomDropdown(
                      items: widget.provider!.models.map((model) {
                        return DropdownMenuItem(
                          value: model['id'],
                          child: Text("${model['name']}"),
                        );
                      }).toList(),
                      disabledItems: models.map((model) => "${model['name']} / ${model['color']}").toList(),
                      hint: "Model tanlang",
                      value: selectedModel['id'],
                      onChanged: (value) {
                        setState(() {
                          selectedModel = widget.provider!.models.firstWhere((model) => model['id'] == value);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: CustomInput(
                      hint: "Miqdor",
                      controller: modelQuantityController,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        setState(() {
                          modelQuantityController.text = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (selectedModel.isEmpty || (modelQuantityController.text.isNotEmpty && modelQuantityController.text.toInt == 0)) {
                          CustomSnackbars(context).warning("Iltimos, model va miqdorni tekshiring!");
                          return;
                        }

                        addModelWithQuant(selectedModel, modelQuantityController.text.toInt);

                        selectedModel = {};
                        modelQuantityController.text = "";
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty || quantityController.text.isEmpty || models.isEmpty || quantities.isEmpty) {
                  CustomSnackbars(context).warning("Iltimos, barcha maydonlarni to'ldiring!");
                  return;
                }

                if (quantityController.text.toInt != quantities.reduce((value, element) => value + element)) {
                  CustomSnackbars(context).warning("Model miqdori va umumiy miqdor mos kelmadi!");
                  return;
                }

                final body = {
                  "name": nameController.text.trim(),
                  "quantity": quantityController.text.toInt,
                  "models": [
                    for (int i = 0; i < models.length; i++)
                      {
                        "id": models[i]['id'],
                        "quantity": quantities[i],
                      },
                  ],
                };

                await widget.provider!.createOrder(body).then((value) {
                  CustomSnackbars(context).success("Buyurtma muvaffaqiyatli qo'shildi!");
                  Get.back();
                });
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Qo'shish"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
