import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/razryad/pages/add_razryad.dart';
import 'package:supervisor/ui/razryad/provider/razryad_provider.dart';
import 'package:supervisor/utils/RGB.dart';

class RazryadPage extends StatefulWidget {
  const RazryadPage({super.key});

  @override
  State<RazryadPage> createState() => _RazryadPageState();
}

class _RazryadPageState extends State<RazryadPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RazryadProvider>(
      create: (context) => RazryadProvider(),
      child: Consumer<RazryadProvider>(
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
                      "Razryadlar",
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
                        var res = await Get.to(() => AddRazryad(provider: provider));

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
                        : provider.razryads.isEmpty
                            ? Center(
                                child: Text(
                                  "Hozircha hech qanday rang yo'q",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Wrap(
                                  spacing: 16,
                                  runSpacing: 8,
                                  children: provider.razryads.map((razryad) {
                                    return Container(
                                      padding: const EdgeInsets.only(left: 20, top: 8, right: 8, bottom: 8),
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
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "${razryad['name']}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " - ${double.parse(razryad['salary']).toStringAsFixed(1)} so'm",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
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
                                                      Icon(Icons.delete, color: danger),
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
                                                Get.to(() => AddRazryad(provider: provider, razryad: razryad));
                                              } else if (value == "delete") {
                                                provider.deleteRazryad(razryad['id']);
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
