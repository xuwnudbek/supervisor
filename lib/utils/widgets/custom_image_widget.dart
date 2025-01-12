import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

enum Sources { network, asset, file }

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    super.key,
    required this.image,
    this.source = Sources.network,
  });

  final String image;
  final Sources source;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: source == Sources.asset
                    ? Image.asset(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/no_img.png',
                            fit: BoxFit.contain,
                          );
                        },
                      )
                    : source == Sources.file
                        ? Image.file(
                            File(image),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/no_img.png',
                                fit: BoxFit.contain,
                              );
                            },
                          )
                        : source == Sources.network
                            ? Image.network(
                                image.toImageUrl,
                                headers: {"Accept": "image/*"},
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  log("Error: $error");
                                  return Image.asset(
                                    'assets/images/no_img.png',
                                    fit: BoxFit.contain,
                                  );
                                },
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                'assets/images/no_img.png',
                                fit: BoxFit.contain,
                              ),
              ),
            );
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: source == Sources.asset
            ? Image.asset(
                image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/no_img.png',
                    fit: BoxFit.contain,
                  );
                },
              )
            : source == Sources.file
                ? Image.file(
                    File(image),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/no_img.png',
                        fit: BoxFit.contain,
                      );
                    },
                  )
                : source == Sources.network
                    ? Image.network(
                        image.toImageUrl,
                        headers: {"Accept": "image/*"},
                        filterQuality: FilterQuality.high,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/no_img.png',
                            fit: BoxFit.contain,
                          );
                        },
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        'assets/images/no_img.png',
                        fit: BoxFit.contain,
                      ),
      ),
    );
  }
}

extension UrlExtension on String? {
  String get toImageUrl {
    if (this == null) return "https://www.mykite.in/kb/NoImageFound.jpg.png";
    if (this!.contains('rasmlar')) {
      return Uri.parse("https://omborapi.vizzano-apparel.uz:2021/media/$this")
          .toString();
    } else if (this!.contains('images')) {
      return Uri.parse("http://176.124.208.61:2025/$this").toString();
    }
    return "https://www.mykite.in/kb/NoImageFound.jpg.png";
  }
}
