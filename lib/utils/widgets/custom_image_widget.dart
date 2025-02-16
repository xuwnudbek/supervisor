import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

enum Sources { network, asset, file }

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    super.key,
    required this.image,
    this.source = Sources.network,
    this.fit,
    this.onSecondaryTap,
  });

  final BoxFit? fit;
  final String image;
  final Sources source;
  final Function? onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("wqdwdqdwwqd");
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: source == Sources.asset
                    ? Image.asset(
                        image,
                        errorBuilder: (context, error, stackTrace) {
                          log("Error: $error");
                          return Image.asset(
                            'assets/images/no_img.png',
                            fit: fit ?? BoxFit.contain,
                          );
                        },
                        fit: fit ?? BoxFit.contain,
                      )
                    : source == Sources.file
                        ? Image.file(
                            File(image),
                            fit: fit ?? BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              log("Error: $error");
                              return Image.asset(
                                'assets/images/no_img.png',
                                fit: fit ?? BoxFit.contain,
                              );
                            },
                          )
                        : Image.network(
                            image.toImageUrl,
                            headers: {"Accept": "image/*"},
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              log("Error: $error");
                              return Image.asset(
                                'assets/images/no_img.png',
                                fit: fit ?? BoxFit.contain,
                              );
                            },
                            fit: fit ?? BoxFit.contain,
                          ),
              ),
            );
          },
        );
      },
      onSecondaryTap: () {
        onSecondaryTap?.call();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: source == Sources.asset
            ? Image.asset(
                image,
                errorBuilder: (context, error, stackTrace) {
                  log("Error: $error");
                  return Image.asset(
                    'assets/images/no_img.png',
                    fit: fit ?? BoxFit.contain,
                  );
                },
                fit: fit ?? BoxFit.contain,
              )
            : source == Sources.file
                ? Image.file(
                    File(image),
                    fit: fit ?? BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      log("Error: $error");
                      return Image.asset(
                        'assets/images/no_img.png',
                        fit: fit ?? BoxFit.contain,
                      );
                    },
                  )
                : Image.network(
                    image.toImageUrl,
                    headers: {"Accept": "image/*"},
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      log("Error: $error");
                      return Image.asset(
                        'assets/images/no_img.png',
                        fit: fit ?? BoxFit.contain,
                      );
                    },
                    alignment: Alignment.topCenter,
                    fit: fit ?? BoxFit.contain,
                  ),
      ),
    );
  }
}

extension UrlExtension on String? {
  String get toImageUrl {
    if (this == null) return "https://www.mykite.in/kb/NoImageFound.jpg.png";

    if (this!.contains('http') && this!.contains('.')) {
      return this!;
    } else if (this!.contains('rasmlar')) {
      return Uri.parse("https://omborapi.vizzano-apparel.uz:2021/media/$this").toString();
    }

    return "https://www.mykite.in/kb/NoImageFound.jpg.png";
  }
}
