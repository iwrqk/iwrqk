import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../core/const/iwara.dart';
import '../data/services/config_service.dart';
import 'iwr_progress_indicator.dart';

class ReloadableImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BoxFit? fit;
  final bool isAdult;

  const ReloadableImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.aspectRatio,
    this.isAdult = false,
  }) : super(key: key);

  @override
  State<ReloadableImage> createState() => _ReloadableImageState();
}

class _ReloadableImageState extends State<ReloadableImage> {
  GlobalKey _imageKey = GlobalKey();
  final ConfigService _configService = Get.find();

  Widget _buildFilterImage(Widget child) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorWidget = GestureDetector(
      onTap: () {
        setState(() {
          _imageKey = GlobalKey();
        });
      },
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.arrowRotateLeft,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );

    if (widget.aspectRatio != null) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: CachedNetworkImage(
          key: _imageKey,
          imageUrl: widget.imageUrl,
          httpHeaders: const {"referer": IwaraConst.referer},
          imageBuilder: widget.isAdult && _configService.adultCoverBlur
              ? (context, imageProvider) {
                  Widget image = Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: widget.fit,
                      ),
                    ),
                  );
                  return _buildFilterImage(image);
                }
              : null,
          fit: widget.fit,
          progressIndicatorBuilder: (context, url, progress) {
            return Center(
                child: Container(
              margin: EdgeInsets.all(5),
              child: IwrProgressIndicator(),
            ));
          },
          errorWidget: (_, __, ___) {
            return errorWidget;
          },
        ),
      );
    } else {
      return CachedNetworkImage(
        key: _imageKey,
        imageUrl: widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        httpHeaders: const {"referer": IwaraConst.referer},
        imageBuilder: widget.isAdult && _configService.adultCoverBlur
            ? (context, imageProvider) {
                Widget image = Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: widget.fit,
                    ),
                  ),
                );
                return _buildFilterImage(image);
              }
            : null,
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
              child: Container(
            margin: EdgeInsets.all(5),
            child: IwrProgressIndicator(),
          ));
        },
        errorWidget: (_, __, ___) {
          return errorWidget;
        },
      );
    }
  }
}
