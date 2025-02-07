import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/model/pages/add_model.dart';
import 'package:supervisor/ui/model/providers/model_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';

class ModelPage extends StatefulWidget {
  const ModelPage({super.key});

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ModelProvider>(
      create: (context) => ModelProvider(),
      child: Consumer<ModelProvider>(
        builder: (context, provider, _) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text(
                      "Modellar",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      color: primary,
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        provider.initialize();
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      color: primary,
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await Get.to(() => AddModel(provider: provider));
                        provider.initialize();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : provider.models.isEmpty
                            ? Center(
                                child: Text(
                                  "Hozircha hech qanday model yo'q",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.all(8),
                                child: Wrap(
                                  spacing: 16,
                                  runSpacing: 8,
                                  children: provider.models.map((model) {
                                    int index = provider.models.indexOf(model);

                                    return _buildModelCard(
                                      index: index,
                                      model: model,
                                      modelProvider: provider,
                                      onPressed: () {
                                        // Get.to(() => ModelDetails(modelData: model));
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModelCard({
    required int index,
    required Map model,
    required ModelProvider modelProvider,
    Function? onPressed,
  }) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 24),
            Text(
              "${model['name']}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: "edit",
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text("Tahrirlash"),
                      ],
                    ),
                  ),
                  // PopupMenuItem(
                  //   value: "delete",
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.delete, color: danger),
                  //       const SizedBox(width: 8),
                  //       Text(
                  //         "O'chirish",
                  //         style: TextStyle(
                  //           color: danger,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ];
              },
              tooltip: "Ko'proq",
              onSelected: (value) {
                if (value == "edit") {
                  Get.to(() => AddModel(provider: modelProvider, model: model));
                } else if (value == "delete") {
                  modelProvider.deleteModel(model['id']);
                }
              },
              icon: Icon(
                Icons.more_vert,
                color: primary,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
