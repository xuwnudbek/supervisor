import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/provider/add_order_provider.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/extensions/datetime_extension.dart';
import 'package:supervisor/utils/extensions/list_extension.dart';
import 'package:supervisor/utils/formatters/currency_formatter.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';

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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  spacing: 16,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
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
                                      provider.selectedContragent = provider.contragents.firstWhere((e) => e['id'] == id);
                                    },
                                    value: provider.selectedContragent['id'],
                                  ),
                                ),
                                Expanded(
                                  child: CustomInput(
                                    controller: provider.orderRasxodController,
                                    hint: "rasxod",
                                    tooltip: "Harbir maxsulot uchun\nchiqim (\$ dollarda)",
                                    formatters: [
                                      CurrencyInputFormatter(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Tooltip(
                                    message: "Buyurtma olish/topshirish\nsanasini tanlang",
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        fixedSize: const Size.fromHeight(50),
                                        backgroundColor: Colors.grey[200],
                                        foregroundColor: Colors.black,
                                      ),
                                      onPressed: () async {
                                        await showDateRangePicker(
                                          context: context,
                                          firstDate: DateTime.now().subtract(const Duration(days: 14)),
                                          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                                          anchorPoint: Offset(1, 6),
                                          initialDateRange: provider.deadline.isNotEmpty
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
                                            provider.deadline = [date.start, date.end];
                                          }
                                        });
                                      },
                                      child: Text(
                                        provider.deadline.isNotEmpty ? "${provider.deadline[0].format} - ${provider.deadline[1].format}" : "Buyurtma muddati",
                                        style: TextStyle(
                                          color: provider.deadline.isNotEmpty ? null : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 8,
                              children: [
                                Column(
                                  spacing: 8,
                                  children: [
                                    CustomDropdown(
                                      tooltip: "Buyurtma qilingan modelni tanlang",
                                      width: 300,
                                      hint: "Modelni tanlang",
                                      items: provider.models.map((e) {
                                        return DropdownMenuItem(
                                          value: e['id'],
                                          child: Text(e['name']),
                                        );
                                      }).toList(),
                                      onChanged: (id) {
                                        provider.selectedModel = provider.models.firstWhere((e) => e['id'] == id);
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
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      child: provider.submodels.isEmpty
                                          ? Center(
                                              child: Text(
                                                "Bo'sh",
                                                style: TextTheme.of(context).bodySmall?.copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            )
                                          : Wrap(
                                              runSpacing: 8,
                                              spacing: 8,
                                              children: [
                                                ...provider.submodels.map((submodel) {
                                                  bool isSelected = provider.selectedSubmodels.contains(submodel);

                                                  return ChoiceChip(
                                                    label: Text(
                                                      "${submodel['name']}",
                                                      style: TextTheme.of(context).titleMedium?.copyWith(
                                                            color: isSelected ? Colors.white : Colors.black,
                                                          ),
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                    showCheckmark: false,
                                                    selectedColor: primary,
                                                    selected: isSelected,
                                                    onSelected: (selected) {
                                                      if (selected) {
                                                        provider.selectSubmodel(submodel);
                                                      } else {
                                                        provider.removeSelectedSubmodel(submodel);
                                                      }
                                                    },
                                                  );
                                                }),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 300,
                                  height: 208,
                                  decoration: BoxDecoration(
                                    color: secondary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: provider.sizes.isEmpty
                                      ? Center(
                                          child: Text(
                                            "Bo'sh",
                                            style: TextTheme.of(context).bodySmall?.copyWith(
                                                  color: Colors.grey,
                                                ),
                                          ),
                                        )
                                      : Wrap(
                                          runSpacing: 8,
                                          spacing: 8,
                                          children: [
                                            ...provider.sizes.map((size) {
                                              bool isSelected = provider.selectedSizes.contains(size);

                                              return ChoiceChip(
                                                label: Text(
                                                  "${size['name']}",
                                                  style: TextTheme.of(context).titleMedium?.copyWith(
                                                        color: isSelected ? Colors.white : Colors.black,
                                                      ),
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                showCheckmark: false,
                                                selectedColor: primary,
                                                selected: isSelected,
                                                onSelected: (selected) {
                                                  if (selected) {
                                                    provider.selectSize(size);
                                                  } else {
                                                    provider.removeSelectedSize(size);
                                                  }
                                                },
                                              );
                                            }),
                                          ],
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 208,
                                    decoration: BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: provider.selectedSizes.isEmpty
                                        ? Center(
                                            child: Text(
                                              "Bo'sh",
                                              style: TextTheme.of(context).bodySmall?.copyWith(
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            child: Column(
                                              spacing: 8,
                                              children: [
                                                ...provider.selectedSizes.map((size) {
                                                  int index = provider.selectedSizes.indexOf(size);

                                                  return Container(
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                      color: light,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(
                                                      spacing: 8,
                                                      children: [
                                                        SizedBox(width: 2),
                                                        Text(
                                                          "${index + 1}.",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            "${size['name']}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Tooltip(
                                                            message: "${size['name']} o'lcham uchun miqdor",
                                                            child: CustomInput(
                                                              controller: size['quantity'],
                                                              hint: "soni",
                                                            ),
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
                                        "Intruksiya",
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
                                                    borderRadius: BorderRadius.circular(8),
                                                    // color: light,
                                                  ),
                                                  child: Row(
                                                    spacing: 8,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: CustomInput(
                                                          color: light,
                                                          hint: "Instruksiya nomi",
                                                          controller: provider.instructionTitleController,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: CustomInput(
                                                          color: light,
                                                          hint: "Instruksiya izohi",
                                                          controller: provider.instructionBodyController,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          provider.addInstruction(context);
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
                                                      color: dark.withValues(alpha: 0.1),
                                                    ),
                                                    outside: BorderSide(
                                                      color: dark.withValues(alpha: 0.1),
                                                    ),
                                                    // borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  columnWidths: {
                                                    0: FixedColumnWidth(50),
                                                    1: IntrinsicColumnWidth(flex: 1),
                                                    2: IntrinsicColumnWidth(flex: 2),
                                                    3: FixedColumnWidth(56),
                                                  },
                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                  children: [
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Center(
                                                            child: Text(
                                                              "ID",
                                                              style: TextTheme.of(context).titleSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              "Instruction Title",
                                                              style: TextTheme.of(context).titleSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              "Instruction Body",
                                                              style: TextTheme.of(context).titleSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                "#",
                                                                style: TextTheme.of(context).titleSmall,
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
                                                        color: dark.withValues(alpha: 0.1),
                                                        // borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      columnWidths: {
                                                        0: FixedColumnWidth(50),
                                                        1: IntrinsicColumnWidth(flex: 1),
                                                        2: IntrinsicColumnWidth(flex: 2),
                                                        3: FixedColumnWidth(56),
                                                      },
                                                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                      children: [
                                                        ...provider.instructions.map<TableRow>((instruction) {
                                                          int index = provider.instructions.indexOf(instruction);

                                                          return TableRow(
                                                            children: [
                                                              Center(
                                                                child: Text("${index + 1}"),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.all(8),
                                                                child: Text("${instruction['title']}"),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.all(8),
                                                                child: Text("${instruction['body']}"),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.all(8),
                                                                child: IconButton(
                                                                  style: IconButton.styleFrom(
                                                                    backgroundColor: danger.withValues(alpha: 0.1),
                                                                    foregroundColor: danger,
                                                                  ),
                                                                  onPressed: () {
                                                                    provider.removeInstruction(instruction);
                                                                  },
                                                                  icon: Icon(Icons.delete),
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
                    // right side
                    Flexible(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: light,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            SizedBox(),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Homashyolar",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Table(
                                    border: TableBorder.all(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                      color: dark.withValues(alpha: 0.5),
                                    ),
                                    columnWidths: {
                                      0: FixedColumnWidth(50),
                                      1: IntrinsicColumnWidth(flex: 2),
                                      2: FixedColumnWidth(100),
                                      3: FixedColumnWidth(56),
                                    },
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Center(
                                              child: Text(
                                                "ID",
                                                style: TextTheme.of(context).titleSmall,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
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
                                                  "#",
                                                  style: TextTheme.of(context).titleSmall,
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
                                      itemCount: provider.selectedSubmodels.length,
                                      itemBuilder: (context, index) {
                                        Map submodel = provider.selectedSubmodels[index];
                                        List recipes = provider.recipes.qaysiki(['submodel'], submodel);

                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                    color: dark.withValues(alpha: 0.5),
                                                  ),
                                                  top: BorderSide(
                                                    color: dark.withValues(alpha: 0.5),
                                                  ),
                                                  right: BorderSide(
                                                    color: dark.withValues(alpha: 0.5),
                                                  ),
                                                ),
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${submodel['name']}",
                                                    style: TextTheme.of(context).titleMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Table(
                                              border: TableBorder.all(
                                                color: dark.withValues(alpha: 0.5),
                                              ),
                                              columnWidths: {
                                                0: FixedColumnWidth(50),
                                                1: IntrinsicColumnWidth(flex: 2),
                                                2: FixedColumnWidth(100),
                                                3: FixedColumnWidth(56),
                                              },
                                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                              children: [
                                                // recipes
                                                ...recipes.map((recipe) {
                                                  int index = recipes.indexOf(recipe);
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
                                                        child: CustomDropdown(
                                                          color: light,
                                                          borderRadius: BorderRadius.circular(0),
                                                          items: provider.items.map((e) {
                                                            return DropdownMenuItem(
                                                              value: e['id'],
                                                              child: Text(e['name']),
                                                            );
                                                          }).toList(),
                                                          value: item['id'],
                                                          onChanged: (value) {
                                                            provider.selectItemForRecipe(
                                                              submodel: submodel,
                                                              item: provider.items.firstWhere((e) => e['id'] == value),
                                                              index: index,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: TextFormField(
                                                          controller: recipe['quantity'],
                                                          inputFormatters: [
                                                            TextInputFormatter.withFunction((oldValue, newValue) {
                                                              if (newValue.text.startsWith(".")) {
                                                                return newValue.copyWith(text: "0");
                                                              }

                                                              if (newValue.text.split(".").length > 2) {
                                                                return oldValue;
                                                              }

                                                              return newValue;
                                                            }),
                                                            FilteringTextInputFormatter.deny("00"),
                                                            FilteringTextInputFormatter.deny(RegExp(r"^0\d")),
                                                            FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                                                            // CurrencyInputFormatter(),
                                                          ],
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            hintText: "miqdor",
                                                            hintStyle: TextStyle(
                                                              color: dark.withValues(alpha: 0.2),
                                                            ),
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: IconButton(
                                                            style: IconButton.styleFrom(
                                                              backgroundColor: danger.withValues(alpha: 0.1),
                                                              foregroundColor: danger,
                                                            ),
                                                            onPressed: () {
                                                              provider.removeRecipe(recipe);
                                                            },
                                                            icon: Icon(Icons.delete_rounded),
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
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Tooltip(
                                                  message: "${submodel['name']} uchun qo'shish",
                                                  child: InkWell(
                                                    onTap: () {
                                                      provider.addRecipe(submodel);
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 36,
                                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4),
                                                        color: Colors.green.shade700,
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.add_rounded, color: Colors.white),
                                                          Text(
                                                            " Qo'shish",
                                                            style: TextTheme.of(context).titleSmall?.copyWith(
                                                                  color: Colors.white,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Jami summa: ",
                                children: [
                                  TextSpan(
                                    text: "${00}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "\$",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
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
