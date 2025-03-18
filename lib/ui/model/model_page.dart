import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/model/pages/add_model.dart';
import 'package:supervisor/ui/model/providers/model_provider.dart';
import 'package:supervisor/ui/order/pages/import_order.dart';
import 'package:supervisor/utils/extensions/list_extension.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/app/model_card.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';

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
                  spacing: 8,
                  children: [
                    const Text(
                      "Modellar",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 250,
                      child: CustomInput(
                        size: 40,
                        controller: provider.searchController,
                        hint: "Qidirish...",
                      ),
                    ),
                    IconButton(
                      color: primary,
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        provider.initialize();
                      },
                    ),
                    IconButton(
                      color: primary,
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        var res = await Get.to(() => AddModel(provider: provider));
                        if (res == true) {
                          provider.initialize();
                        }
                      },
                    ),
                    IconButton(
                      color: primary,
                      icon: const Icon(Icons.flash_on_rounded),
                      onPressed: () async {
                        var res = await Get.to(() => ImportOrder());

                        if (res == true) {
                          provider.initialize();
                        }
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
                                child: SingleChildScrollView(
                                  child: StaggeredGrid.count(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    children: [
                                      ...provider.models.qaysiki(['name'], provider.searchController.text).map((model) {
                                        return ModelCard(
                                          model: model,
                                          onTap: () async {
                                            var res = await Get.to(() => AddModel(provider: provider, model: model));
                                            if (res == true) {
                                              provider.initialize();
                                            }
                                          },
                                        );
                                      }),
                                    ],
                                  ),
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
}
