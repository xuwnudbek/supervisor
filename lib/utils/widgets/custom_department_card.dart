import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class CustomDepartmentCard extends StatelessWidget {
  const CustomDepartmentCard({
    super.key,
    required this.index,
    required this.department,
    this.onTap,
  });

  final int index;
  final Map department;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${department['name']}",
                  style: textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mas'ul: ",
                  style: textTheme.bodyMedium?.copyWith(
                    color: dark.withValues(alpha: 0.5),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${department['responsible_user']['employee']?['name'] ?? 'Mavjud emas'}",
                    style: textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // department's groups
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Guruhlar:",
                  style: textTheme.bodyMedium?.copyWith(
                    color: dark.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ((department['groups'] ?? []) as List).isEmpty
                  ? Center(
                      child: Text(
                        "Hech qanday guruh topilmadi",
                        style: textTheme.bodySmall?.copyWith(
                          color: dark.withValues(alpha: 0.5),
                        ),
                      ),
                    )
                  : Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        ...(department['groups'] ?? []).map((group) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              group['name'] ?? "Unknown",
                              style: TextTheme.of(context).titleSmall?.copyWith(
                                    color: primary,
                                  ),
                            ),
                          );
                        }),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
