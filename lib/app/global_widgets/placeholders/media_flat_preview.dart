import 'package:flutter/material.dart';

class MediaFlatPreviewPlaceholder extends StatelessWidget {
  const MediaFlatPreviewPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(7.5),
            ),
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: const AspectRatio(aspectRatio: 16 / 9),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 15,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
