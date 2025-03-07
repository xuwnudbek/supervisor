import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supervisor/utils/extensions/datetime_extension.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_divider.dart';
import 'package:timelines_plus/timelines_plus.dart';

const completeColor = Color(0xff5e6172);
const inProgressColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);

class ProcessTimelinePage extends StatefulWidget {
  const ProcessTimelinePage({
    super.key,
    required this.order,
  });

  final Map order;

  @override
  State<ProcessTimelinePage> createState() => _ProcessTimelinePageState();
}

class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
  Map get order => widget.order;

  List statuses = [
    "active",
    "printing",
    "cutting",
    "sewing",
    "quality_checking",
  ];

  final int _processIndex = 2;

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        direction: Axis.horizontal,
        connectorTheme: ConnectorThemeData(
          space: 30.0,
          thickness: 6.0,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemExtentBuilder: (_, __) => MediaQuery.of(context).size.width / _processes.length - 10,
        oppositeContentsBuilder: (context, index) {
          return oppositeContents[index];
        },
        contentsBuilder: (context, index) {
          return contents[index];
        },
        indicatorBuilder: (_, index) {
          var color;
          var child;
          if (index == _processIndex) {
            color = inProgressColor;
            child = Icon(
              Icons.circle,
              color: Colors.white,
              size: 15.0,
            );
          } else if (index < _processIndex) {
            color = completeColor;
            child = Icon(
              Icons.check,
              color: Colors.white,
              size: 15.0,
            );
          } else {
            color = todoColor;
          }

          TextSpan message = TextSpan(text: "");

          switch (index) {
            case 0:
              Map orderPrintingTime = order["orderPrintingTimes"] ?? {};

              if (orderPrintingTime.isEmpty) {
                message = TextSpan(
                  text: "Ma'lumot yo'q",
                );
                break;
              }

              message = TextSpan(
                children: [
                  TextSpan(
                    text: "Reja: ",
                    style: textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: "${DateTime.parse(orderPrintingTime['planned_time']).toLocal().toYMDHM}",
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  TextSpan(
                    text: "\nBajarilgan: ",
                    style: textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: "${DateTime.parse(orderPrintingTime['actual_time'] ?? "").toLocal().toYMDHM}",
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  // user
                  TextSpan(
                    text: "\nIshchi: ",
                    style: textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: "${orderPrintingTime['user']?['employee']?['name'] ?? "Noma'lum"}",
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  // comment
                  if (orderPrintingTime['comment'] != null)
                    TextSpan(
                      text: "\nIzoh: ",
                      style: textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: "${orderPrintingTime['comment'] ?? "Noma'lum"}",
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                ],
              );
              break;
            case 1:
              List specificationCategories = order["specification_categories"] ?? [];

              if (specificationCategories.isEmpty) {
                message = TextSpan(
                  text: "Ma'lumot yo'q",
                );
                break;
              }

              message = TextSpan(
                children: [
                  WidgetSpan(
                    child: SizedBox(
                      width: 200,
                      height: 400,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ...specificationCategories.map((category) {
                            List orderCuts = category['orderCuts'] ?? [];

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "\n${category?['name'] ?? "Noma'lum"}",
                                      style: textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: orderCuts.length,
                                  itemBuilder: (context, index) {
                                    Map orderCut = orderCuts[index];

                                    return Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "\nBajarilgan: ",
                                            style: textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "${DateTime.parse(orderCut['cut_at'] ?? "").toLocal().toYMDHM}",
                                                style: textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                          TextSpan(
                                            text: "\nMiqdor: ",
                                            style: textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "${orderCut['quantity'] ?? "0"} ta",
                                                style: textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                          TextSpan(
                                            text: "\nIshchi: ",
                                            style: textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "${orderCut['user']?['employee']?['name'] ?? "Noma'lum"}",
                                                style: textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                          if (orderCut['status'] == true)
                                            WidgetSpan(
                                              child: Container(
                                                margin: EdgeInsets.only(top: 4),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4),
                                                  color: Colors.green.withValues(alpha: 0.1),
                                                ),
                                                child: Text(
                                                  "Qabul qilingan",
                                                  style: textTheme.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            )
                                          else
                                            WidgetSpan(
                                              child: Container(
                                                margin: EdgeInsets.only(top: 4),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4),
                                                  color: Colors.red.withValues(alpha: 0.1),
                                                ),
                                                child: Text(
                                                  "Qabul qilinmagan",
                                                  style: textTheme.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          WidgetSpan(
                                            child: CustomDivider(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              );

              break;
            case 2:
              message = TextSpan(
                children: [],
              );

              break;
            case 3:
              message = TextSpan(
                children: [],
              );

              break;
            case 4:
              message = TextSpan(
                children: [],
              );

              break;
            case 5:
              message = TextSpan(
                children: [],
              );

              break;
          }

          return Tooltip(
            richMessage: message,
            // height: 100,
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(8.0),
            preferBelow: false,
            decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8.0), boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.2,
                ),
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(0, 2),
              ),
            ]),
            child: index <= _processIndex
                ? Stack(
                    children: [
                      CustomPaint(
                        size: Size(30.0, 30.0),
                        painter: _BezierPainter(
                          color: color,
                          drawStart: index > 0,
                          drawEnd: index < _processIndex,
                        ),
                      ),
                      DotIndicator(
                        size: 30.0,
                        color: color,
                        child: child,
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      CustomPaint(
                        size: Size(15.0, 15.0),
                        painter: _BezierPainter(
                          color: color,
                          drawEnd: index < _processes.length - 1,
                        ),
                      ),
                      OutlinedDotIndicator(
                        borderWidth: 4.0,
                        color: color,
                      ),
                    ],
                  ),
          );
        },
        connectorBuilder: (_, index, type) {
          if (index > 0) {
            if (index == _processIndex) {
              final prevColor = getColor(index - 1);
              final color = getColor(index);
              List<Color> gradientColors;
              if (type == ConnectorType.start) {
                gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
              } else {
                gradientColors = [prevColor, Color.lerp(prevColor, color, 0.5)!];
              }
              return DecoratedLineConnector(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                  ),
                ),
              );
            } else {
              return SolidLineConnector(
                color: getColor(index),
              );
            }
          } else {
            return null;
          }
        },
        itemCount: _processes.length,
      ),
    );
  }

  List<Widget> get oppositeContents => [
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Image.asset(
            "assets/images/statuses/${_processesIcons[0]}",
            width: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Image.asset(
            "assets/images/statuses/${_processesIcons[1]}",
            width: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Image.asset(
            "assets/images/statuses/${_processesIcons[2]}",
            width: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Image.asset(
            "assets/images/statuses/${_processesIcons[3]}",
            width: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Image.asset(
            "assets/images/statuses/${_processesIcons[4]}",
            width: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Image.asset(
            "assets/images/statuses/${_processesIcons[5]}",
            width: 100,
          ),
        ),
      ];

  List<Widget> get contents => [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            _processes[0],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColor(0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            _processes[1],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColor(1),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            _processes[2],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColor(2),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            _processes[3],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColor(3),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            _processes[4],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColor(4),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            _processes[5],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColor(5),
            ),
          ),
        ),
      ];
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius, radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.drawStart != drawStart || oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = [
  'Chop etish',
  'Kesuv',
  'Tikuv',
  'Sifat nazorati',
  'Qadoqlash',
  'Yetkazish',
];

final _processesIcons = [
  "printing.png",
  "cutting.png",
  "sewing.png",
  "quality_checking.png",
  "packaging.png",
  "shipping.png",
];
