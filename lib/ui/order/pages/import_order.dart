import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/services/storage_service.dart';
import 'package:supervisor/ui/order/provider/import_order_provider.dart';
import 'package:supervisor/utils/formatters/currency_formatter.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_image_widget.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';
import 'package:supervisor/utils/widgets/hover_widget.dart';

class ImportOrder extends StatelessWidget {
  const ImportOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider<ImportOrderProvider>(
      create: (context) => ImportOrderProvider(),
      builder: (context, snapshot) {
        return Consumer<ImportOrderProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () {
                    if (provider.isLoading) {
                      CustomSnackbars(context).warning('Yuklash vaqtida chiqib ketish mumkin emas!');
                      return;
                    }

                    bool haveAnyChanges = StorageService.read("haveAnyChanges") ?? false;
                    Navigator.pop(context, haveAnyChanges);
                  },
                ),
                title: const Text('Modellarni tezkor kiritish'),
              ),
              body: Padding(
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
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text(
                              'Modellar faylini tanlang',
                              style: textTheme.titleMedium?.copyWith(color: dark.withValues(alpha: 0.6)),
                            ),
                          ),
                          // Excel's name
                          if (provider.importOrderExcel != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '${provider.importOrderExcel?.xFiles.first.name}',
                                style: textTheme.titleSmall?.copyWith(color: dark.withValues(alpha: 0.6)),
                              ),
                            ),

                          if (provider.importOrderList.isEmpty && provider.importOrderExcel == null)
                            Tooltip(
                              message: "Modellar ko'rsatilgan Excel faylni tanlang!",
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: primary,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  fixedSize: Size.fromHeight(40),
                                  textStyle: textTheme.titleSmall?.copyWith(color: dark.withValues(alpha: 0.6)),
                                ),
                                onPressed: () async {
                                  await provider.importOrder(context);
                                },
                                child: Row(
                                  children: [
                                    Text('Excelni yuklash'),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.download_rounded,
                                      color: light,
                                    ),
                                  ],
                                ),
                              ),
                              //toggle button
                            )
                          else
                            Row(
                              spacing: 8,
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: dark.withValues(alpha: 0.1),
                                    foregroundColor: dark.withValues(alpha: 0.6),
                                    fixedSize: Size.fromHeight(40),
                                  ),
                                  onPressed: () {
                                    provider.importOrderList = [];
                                  },
                                  icon: Icon(Icons.clear),
                                ),
                                Tooltip(
                                  message: "Modellarni o'zgartirishni yoqish yoki o'chirish!",
                                  child: Switch(
                                    activeColor: primary,
                                    inactiveTrackColor: dark.withValues(alpha: 0.6),
                                    inactiveThumbColor: light,
                                    thumbIcon: WidgetStatePropertyAll(
                                      provider.isEditable
                                          ? Icon(
                                              Icons.edit_rounded,
                                              size: 12,
                                              color: light,
                                            )
                                          : Icon(
                                              Icons.lock_rounded,
                                              size: 12,
                                              color: dark,
                                            ),
                                    ),
                                    value: provider.isEditable,
                                    onChanged: (value) {
                                      provider.isEditable = value;
                                    },
                                  ),
                                ),
                                if (provider.importOrderList.isNotEmpty)
                                  Tooltip(
                                    message: "Modellarni bazaga yuklash!",
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: success,
                                        foregroundColor: light,
                                        iconColor: light,
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        fixedSize: Size.fromHeight(40),
                                      ),
                                      onPressed: () async {
                                        var allOrdersCreated = provider.importOrderList.every((element) => element['status'] ?? false);

                                        if (allOrdersCreated) {
                                          CustomSnackbars(context).warning('Barcha Modellar bazaga yuklandi!');
                                          provider.importOrderList = [];
                                          return;
                                        }

                                        await provider.createOrders(context);
                                      },
                                      child: Row(
                                        children: [
                                          Text('Yuklash'),
                                          SizedBox(width: 4),
                                          Icon(Icons.upload_rounded),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: provider.isLoading
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox.square(
                                    dimension: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(primary),
                                      value: provider.seconds / 20,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Yuklanmoqda...'),
                                ],
                              ),
                            )
                          : LayoutBuilder(builder: (context, constraints) {
                              return provider.isCreating
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox.square(
                                            dimension: 24,
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation(primary),
                                              value: provider.currentIndex / provider.importOrderList.length,
                                              semanticsLabel: 'Yuklanmoqda...',
                                              semanticsValue: '${provider.currentIndex} / ${provider.importOrderList.length}',
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text('Ma\'lumotlar yuklanmoqda ...'),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: provider.importOrderList.length,
                                      itemExtent: 300,
                                      itemBuilder: (context, index) {
                                        final Map modelData = provider.importOrderList[index];

                                        TextEditingController model = modelData['model'];
                                        TextEditingController submodel = modelData['submodel'];
                                        TextEditingController quantity = modelData['quantity'];
                                        TextEditingController modelPrice = modelData['model_price'];
                                        TextEditingController modelSumma = modelData['model_summa'];

                                        List<TextEditingController> sizes = modelData['sizes'];
                                        List images = modelData['images'];

                                        bool hasOrdersCreated = modelData.keys.contains('status');
                                        bool status = modelData['status'] ?? false;

                                        return HoverWidget(
                                          builder: (hasHover) => DragTarget<String>(
                                            onAcceptWithDetails: (details) {
                                              if (images.contains(details.data)) return;
                                              images.add(details.data);
                                            },
                                            onLeave: (data) {
                                              images.remove(data);
                                            },
                                            builder: (context, _, __) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    height: 400,
                                                    constraints: BoxConstraints(
                                                      maxWidth: constraints.maxWidth,
                                                      minWidth: 400,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: light,
                                                      border: hasOrdersCreated
                                                          ? Border.all(
                                                              color: status ? success : danger,
                                                            )
                                                          : Border.all(
                                                              color: hasHover && provider.isMoving ? primary : Colors.transparent,
                                                            ),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                                                    margin: EdgeInsets.only(bottom: 16),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        spacing: 16,
                                                        children: [
                                                          // Images
                                                          SizedBox(
                                                            width: 100,
                                                            child: images.isEmpty
                                                                ? Center(
                                                                    child: Text(
                                                                      'Rasm yoq',
                                                                      style: textTheme.titleMedium?.copyWith(
                                                                        color: dark.withValues(alpha: 0.6),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : ListView(
                                                                    shrinkWrap: true,
                                                                    itemExtent: 100,
                                                                    children: [
                                                                      ...images.map(
                                                                        (image) {
                                                                          return Draggable(
                                                                            data: image,
                                                                            onDragStarted: () {
                                                                              provider.isMoving = true;
                                                                            },
                                                                            onDragEnd: (details) {
                                                                              provider.isMoving = false;
                                                                            },
                                                                            feedback: Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                color: secondary,
                                                                              ),
                                                                              margin: EdgeInsets.only(bottom: 4),
                                                                              padding: const EdgeInsets.all(4.0),
                                                                              child: CustomImageWidget(
                                                                                image: image,
                                                                              ),
                                                                            ),
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                color: secondary,
                                                                              ),
                                                                              margin: EdgeInsets.only(bottom: 4),
                                                                              padding: const EdgeInsets.all(4.0),
                                                                              child: CustomImageWidget(
                                                                                image: image,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                SizedBox(
                                                                  height: 75,
                                                                  child: SingleChildScrollView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      spacing: 4,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: Text("Model"),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 150,
                                                                              height: 50,
                                                                              child: CustomInput(
                                                                                controller: model,
                                                                                enabled: provider.isEditable,
                                                                                hint: 'Model',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: Text("Submodel"),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 150,
                                                                              height: 50,
                                                                              child: CustomInput(
                                                                                controller: submodel,
                                                                                enabled: provider.isEditable,
                                                                                hint: 'Submodel',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: Text("Miqdor"),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 150,
                                                                              height: 50,
                                                                              child: CustomInput(
                                                                                controller: quantity,
                                                                                enabled: provider.isEditable,
                                                                                formatters: [
                                                                                  CurrencyInputFormatter(),
                                                                                ],
                                                                                hint: 'Miqdor',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: Text("Model narxi"),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 150,
                                                                              height: 50,
                                                                              child: CustomInput(
                                                                                controller: modelPrice,
                                                                                enabled: provider.isEditable,
                                                                                formatters: [
                                                                                  CurrencyInputFormatter(),
                                                                                ],
                                                                                hint: 'Model narxi',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: Text("Model summasi"),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 150,
                                                                              height: 50,
                                                                              child: CustomInput(
                                                                                controller: modelSumma,
                                                                                formatters: [
                                                                                  CurrencyInputFormatter(),
                                                                                ],
                                                                                enabled: provider.isEditable,
                                                                                hint: 'Model summasi',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 8),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                                                        child: Text("O'lchamlar"),
                                                                      ),
                                                                      Expanded(
                                                                        child: SingleChildScrollView(
                                                                          scrollDirection: Axis.horizontal,
                                                                          child: Wrap(
                                                                            runSpacing: 4,
                                                                            spacing: 4,
                                                                            children: [
                                                                              ...sizes.map(
                                                                                (size) => SizedBox(
                                                                                  width: 120,
                                                                                  height: 50,
                                                                                  child: CustomInput(
                                                                                    controller: size,
                                                                                    textAlign: TextAlign.center,
                                                                                    size: 40,
                                                                                    enabled: provider.isEditable,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Container(
                                                      width: 48,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(8),
                                                          bottomRight: Radius.circular(8),
                                                        ),
                                                        color: primary,
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "${index + 1}",
                                                        style: textTheme.titleMedium?.copyWith(color: light),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topRight,
                                                    child: InkWell(
                                                      onTap: () {
                                                        provider.removeOrderFromList(index);
                                                      },
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(8),
                                                        bottomLeft: Radius.circular(8),
                                                      ),
                                                      child: Container(
                                                        width: 48,
                                                        height: 48,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(8),
                                                            bottomLeft: Radius.circular(8),
                                                          ),
                                                          color: danger.withValues(alpha: 0.2),
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Icons.delete_rounded,
                                                          color: danger,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                            }),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
