import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class IwrGallery extends StatefulWidget {
  final List<String> imageUrls;
  final bool isfullScreen;
  final int? lastPage;
  final void Function(int index)? onPageChanged;

  const IwrGallery({
    Key? key,
    required this.imageUrls,
    this.isfullScreen = false,
    this.lastPage,
    this.onPageChanged,
  }) : super(key: key);

  @override
  State<IwrGallery> createState() => _IwrGalleryState();
}

class _IwrGalleryState extends State<IwrGallery> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.lastPage ?? 0);
    _currentIndex = widget.lastPage ?? 0;
  }

  Widget _buildGallery() {
    return PhotoViewGallery.builder(
      customSize:
          widget.isfullScreen ? null : Size.copy(MediaQuery.of(context).size),
      builder: (BuildContext context, int index) {
        var imageProvider = CachedNetworkImageProvider(widget.imageUrls[index]);

        return PhotoViewGalleryPageOptions(
          imageProvider: imageProvider,
          initialScale: PhotoViewComputedScale.contained,
          heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.white,
              ),
            );
          },
        );
      },
      itemCount: widget.imageUrls.length,
      loadingBuilder: (context, event) => const Center(
        child: CircularProgressIndicator(),
      ),
      pageController: _pageController,
      onPageChanged: (index) {
        widget.onPageChanged?.call(index);
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _buildDotPageFooter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.imageUrls.length, (index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 150),
                curve: Curves.bounceIn,
              );
            },
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextPageFooter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        "${_currentIndex + 1} / ${widget.imageUrls.length}",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isfullScreen) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: widget.imageUrls.length > 1
              ? Text(
                  "${_currentIndex + 1} / ${widget.imageUrls.length}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )
              : null,
          centerTitle: true,
        ),
        body: Padding(
          padding: MediaQuery.of(context).padding,
          child: Stack(
            children: [
              _buildGallery(),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
              body: IwrGallery(
                isfullScreen: true,
                imageUrls: widget.imageUrls,
                lastPage: _currentIndex,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _pageController.jumpToPage(_currentIndex);
                },
              ),
            ),
          ));
        },
        child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildGallery(),
              Positioned(
                left: 4,
                top: 4,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.3),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: Theme.of(context).appBarTheme.iconTheme?.size,
                  ),
                ),
              ),
              if (widget.imageUrls.length > 15)
                Positioned(bottom: 10, child: _buildTextPageFooter()),
              if (widget.imageUrls.length <= 15 && widget.imageUrls.length > 1)
                Positioned(
                  bottom: 10,
                  child: _buildDotPageFooter(),
                ),
            ],
          ),
        ),
      );
    }
  }
}
