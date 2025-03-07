import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_image_widget.dart';

class ModelCard extends StatelessWidget {
  const ModelCard({
    super.key,
    required this.model,
    required this.onTap,
  });

  final Map model;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    List submodels = model['submodels'] ?? [];
    List sizes = model['sizes'] ?? [];

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ((model['images'] ?? []) as List).isNotEmpty
                  ? Container(
                      width: constraints.maxWidth - 8,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: secondary,
                      ),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 150,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: [
                          ...((model['images'] ?? []) as List).map((image) {
                            return CustomImageWidget(
                              image: image['image'] ?? "",
                              fit: BoxFit.cover,
                            );
                          }),
                        ],
                      ),
                    )
                  : Container(
                      width: constraints.maxWidth - 8,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: secondary,
                      ),
                      child: Center(
                        child: Text(
                          "Rasm yo'q",
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Model: ",
                          style: textTheme.bodySmall,
                        ),
                        Text(
                          model['name'] ?? "Unknown",
                          style: textTheme.bodyMedium?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Submodellar: ",
                          style: textTheme.bodySmall,
                        ),
                        Wrap(
                          runSpacing: 4,
                          spacing: 4,
                          children: [
                            ...submodels.map((submodel) {
                              int index = submodels.indexOf(submodel);

                              return Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: submodel['name'] ?? "",
                                      style: textTheme.bodyMedium?.copyWith(color: primary),
                                    ),
                                    TextSpan(
                                      text: index == submodels.length - 1 ? "" : ", ",
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "O'lchamlar: ",
                          style: textTheme.bodySmall,
                        ),
                        Wrap(
                          runSpacing: 4,
                          spacing: 4,
                          children: [
                            ...sizes.map((size) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  size['name'] ?? "",
                                  style: textTheme.bodyMedium?.copyWith(color: primary),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
