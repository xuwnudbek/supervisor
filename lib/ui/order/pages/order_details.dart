import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/provider/order_detail_provider.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_divider.dart';
import 'package:supervisor/utils/widgets/custom_dotted_widget.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

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
  int get orderId => widget.orderId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderDetailProvider>(
      create: (context) => OrderDetailProvider(orderId),
      child: Consumer<OrderDetailProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Buyurtma haqida ma\'lumot'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
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
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: dark.withValues(alpha: 0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            text: 'Buyurtma',
                                            children: [
                                              const TextSpan(
                                                text: ' / ',
                                              ),
                                              TextSpan(
                                                text: '#${provider.orderData['id']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const CustomDivider(),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Buyurtma nomi',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                "${provider.orderData['name']}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Buyurtma miqdori',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                "${provider.orderData['quantity']} ta",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const CustomDivider(),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Buyurtma holati',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                // status: active, inactive, pending
                                                provider.orderData['status'] == 'active'
                                                    ? 'Faol'
                                                    : provider.orderData['status'] == 'inactive'
                                                        ? 'Faol emas'
                                                        : 'Kutilmoqda',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Buyurtma rasxodi',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                "${provider.orderData['rasxod']}\$",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const CustomDivider(),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Buyurtma boshlanish sanasi',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                provider.orderData['start_date'].toString().split(" ").firstOrNull ?? "Mavjud emas",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Buyurtma tugash sanasi',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                provider.orderData['end_date'].toString().split(" ").firstOrNull ?? "Mavjud emas",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const CustomDivider(),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Text(
                                                'Buyurtma modellari',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: provider.orderData['order_models'].length,
                                              itemBuilder: (context, index) {
                                                Map orderModel = provider.orderData['order_models'][index];
                                                final controller = provider.expansionTileControllers[index];

                                                return ExpansionTile(
                                                  controller: controller,
                                                  collapsedBackgroundColor: secondary,
                                                  backgroundColor: secondary,
                                                  title: Text(
                                                    "${orderModel['model']['name']}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  collapsedIconColor: Colors.black,
                                                  iconColor: Colors.black,
                                                  expandedAlignment: Alignment.centerLeft,
                                                  onExpansionChanged: (value) {
                                                    if (value) {
                                                      provider.selectedOrderModel = orderModel;
                                                      for (var element in provider.expansionTileControllers) {
                                                        if (element != controller) {
                                                          element.collapse();
                                                        }
                                                      }
                                                      controller.expand();
                                                    } else {
                                                      controller.collapse();
                                                    }
                                                  },
                                                  childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                                  children: [
                                                    if ((provider.selectedOrderModel['submodels'] ?? []).isEmpty)
                                                      const Center(
                                                        child: Text("Submodel topilmadi"),
                                                      ),
                                                    SingleChildScrollView(
                                                      child: StaggeredGrid.count(
                                                        crossAxisCount: 3,
                                                        crossAxisSpacing: 8,
                                                        mainAxisSpacing: 8,
                                                        children: [
                                                          ...(provider.selectedOrderModel['submodels'] ?? []).map<Widget>((orderSubmodel) {
                                                            int submodelIndex = provider.selectedOrderModel['submodels'].indexOf(orderSubmodel);
                                                            return CustomSubmodels(
                                                              orderModelIndex: index,
                                                              orderSubmodelIndex: submodelIndex,
                                                            );
                                                          }),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ).paddingOnly(bottom: 8);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: light,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: dark.withValues(alpha: 0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
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
                                          children: provider.orderModels.map((orderModelData) {
                                            Map orderModel = orderModelData['order_model'];
                                            List<TableRow> recipesTableRows = orderModelData['recipes_table_rows'];

                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Text("Model:  "),
                                                    Text(
                                                      "${orderModel['model']['name']}",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8.0),
                                                Table(
                                                  border: TableBorder.all(
                                                    color: secondary,
                                                  ),
                                                  columnWidths: const {
                                                    0: IntrinsicColumnWidth(),
                                                    1: FlexColumnWidth(1),
                                                    2: IntrinsicColumnWidth(),
                                                    3: IntrinsicColumnWidth(),
                                                    4: IntrinsicColumnWidth(),
                                                  },
                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                  children: [
                                                    const TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            child: Center(
                                                              child: Text(
                                                                '№',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            child: Center(
                                                              child: Text(
                                                                'Mahsulot',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            child: Center(
                                                              child: Text(
                                                                'Narxi',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            child: Center(
                                                              child: Text(
                                                                'Miqdori',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            child: Center(
                                                              child: Text(
                                                                'Summa',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    ...recipesTableRows,
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: "Umumiy summa: ",
                                              children: [
                                                TextSpan(
                                                  text: "${provider.totalPrice.toCurrency.split(".").firstOrNull ?? "0"}\$",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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

class CustomSubmodels extends StatefulWidget {
  const CustomSubmodels({
    super.key,
    required this.orderModelIndex,
    required this.orderSubmodelIndex,
  });

  final int orderModelIndex;
  final int orderSubmodelIndex;

  @override
  State<CustomSubmodels> createState() => _CustomSubmodelsState();
}

class _CustomSubmodelsState extends State<CustomSubmodels> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailProvider>(builder: (context, provider, _) {
      Map orderModel = provider.orderData['order_models'][widget.orderModelIndex];
      Map orderSubmodel = orderModel['submodels'][widget.orderSubmodelIndex];

      Color backgrounColor = orderSubmodel['model_color']['color']['hex'].toString().isEmpty
          ? Colors.white
          : Color(
              int.parse(orderSubmodel['model_color']['color']['hex'], radix: 16),
            ).withAlpha(255);

      Color foregroundColor = backgrounColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgrounColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: dark.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${orderSubmodel['submodel']['name']}",
              style: TextStyle(
                color: foregroundColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const CustomDivider(),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Miqodor",
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                  ),
                ),
                const CustomDottedWidget(),
                Text(
                  "${orderSubmodel['quantity']} ta",
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Rang",
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                  ),
                ),
                const CustomDottedWidget(),
                Text(
                  "${orderSubmodel['model_color']['color']['name']}",
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Razmerlar",
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                  ),
                ),
                const CustomDottedWidget(),
                Text(
                  orderSubmodel['size']['name'],
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  "Guruh",
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                  ),
                ),
                const CustomDottedWidget(),
                Text(
                  "${orderSubmodel['group']?['group']?['name'] ?? "Guruh topilmadi"}",
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            CustomDropdown(
              color: secondary,
              value: orderSubmodel['group']?['group']?['id'],
              items: provider.groups.map((group) {
                return DropdownMenuItem(
                  value: group['id'],
                  child: Text(
                    "${group['name']}",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                await provider.fasteningOrderToGroup(orderSubmodel['submodel']['id'], value).then((value) {
                  if (value) {
                    CustomSnackbars(context).success("Guruhga muvaffaqiyatli qo'shildi");
                  } else {
                    CustomSnackbars(context).error("Guruhga qo'shishda xatolik yuz berdi");
                  }
                });
              },
            ),
          ],
        ),
      );
    });
  }
}
