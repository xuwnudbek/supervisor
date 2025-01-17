import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/color/pages/add_color.dart';
import 'package:supervisor/ui/color/provider/color_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/extensions/string_extension.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';

class ColorPage extends StatefulWidget {
  const ColorPage({super.key});

  @override
  State<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ColorProvider>(
      create: (context) => ColorProvider(),
      child: Consumer<ColorProvider>(
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
                      "Ranglar",
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
                        var res =
                            await Get.to(() => AddColor(provider: provider));

                        if (res ?? false) {
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
                        : provider.colors.isEmpty
                            ? Center(
                                child: Text(
                                  "Hozircha hech qanday rang yo'q",
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
                                  children: provider.colors.map((color) {
                                    return Container(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 8,
                                          right: 8,
                                          bottom: 8),
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
                                          if (color['hex'] != null)
                                            InkWell(
                                              onTap: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      CustomDialog(
                                                    backIconColor: Colors.white,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${color['name']}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            SelectableText(
                                                              "#${color['hex']}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        Container(
                                                          height: 100,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            color: color['hex']
                                                                .toString()
                                                                .toHEXColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: SizedBox.square(
                                                dimension: 32,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: color['hex']
                                                        .toString()
                                                        .toHEXColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "${color['name']}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
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
                                                PopupMenuItem(
                                                  value: "delete",
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete,
                                                          color: danger),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        "O'chirish",
                                                        style: TextStyle(
                                                          color: danger,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ];
                                            },
                                            tooltip: "Ko'proq",
                                            onSelected: (value) {
                                              if (value == "edit") {
                                                Get.to(() => AddColor(
                                                    provider: provider,
                                                    color: color));
                                              } else if (value == "delete") {
                                                provider
                                                    .deleteColor(color['id']);
                                              }
                                            },
                                            color: Colors.white,
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.white,
                                            ),
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: primary,
                                            ),
                                          ),
                                        ],
                                      ),
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
}
