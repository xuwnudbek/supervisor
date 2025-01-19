import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/provider/order_detail_provider.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_divider.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({
    super.key,
    required this.orderId,
  });

  final int orderId;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderDetailProvider>(
      create: (context) => OrderDetailProvider(widget.orderId)..initialize(),
      child: Consumer<OrderDetailProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Buyurtma haqida ma\'lumot'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    provider.initialize();
                  },
                ),
                SizedBox(width: 16),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.orderData.isEmpty
                      ? const Center(
                          child: Text('Buyurtma haqida ma\'lumot topilmadi'),
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: light,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 16,
                                    children: [
                                      Row(
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Buyurtma',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                const TextSpan(
                                                  text: ' / ',
                                                ),
                                                TextSpan(
                                                  text: '#${provider.orderData['id']}',
                                                  style: TextTheme.of(context).titleMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const CustomDivider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Buyurtma nomi',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Text(
                                                  "${provider.orderData['name']}",
                                                  style: TextTheme.of(context).titleMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Holati',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Text(
                                                  provider.orderData['status'] == 'active'
                                                      ? 'Faol'
                                                      : provider.orderData['status'] == 'inactive'
                                                          ? 'Faol emas'
                                                          : 'Kutilmoqda',
                                                  style: TextTheme.of(context).titleMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        color: provider.orderData['status'] == 'active'
                                                            ? success
                                                            : provider.orderData['status'] == 'inactive'
                                                                ? danger
                                                                : primary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const CustomDivider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Modeli',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Text(
                                                  provider.orderModel['model']?['name'] ?? "Mavjud emas",
                                                  style: TextTheme.of(context).titleMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Matosi',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: provider.orderModel['material']?['name'] ?? "Mavjud emas",
                                                        style: TextTheme.of(context).titleMedium?.copyWith(
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                      ),
                                                      TextSpan(
                                                        text: ' — ',
                                                        style: TextTheme.of(context).bodyMedium,
                                                      ),
                                                      TextSpan(
                                                        text: '(${provider.orderModel['material']?['code'] ?? "N/A"})',
                                                        style: TextTheme.of(context).bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const CustomDivider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Miqdori',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Text(
                                                  "${provider.orderData['quantity']} ta",
                                                  style: TextTheme.of(context).titleMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Rasxodi',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Text(
                                                  "${provider.orderData['rasxod']}\$",
                                                  style: TextTheme.of(context).titleMedium?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const CustomDivider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              spacing: 6,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Umumiy summa',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Text.rich(
                                                  TextSpan(children: [
                                                    TextSpan(
                                                      text: "${provider.orderData['quantity']}",
                                                      style: TextTheme.of(context).titleMedium,
                                                    ),
                                                    TextSpan(
                                                      text: " x ",
                                                      style: TextTheme.of(context).titleMedium,
                                                    ),
                                                    TextSpan(
                                                      text: "${provider.getRecipesTotalPrice.toStringAsFixed(2)}\$",
                                                      style: TextTheme.of(context).titleMedium,
                                                    ),
                                                    TextSpan(
                                                      text: " = ",
                                                      style: TextTheme.of(context).titleMedium,
                                                    ),
                                                    TextSpan(
                                                      text: "${((provider.orderData['quantity'] as int) * provider.getRecipesTotalPrice).toCurrency}\$",
                                                      style: TextTheme.of(context).titleMedium?.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Boshlanish sanasi',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      provider.orderData['start_date'].toString().split(" ").firstOrNull ?? "Mavjud emas",
                                                      style: TextTheme.of(context).titleMedium?.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                    ),
                                                    Text(
                                                      ' — ',
                                                      style: TextTheme.of(context).bodyMedium,
                                                    ),
                                                    Text(
                                                      provider.orderData['end_date'].toString().split(" ").firstOrNull ?? "Mavjud emas",
                                                      style: TextTheme.of(context).titleMedium?.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const CustomDivider(),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              spacing: 6,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Submodellar',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: secondary,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  margin: EdgeInsets.only(right: 8),
                                                  padding: EdgeInsets.all(8),
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: [
                                                      ...provider.orderModel['submodels'].map((submodel) {
                                                        return Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: light,
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            submodel['submodel']['name'],
                                                            style: TextTheme.of(context).titleMedium?.copyWith(
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              spacing: 6,
                                              children: [
                                                Text(
                                                  'O\'lchamlar',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: secondary,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  margin: EdgeInsets.only(right: 8),
                                                  padding: EdgeInsets.all(8),
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: [
                                                      ...provider.orderModel['sizes'].map((sizeData) {
                                                        return Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: light,
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text.rich(
                                                            TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: sizeData['size']['name'],
                                                                  style: TextTheme.of(context).titleMedium?.copyWith(
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                ),
                                                                const TextSpan(
                                                                  text: ' — ',
                                                                ),
                                                                TextSpan(
                                                                  text: "${sizeData['quantity']} ta",
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const CustomDivider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Buyurtma instruksiyalari',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                SizedBox(height: 8),
                                                Table(
                                                  border: TableBorder.all(
                                                    color: dark.withValues(alpha: 0.2),
                                                  ),
                                                  columnWidths: {
                                                    0: FixedColumnWidth(50),
                                                    1: IntrinsicColumnWidth(flex: 1),
                                                    2: IntrinsicColumnWidth(flex: 2),
                                                  },
                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                  children: [
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Center(
                                                            child: Text(
                                                              "#",
                                                              style: TextTheme.of(context).titleSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                                            child: Text(
                                                              "Instruksiya nomi",
                                                              style: TextTheme.of(context).titleSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                                            child: Text(
                                                              "Instruksiya matni",
                                                              style: TextTheme.of(context).titleSmall,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    ...(provider.orderData['instructions'] ?? []).map((instruction) {
                                                      int index = (provider.orderData['instructions'] ?? []).indexOf(instruction);

                                                      return TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Center(
                                                              child: Text(
                                                                "${index + 1}",
                                                                style: TextTheme.of(context).titleSmall,
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                                              child: Text(
                                                                instruction['title'] ?? "N/A",
                                                                style: TextTheme.of(context).titleSmall,
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                                              child: Text(
                                                                instruction['description'] ?? "N/A",
                                                                style: TextTheme.of(context).titleSmall,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const CustomDivider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Buyurtma izohi',
                                                  style: TextTheme.of(context).bodyMedium,
                                                ),
                                                SizedBox(height: 8),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: secondary,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    provider.orderData['comment'] ?? "N/A",
                                                    style: TextTheme.of(context).titleMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(width: 8),
                            Container(
                              width: 1,
                              color: dark.withValues(alpha: 0.2),
                            ),
                            // Right Side
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: light,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                                child: Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Buyurtma mahsulotlari',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            ...(provider.orderModel['submodels'] ?? []).map((submodel) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        left: BorderSide(
                                                          color: dark.withValues(alpha: 0.2),
                                                        ),
                                                        top: BorderSide(
                                                          color: dark.withValues(alpha: 0.2),
                                                        ),
                                                        right: BorderSide(
                                                          color: dark.withValues(alpha: 0.2),
                                                        ),
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(8),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "${submodel['submodel']['name']}",
                                                          style: TextTheme.of(context).titleMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Table(
                                                    border: TableBorder.all(
                                                      color: dark.withValues(alpha: 0.2),
                                                    ),
                                                    columnWidths: {
                                                      0: FixedColumnWidth(50),
                                                      1: IntrinsicColumnWidth(flex: 2),
                                                      2: FixedColumnWidth(120),
                                                      3: FixedColumnWidth(100),
                                                    },
                                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                    children: [
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Center(
                                                              child: Text(
                                                                "#",
                                                                style: TextTheme.of(context).titleSmall,
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                                              child: Text(
                                                                "Maxsulot",
                                                                style: TextTheme.of(context).titleSmall,
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Center(
                                                                child: Text(
                                                                  "Miqdor",
                                                                  style: TextTheme.of(context).titleSmall,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Center(
                                                                child: Text(
                                                                  "U/S",
                                                                  style: TextTheme.of(context).titleSmall,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      ...(submodel['recipes'] ?? []).map((recipe) {
                                                        int index = (submodel['recipes'] ?? []).indexOf(recipe);
                                                        Map item = recipe['item'];

                                                        return TableRow(
                                                          children: [
                                                            TableCell(
                                                              child: Center(
                                                                child: Text(
                                                                  "${index + 1}",
                                                                  style: TextTheme.of(context).titleSmall,
                                                                ),
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      item['name'],
                                                                      style: TextTheme.of(context).titleSmall,
                                                                    ),
                                                                    Text(" — "),
                                                                    Text(
                                                                      item['code'] ?? "N/A",
                                                                      style: TextTheme.of(context).titleSmall?.copyWith(
                                                                            color: dark.withValues(alpha: 0.6),
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                                                child: Center(
                                                                  child: Text.rich(
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text: "${recipe['quantity']}",
                                                                          style: TextTheme.of(context).titleSmall,
                                                                        ),
                                                                        TextSpan(text: " /"),
                                                                        TextSpan(
                                                                          text: " ${item['unit']?['name'] ?? "ta"}".toLowerCase(),
                                                                          style: TextTheme.of(context).titleSmall?.copyWith(
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    "${((num.tryParse(item['price'] ?? "") ?? 0) * (num.tryParse(recipe['quantity']) ?? 0)).toCurrency}\$",
                                                                    style: TextTheme.of(context).titleSmall,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                ],
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          );
        },
      ),
    );
  }
}
