import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/provider/import_order_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';

class ImportOrder extends StatelessWidget {
  const ImportOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider<ImportOrderProvider>(
      create: (context) => ImportOrderProvider(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Modellarni tezkor kiritish'),
          ),
          body: Consumer<ImportOrderProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: light,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Modellar faylini tanlang',
                              style: textTheme.titleMedium,
                            ),
                          ),
                          if (provider.importOrderExcel != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                '${provider.importOrderExcel?.xFiles.first.name}',
                                style: textTheme.titleSmall?.copyWith(color: dark.withValues(alpha: 0.6)),
                              ),
                            ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              fixedSize: Size.fromHeight(40),
                            ),
                            onPressed: () async {
                              await provider.importOrder();
                            },
                            child: Text('Tanlash'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: light,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Model ${index + 1}',
                                    style: textTheme.titleMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
