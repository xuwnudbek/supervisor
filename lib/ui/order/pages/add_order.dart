import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/provider/add_order_provider.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/extensions/datetime_extension.dart';
import 'package:supervisor/utils/extensions/list_extension.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/formatters/currency_formatter.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddOrder extends StatelessWidget {
  const AddOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, _) {
      return ChangeNotifierProvider(
        create: (_) => AddOrderProvider(orderProvider),
        child: Consumer<AddOrderProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Buyurtma qo'shish"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: light,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          spacing: 8,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomInput(
                                    controller: provider.orderNameController,
                                    hint: "Buyurtma nomi",
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomDropdown(
                                    tooltip: "Buyurtmachini tanlang",
                                    hint: "Kontragent tanlang",
                                    items: provider.contragents.map((e) {
                                      return DropdownMenuItem(
                                        value: e['id'],
                                        child: Text(e['name']),
                                      );
                                    }).toList(),
                                    onChanged: (id) {
                                      print(id);
                                      provider.selectedContragent = provider
                                          .contragents
                                          .firstWhere((e) => e['id'] == id);
                                    },
                                    value: provider.selectedContragent['id'],
                                  ),
                                ),
                                Expanded(
                                  child: CustomInput(
                                    controller: provider.orderRasxodController,
                                    hint: "rasxod",
                                    textAlign: TextAlign.center,
                                    tooltip:
                                        "Harbir maxsulot uchun\nchiqim (\$ dollarda)",
                                    formatters: [
                                      CurrencyInputFormatter(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Tooltip(
                                    message:
                                        "Buyurtma olish/topshirish\nsanasini tanlang",
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        fixedSize: const Size.fromHeight(50),
                                        backgroundColor: Colors.grey[200],
                                        foregroundColor: Colors.black,
                                      ),
                                      onPressed: () async {
                                        await showDateRangePicker(
                                          context: context,
                                          firstDate: DateTime.now().subtract(
                                              const Duration(days: 14)),
                                          lastDate: DateTime.now().add(
                                              const Duration(days: 365 * 2)),
                                          anchorPoint: Offset(1, 6),
                                          initialDateRange: provider
                                                  .deadline.isNotEmpty
                                              ? DateTimeRange(
                                                  start: provider.deadline[0],
                                                  end: provider.deadline[1],
                                                )
                                              : null,
                                          saveText: "Saqlash",
                                          keyboardType: TextInputType.datetime,
                                          builder: (context, child) {
                                            return child!.paddingSymmetric(
                                              horizontal: 200,
                                              vertical: 50,
                                            );
                                          },
                                        ).then((date) {
                                          if (date != null) {
                                            provider.deadline = [
                                              date.start,
                                              date.end
                                            ];
                                          }
                                        });
                                      },
                                      child: Text(
                                        provider.deadline.isNotEmpty
                                            ? "${provider.deadline[0].format} - ${provider.deadline[1].format}"
                                            : "Buyurtma muddati",
                                        style: TextStyle(
                                          color: provider.deadline.isNotEmpty
                                              ? null
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                Column(
                                  spacing: 8,
                                  children: [
                                    CustomDropdown(
                                      tooltip:
                                          "Buyurtma qilingan modelni tanlang",
                                      width: 300,
                                      hint: "Modelni tanlang",
                                      items: provider.models.map((e) {
                                        return DropdownMenuItem(
                                          value: e['id'],
                                          child: Text(e['name']),
                                        );
                                      }).toList(),
                                      onChanged: (id) {
                                        provider.selectedModel = provider.models
                                            .firstWhere((e) => e['id'] == id);
                                      },
                                      value: provider.selectedModel['id'],
                                    ),
                                    Container(
                                      width: 300,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: provider.submodels.isEmpty
                                          ? Center(
                                              child: Text(
                                                "Bo'sh",
                                                style: TextTheme.of(context)
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            )
                                          : Wrap(
                                              runSpacing: 8,
                                              spacing: 8,
                                              children: [
                                                ...provider.submodels
                                                    .map((submodel) {
                                                  bool isSelected = provider
                                                      .selectedSubmodels
                                                      .contains(submodel);

                                                  return ChoiceChip(
                                                    label: Text(
                                                      "${submodel['name']}",
                                                      style: TextTheme.of(
                                                              context)
                                                          .titleMedium
                                                          ?.copyWith(
                                                            color: isSelected
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 8),
                                                    showCheckmark: false,
                                                    selectedColor: primary,
                                                    selected: isSelected,
                                                    onSelected: (selected) {
                                                      if (selected) {
                                                        provider.selectSubmodel(
                                                            submodel);
                                                      } else {
                                                        provider
                                                            .removeSelectedSubmodel(
                                                                submodel);
                                                      }
                                                    },
                                                  );
                                                }),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                                Column(
                                  spacing: 8,
                                  children: [
                                    CustomDropdown(
                                      tooltip:
                                          "Buyurtma qilingan mato turini tanlang",
                                      width: 300,
                                      hint: "Matoni tanlang",
                                      items: provider.materials.map((e) {
                                        return DropdownMenuItem(
                                          value: e['id'],
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "${e['code']} — ",
                                                  style: TextStyle(
                                                      color: dark.withValues(
                                                          alpha: 0.5)),
                                                ),
                                                TextSpan(text: "${e['name']}"),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (id) {
                                        provider.selectedMaterial = provider
                                            .materials
                                            .firstWhere((e) => e['id'] == id);
                                      },
                                      value: provider.selectedMaterial['id'],
                                    ),
                                    Container(
                                      width: 300,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: provider.sizes.isEmpty
                                          ? Center(
                                              child: Text(
                                                "Bo'sh",
                                                style: TextTheme.of(context)
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            )
                                          : Wrap(
                                              runSpacing: 8,
                                              spacing: 8,
                                              children: [
                                                ...provider.sizes.map((size) {
                                                  bool isSelected = provider
                                                      .selectedSizes
                                                      .where((e) =>
                                                          e['size'] == size)
                                                      .isNotEmpty;

                                                  return ChoiceChip(
                                                    label: Text(
                                                      "${size['name']}",
                                                      style: TextTheme.of(
                                                              context)
                                                          .titleMedium
                                                          ?.copyWith(
                                                            color: isSelected
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 8),
                                                    showCheckmark: false,
                                                    selectedColor: primary,
                                                    selected: isSelected,
                                                    onSelected: (selected) {
                                                      if (selected) {
                                                        provider
                                                            .selectSize(size);
                                                      } else {
                                                        provider
                                                            .removeSelectedSize(
                                                                size);
                                                      }
                                                    },
                                                  );
                                                }),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 208,
                                        decoration: BoxDecoration(
                                          color: secondary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: provider.selectedSizes.isEmpty
                                            ? Center(
                                                child: Text(
                                                  "Bo'sh",
                                                  style: TextTheme.of(context)
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                              )
                                            : SingleChildScrollView(
                                                child: Column(
                                                  spacing: 8,
                                                  children: [
                                                    ...provider.selectedSizes
                                                        .map((size) {
                                                      int index = provider
                                                          .selectedSizes
                                                          .indexOf(size);

                                                      return Container(
                                                        height: 45,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: light,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4,
                                                                vertical: 4),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          spacing: 8,
                                                          children: [
                                                            SizedBox(width: 8),
                                                            Text(
                                                              "${index + 1}.",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            SizedBox(
                                                              child: Text(
                                                                "${size['size']['name']}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            SizedBox(
                                                              width: 100,
                                                              child:
                                                                  CustomInput(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                controller: size[
                                                                    'quantity'],
                                                                hint: "soni",
                                                                formatters: [
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly,
                                                                  TextInputFormatter
                                                                      .withFunction(
                                                                          (oldValue,
                                                                              newValue) {
                                                                    if (newValue
                                                                        .text
                                                                        .startsWith(
                                                                            "0")) {
                                                                      return oldValue;
                                                                    }

                                                                    if (newValue
                                                                            .text
                                                                            .length >
                                                                        5) {
                                                                      return oldValue;
                                                                    }

                                                                    return newValue;
                                                                  }),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 8.0),
                                        child: Text.rich(
                                          TextSpan(children: [
                                            TextSpan(
                                              text: "Jami soni: ",
                                              style: TextTheme.of(context)
                                                  .titleSmall,
                                            ),
                                            TextSpan(
                                              text:
                                                  "${provider.getSizesQuantity}",
                                              style: TextTheme.of(context)
                                                  .titleMedium,
                                            ),
                                            TextSpan(
                                              text: " ta",
                                              style: TextTheme.of(context)
                                                  .titleSmall,
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 8),
                                      Text(
                                        "Instruksiya",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: light,
                                        border: Border.all(
                                          color: dark.withValues(alpha: 0.2),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                        spacing: 8,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    // color: light,
                                                  ),
                                                  child: Row(
                                                    spacing: 8,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: CustomInput(
                                                          color: light,
                                                          hint:
                                                              "Instruksiya nomi",
                                                          controller: provider
                                                              .instructionTitleController,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: CustomInput(
                                                          color: light,
                                                          hint:
                                                              "Instruksiya izohi",
                                                          controller: provider
                                                              .instructionBodyController,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        style: IconButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              primary,
                                                          foregroundColor:
                                                              light,
                                                        ),
                                                        onPressed: () {
                                                          provider
                                                              .addInstruction(
                                                                  context);
                                                        },
                                                        icon: Icon(
                                                          Icons.add_rounded,
                                                        ),
                                                      ),
                                                      SizedBox.shrink()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Table(
                                                  border: TableBorder.symmetric(
                                                    inside: BorderSide(
                                                      color: dark.withValues(
                                                          alpha: 0.1),
                                                    ),
                                                    outside: BorderSide(
                                                      color: dark.withValues(
                                                          alpha: 0.1),
                                                    ),
                                                    // borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  columnWidths: {
                                                    0: FixedColumnWidth(50),
                                                    1: IntrinsicColumnWidth(
                                                        flex: 1),
                                                    2: IntrinsicColumnWidth(
                                                        flex: 2),
                                                    3: FixedColumnWidth(56),
                                                  },
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  children: [
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Center(
                                                            child: Text(
                                                              "ID",
                                                              style: TextTheme.of(
                                                                      context)
                                                                  .titleSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "Instruction Title",
                                                              style: TextTheme.of(
                                                                      context)
                                                                  .titleSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "Instruction Body",
                                                              style: TextTheme.of(
                                                                      context)
                                                                  .titleSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                "#",
                                                                style: TextTheme.of(
                                                                        context)
                                                                    .titleSmall,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: Table(
                                                      border: TableBorder.all(
                                                        color: dark.withValues(
                                                            alpha: 0.1),
                                                        // borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      columnWidths: {
                                                        0: FixedColumnWidth(50),
                                                        1: IntrinsicColumnWidth(
                                                            flex: 1),
                                                        2: IntrinsicColumnWidth(
                                                            flex: 2),
                                                        3: FixedColumnWidth(56),
                                                      },
                                                      defaultVerticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      children: [
                                                        ...provider.instructions
                                                            .map<TableRow>(
                                                                (instruction) {
                                                          int index = provider
                                                              .instructions
                                                              .indexOf(
                                                                  instruction);

                                                          return TableRow(
                                                            children: [
                                                              Center(
                                                                child: Text(
                                                                    "${index + 1}"),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                child: Text(
                                                                    "${instruction['title']}"),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                child: Text(
                                                                    "${instruction['description']}"),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                child:
                                                                    IconButton(
                                                                  style: IconButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        danger.withValues(
                                                                            alpha:
                                                                                0.1),
                                                                    foregroundColor:
                                                                        danger,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    provider.removeInstruction(
                                                                        instruction);
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .delete),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
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
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                fillColor: light,
                                hintText: "Buyurtma izohi",
                                hintStyle: TextStyle(
                                  color: dark.withValues(alpha: 0.2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: dark.withValues(alpha: 0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              controller: provider.orderCommentController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      decoration: BoxDecoration(
                        color: dark.withValues(alpha: 0.2),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: light,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: provider.selectedSubmodels.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Bo'sh",
                                        style: TextTheme.of(context)
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors.grey,
                                            ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Table(
                                          border: TableBorder.all(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(4)),
                                            color: dark.withValues(alpha: 0.2),
                                          ),
                                          columnWidths: {
                                            0: FixedColumnWidth(50),
                                            1: IntrinsicColumnWidth(flex: 2),
                                            2: FixedColumnWidth(100),
                                            3: FixedColumnWidth(56),
                                          },
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: [
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Center(
                                                    child: Text(
                                                      "ID",
                                                      style:
                                                          TextTheme.of(context)
                                                              .titleSmall,
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Maxsulot",
                                                      style:
                                                          TextTheme.of(context)
                                                              .titleSmall,
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Miqdor",
                                                        style: TextTheme.of(
                                                                context)
                                                            .titleSmall,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "#",
                                                        style: TextTheme.of(
                                                                context)
                                                            .titleSmall,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: provider
                                                .selectedSubmodels.length,
                                            itemBuilder: (context, index) {
                                              Map submodel = provider
                                                  .selectedSubmodels[index];
                                              List recipes = provider.recipes
                                                  .qaysiki(
                                                      ['submodel'], submodel);

                                              return Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        left: BorderSide(
                                                          color:
                                                              dark.withValues(
                                                                  alpha: 0.2),
                                                        ),
                                                        top: BorderSide(
                                                          color:
                                                              dark.withValues(
                                                                  alpha: 0.2),
                                                        ),
                                                        right: BorderSide(
                                                          color:
                                                              dark.withValues(
                                                                  alpha: 0.2),
                                                        ),
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "${submodel['name']}",
                                                          style: TextTheme.of(
                                                                  context)
                                                              .titleMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Table(
                                                    border: TableBorder.all(
                                                      color: dark.withValues(
                                                          alpha: 0.2),
                                                    ),
                                                    columnWidths: {
                                                      0: FixedColumnWidth(50),
                                                      1: IntrinsicColumnWidth(
                                                          flex: 2),
                                                      2: FixedColumnWidth(100),
                                                      3: FixedColumnWidth(56),
                                                    },
                                                    defaultVerticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    children: [
                                                      // recipes
                                                      ...recipes.map((recipe) {
                                                        int index = recipes
                                                            .indexOf(recipe);
                                                        Map item =
                                                            recipe['item'];

                                                        return TableRow(
                                                          children: [
                                                            TableCell(
                                                              child: Center(
                                                                child: Text(
                                                                  "${index + 1}",
                                                                  style: TextTheme.of(
                                                                          context)
                                                                      .titleSmall,
                                                                ),
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child:
                                                                  CustomDropdown(
                                                                color: light,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                                hint:
                                                                    "Maxsulot",
                                                                items: provider
                                                                    .items
                                                                    .map((e) {
                                                                  return DropdownMenuItem(
                                                                    value:
                                                                        e['id'],
                                                                    child: Text
                                                                        .rich(
                                                                      TextSpan(
                                                                        text:
                                                                            "${e['name']}",
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                " — ${e['code']}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: dark.withValues(alpha: 0.5),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                value:
                                                                    item['id'],
                                                                disabledItems: [
                                                                  ...recipes.map(
                                                                      (e) => e[
                                                                              'item']
                                                                          [
                                                                          'id']),
                                                                ],
                                                                onChanged:
                                                                    (value) {
                                                                  provider
                                                                      .selectItemForRecipe(
                                                                    submodel:
                                                                        submodel,
                                                                    item: provider
                                                                        .items
                                                                        .firstWhere((e) =>
                                                                            e['id'] ==
                                                                            value),
                                                                    index:
                                                                        index,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child:
                                                                  TextFormField(
                                                                controller: recipe[
                                                                    'quantity'],
                                                                inputFormatters: [
                                                                  TextInputFormatter
                                                                      .withFunction(
                                                                          (oldValue,
                                                                              newValue) {
                                                                    if (newValue
                                                                        .text
                                                                        .startsWith(
                                                                            "00")) {
                                                                      return oldValue;
                                                                    }

                                                                    if (newValue
                                                                            .text
                                                                            .isNotEmpty &&
                                                                        num.tryParse(newValue.text) ==
                                                                            null) {
                                                                      return oldValue;
                                                                    }

                                                                    if (newValue
                                                                        .text
                                                                        .startsWith(
                                                                            ".")) {
                                                                      return newValue.copyWith(
                                                                          text:
                                                                              "0");
                                                                    }

                                                                    if (newValue
                                                                            .text
                                                                            .split(".")
                                                                            .last
                                                                            .length >
                                                                        4) {
                                                                      return oldValue;
                                                                    }

                                                                    return newValue;
                                                                  }),
                                                                ],
                                                                decoration:
                                                                    InputDecoration(
                                                                  contentPadding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  hintText:
                                                                      "miqdor",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    color: dark
                                                                        .withValues(
                                                                            alpha:
                                                                                0.2),
                                                                  ),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child:
                                                                    IconButton(
                                                                  style: IconButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        danger.withValues(
                                                                            alpha:
                                                                                0.1),
                                                                    foregroundColor:
                                                                        danger,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    provider.removeRecipe(
                                                                        recipe);
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .delete_rounded),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Tooltip(
                                                        message:
                                                            "${submodel['name']} uchun qo'shish",
                                                        child: InkWell(
                                                          onTap: () {
                                                            var res = provider
                                                                .addRecipe(
                                                                    submodel);
                                                            if (!res) {
                                                              CustomSnackbars(
                                                                      context)
                                                                  .warning(
                                                                      "Avvalgi maxsulotni tanlang!");
                                                            }
                                                          },
                                                          child: Container(
                                                            width: 120,
                                                            height: 36,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              color: primary
                                                                  .withValues(
                                                                      alpha:
                                                                          0.8),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .add_rounded,
                                                                    color: Colors
                                                                        .white),
                                                                Text(
                                                                  " Qo'shish",
                                                                  style: TextTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      ?.copyWith(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 16),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Jami maxsulot: ",
                                            style: TextTheme.of(context)
                                                .titleSmall,
                                          ),
                                          TextSpan(
                                            text: provider
                                                .getSizesQuantity.toCurrency,
                                            style: TextTheme.of(context)
                                                .titleMedium,
                                          ),
                                          TextSpan(
                                            text: " ta",
                                            style: TextTheme.of(context)
                                                .titleSmall,
                                          ),
                                        ],
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                        spellOut: true,
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Jami summa: ",
                                            style: TextTheme.of(context)
                                                .titleSmall,
                                          ),
                                          TextSpan(
                                            text: (provider.getRecipesQuantity *
                                                    provider.getSizesQuantity)
                                                .toCurrency,
                                            style: TextTheme.of(context)
                                                .titleMedium,
                                          ),
                                          TextSpan(
                                            text: "\$",
                                            style: TextTheme.of(context)
                                                .titleSmall,
                                          ),
                                        ],
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                        spellOut: true,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () async {
                                    var res =
                                        await provider.createOrder(context);

                                    if (res == true) {
                                      Get.back();
                                    } else if (res == false) {
                                      CustomSnackbars(context).error(
                                          "Buyurtmani yaratishda xatolik!");
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "Buyurtmani yaratish",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
    });
  }
}
