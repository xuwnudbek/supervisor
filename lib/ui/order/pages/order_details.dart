import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/provider/order_detail_provider.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/rgb.dart';
import 'package:supervisor/utils/widgets/custom_divider.dart';
import 'package:supervisor/utils/widgets/custom_dotted_widget.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({
    super.key,
    required this.orderId,
  });

  final int orderId;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

/*
{
    "id": 37,
    "name": "Free Style",
    "quantity": 300,
    "status": "inactive",
    "start_date": "2024-12-21 00:00:00",
    "end_date": "2024-12-31 00:00:00",
    "rasxod": "0.6",
    "order_models": [
        {
            "id": 30,
            "rasxod": "0",
            "submodels": [
                {
                    "id": 32,
                    "order_model_id": 30,
                    "submodel_id": 19,
                    "size_id": 3,
                    "quantity": 300,
                    "model_color_id": 43,
                    "recipes": [
                        {
                            "id": 25,
                            "order_id": 37,
                            "quantity": "1221",
                            "item": {
                                "id": 13,
                                "name": "лента ременная 20мм серая 8г/м",
                                "price": "10",
                                "image": "",
                                "code": "58063210",
                                "qr_code": "2a594148-6b9b-4432-9a54-580e90af4a00",
                                "unit": {
                                    "id": 4,
                                    "name": "Litr",
                                    "created_at": "2024-12-06T06:36:29.000000Z",
                                    "updated_at": "2024-12-08T13:35:00.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 1,
                                    "name": "furnitura"
                                }
                            }
                        },
                        {
                            "id": 26,
                            "order_id": 37,
                            "quantity": "101",
                            "item": {
                                "id": 5,
                                "name": "ППУ 18-25 2000*.*10мм PR:F.1, T-CL (+/- 5см",
                                "price": "1.02",
                                "image": "",
                                "code": "3921131000",
                                "qr_code": "09bd3887-a615-48cc-97cf-3e1d8ceba0c5",
                                "unit": {
                                    "id": 1,
                                    "name": "Metr",
                                    "created_at": "2024-12-06T16:35:41.000000Z",
                                    "updated_at": "2024-12-06T16:35:41.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 1,
                                    "name": "furnitura"
                                }
                            }
                        },
                        {
                            "id": 27,
                            "order_id": 37,
                            "quantity": "1",
                            "item": {
                                "id": 7,
                                "name": "кнопка 9/15 серая Альфа тип В (новая)",
                                "price": "312",
                                "image": "",
                                "code": "9606100000",
                                "qr_code": "21f1b0ed-fff7-40e5-be15-ad68ec847a02",
                                "unit": {
                                    "id": 3,
                                    "name": "Dona",
                                    "created_at": "2024-12-06T06:36:24.000000Z",
                                    "updated_at": "2024-12-08T13:31:06.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 1,
                                    "name": "furnitura"
                                }
                            }
                        },
                        {
                            "id": 28,
                            "order_id": 37,
                            "quantity": "10",
                            "item": {
                                "id": 4,
                                "name": "вшивной ярлык черно/белый Nika 40х44",
                                "price": "0.018",
                                "image": "",
                                "code": "5810921000",
                                "qr_code": "100cacb9-5a8e-400a-ae58-2d19b75e3db9",
                                "unit": {
                                    "id": 3,
                                    "name": "Dona",
                                    "created_at": "2024-12-06T06:36:24.000000Z",
                                    "updated_at": "2024-12-08T13:31:06.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 1,
                                    "name": "furnitura"
                                }
                            }
                        },
                        {
                            "id": 29,
                            "order_id": 37,
                            "quantity": "121",
                            "item": {
                                "id": 10,
                                "name": "лента контактная 25мм серая 18-4105трх",
                                "price": "1111",
                                "image": "rasmlar/lenta.jpg",
                                "code": "5806100000",
                                "qr_code": "ddeb2be0-be7b-439f-8106-d6d6bd209d0a",
                                "unit": {
                                    "id": 1,
                                    "name": "Metr",
                                    "created_at": "2024-12-06T16:35:41.000000Z",
                                    "updated_at": "2024-12-06T16:35:41.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 3,
                                    "name": "oshhona"
                                }
                            }
                        },
                        {
                            "id": 30,
                            "order_id": 37,
                            "quantity": "100",
                            "item": {
                                "id": 10,
                                "name": "лента контактная 25мм серая 18-4105трх",
                                "price": "1111",
                                "image": "rasmlar/lenta.jpg",
                                "code": "5806100000",
                                "qr_code": "ddeb2be0-be7b-439f-8106-d6d6bd209d0a",
                                "unit": {
                                    "id": 1,
                                    "name": "Metr",
                                    "created_at": "2024-12-06T16:35:41.000000Z",
                                    "updated_at": "2024-12-06T16:35:41.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 3,
                                    "name": "oshhona"
                                }
                            }
                        },
                        {
                            "id": 31,
                            "order_id": 37,
                            "quantity": "12",
                            "item": {
                                "id": 10,
                                "name": "лента контактная 25мм серая 18-4105трх",
                                "price": "1111",
                                "image": "rasmlar/lenta.jpg",
                                "code": "5806100000",
                                "qr_code": "ddeb2be0-be7b-439f-8106-d6d6bd209d0a",
                                "unit": {
                                    "id": 1,
                                    "name": "Metr",
                                    "created_at": "2024-12-06T16:35:41.000000Z",
                                    "updated_at": "2024-12-06T16:35:41.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 3,
                                    "name": "oshhona"
                                }
                            }
                        },
                        {
                            "id": 32,
                            "order_id": 37,
                            "quantity": "100",
                            "item": {
                                "id": 8,
                                "name": "бегунок 3 (спиральная молния) белый",
                                "price": "0.039",
                                "image": "",
                                "code": "bg-1110",
                                "qr_code": "a5b07028-770b-4886-b436-7dfe11262c76",
                                "unit": {
                                    "id": 3,
                                    "name": "Dona",
                                    "created_at": "2024-12-06T06:36:24.000000Z",
                                    "updated_at": "2024-12-08T13:31:06.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 1,
                                    "name": "furnitura"
                                }
                            }
                        },
                        {
                            "id": 33,
                            "order_id": 37,
                            "quantity": "1213",
                            "item": {
                                "id": 16,
                                "name": "бегунок 5 (спиральная молния) черный никелевый",
                                "price": "4.05",
                                "image": "",
                                "code": "9607201000",
                                "qr_code": "f4d8972b-3235-4bbf-95e2-8fe1c4a2bfb7",
                                "unit": {
                                    "id": 3,
                                    "name": "Dona",
                                    "created_at": "2024-12-06T06:36:24.000000Z",
                                    "updated_at": "2024-12-08T13:31:06.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 1,
                                    "name": "furnitura"
                                }
                            }
                        },
                        {
                            "id": 34,
                            "order_id": 37,
                            "quantity": "14",
                            "item": {
                                "id": 26,
                                "name": "лента ременная 30мм серая 13г/м",
                                "price": "0.4",
                                "image": "",
                                "code": "21000",
                                "qr_code": "4aa745e7-2566-4694-b224-758b39d4eecd",
                                "unit": {
                                    "id": 3,
                                    "name": "Dona",
                                    "created_at": "2024-12-06T06:36:24.000000Z",
                                    "updated_at": "2024-12-08T13:31:06.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 2,
                                    "name": "mato"
                                }
                            }
                        },
                        {
                            "id": 35,
                            "order_id": 37,
                            "quantity": "234",
                            "item": {
                                "id": 9,
                                "name": "строчкой 14г/м",
                                "price": "0.4",
                                "image": "",
                                "code": "5806321",
                                "qr_code": "699cba79-1457-4532-b4a9-4168e5c1a01a",
                                "unit": {
                                    "id": 3,
                                    "name": "Dona",
                                    "created_at": "2024-12-06T06:36:24.000000Z",
                                    "updated_at": "2024-12-08T13:31:06.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 1,
                                    "name": "furnitura"
                                }
                            }
                        },
                        {
                            "id": 36,
                            "order_id": 37,
                            "quantity": "244",
                            "item": {
                                "id": 16,
                                "name": "бегунок 5 (спиральная молния) черный никелевый",
                                "price": "4.05",
                                "image": "",
                                "code": "9607201000",
                                "qr_code": "f4d8972b-3235-4bbf-95e2-8fe1c4a2bfb7",
                                "unit": {
                                    "id": 3,
                                    "name": "Dona",
                                    "created_at": "2024-12-06T06:36:24.000000Z",
                                    "updated_at": "2024-12-08T13:31:06.000000Z"
                                },
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                },
                                "type": {
                                    "id": 1,
                                    "name": "furnitura"
                                }
                            }
                        }
                    ]
                }
            ],
            "model": {
                "id": 8,
                "name": "BMW",
                "rasxod": null,
                "submodels": [
                    {
                        "id": 19,
                        "name": "E30",
                        "sizes": [
                            {
                                "id": 37,
                                "name": "35"
                            },
                            {
                                "id": 38,
                                "name": "36"
                            },
                            {
                                "id": 3,
                                "name": "34"
                            }
                        ],
                        "model_colors": [
                            {
                                "id": 43,
                                "color": {
                                    "id": 9,
                                    "name": "Red Black",
                                    "hex": "FF3600"
                                }
                            },
                            {
                                "id": 41,
                                "color": {
                                    "id": 32,
                                    "name": "Pink",
                                    "hex": "FF00E0"
                                }
                            },
                            {
                                "id": 42,
                                "color": {
                                    "id": 31,
                                    "name": "Jigarrang",
                                    "hex": "6A2D00"
                                }
                            }
                        ]
                    },
                    {
                        "id": 20,
                        "name": "E46",
                        "sizes": [
                            {
                                "id": 39,
                                "name": "34"
                            },
                            {
                                "id": 40,
                                "name": "35"
                            },
                            {
                                "id": 41,
                                "name": "36"
                            }
                        ],
                        "model_colors": [
                            {
                                "id": 46,
                                "color": {
                                    "id": 28,
                                    "name": "Yashil",
                                    "hex": "19FF00"
                                }
                            },
                            {
                                "id": 45,
                                "color": {
                                    "id": 32,
                                    "name": "Pink",
                                    "hex": "FF00E0"
                                }
                            },
                            {
                                "id": 44,
                                "color": {
                                    "id": 32,
                                    "name": "Pink",
                                    "hex": "FF00E0"
                                }
                            }
                        ]
                    }
                ]
            }
        }
    ]
}

*/

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
              title: const Text('Buyurtma ma\'lumotlari'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.orderData.isEmpty
                      ? const Center(
                          child: Text('Buyurtma topilmadi'),
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: light,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: dark.withOpacity(0.2),
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
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: secondary,
                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                  ),
                                                  child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: provider.orderData['order_models'].length,
                                                    itemBuilder: (context, index) {
                                                      Map orderModel = provider.orderData['order_models'][index];

                                                      bool isSelected = provider.selectedOrderModel['id'] == orderModel['id'];

                                                      return GestureDetector(
                                                        onTap: () {
                                                          provider.selectedOrderModel = orderModel;
                                                        },
                                                        child: Container(
                                                          margin: const EdgeInsets.only(right: 8),
                                                          decoration: BoxDecoration(
                                                            color: isSelected ? primary : Colors.white,
                                                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                          ),
                                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            "${orderModel['model']['name']}",
                                                            style: TextStyle(
                                                              color: isSelected ? Colors.white : Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),

                                                const SizedBox(height: 16),
                                                // Submodels

                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: secondary,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: provider.selectedOrderModel.isEmpty
                                                        ? Center(
                                                            child: Text(
                                                              "Model tanlanmagan",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: dark.withOpacity(0.75),
                                                              ),
                                                            ),
                                                          )
                                                        : provider.selectedOrderModel['submodels'].isEmpty
                                                            ? const Center(
                                                                child: Text("Submodel topilmadi"),
                                                              )
                                                            : SingleChildScrollView(
                                                                child: StaggeredGrid.count(
                                                                  crossAxisCount: 3,
                                                                  crossAxisSpacing: 8,
                                                                  mainAxisSpacing: 8,
                                                                  children: [
                                                                    ...[
                                                                      ...provider.selectedOrderModel['submodels'].map<Widget>((orderSubmodel) {
                                                                        Color backgrounColor = orderSubmodel['model_color']['color']['hex'].toString().isEmpty
                                                                            ? Colors.white
                                                                            : Color(
                                                                                int.parse(orderSubmodel['model_color']['color']['hex'], radix: 16),
                                                                              ).withOpacity(1);

                                                                        Color foregroundColor = backgrounColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

                                                                        return Container(
                                                                          decoration: BoxDecoration(
                                                                            color: backgrounColor,
                                                                            borderRadius: BorderRadius.circular(6),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: dark.withOpacity(0.2),
                                                                                blurRadius: 5,
                                                                                offset: const Offset(0, 2),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal: 16,
                                                                            vertical: 8,
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
                                                                            ],
                                                                          ),
                                                                        );
                                                                      })
                                                                    ]
                                                                  ],
                                                                ),
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
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: light,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: dark.withOpacity(0.2),
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
                                            fontWeight: FontWeight.w500,
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
                                            ...provider.collectModelsToTableRow().map((orderModelData) {
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
                                                      0: FlexColumnWidth(1),
                                                      1: FlexColumnWidth(5),
                                                      2: FlexColumnWidth(2),
                                                      3: FlexColumnWidth(2),
                                                      4: FlexColumnWidth(2),
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
                                                                  'Umumiy summasi',
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
                                                      ...recipesTableRows
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                ],
                                              );
                                            }),
                                            const SizedBox(height: 16),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              child: Row(
                                                children: [
                                                  const Text("Umumiy summa: "),
                                                  Text(
                                                    "${provider.totalPrice.toCurrency.split(".").firstOrNull ?? "0"}\$",
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
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
