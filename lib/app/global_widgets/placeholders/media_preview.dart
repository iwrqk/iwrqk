import 'package:flutter/material.dart';

class MediaPreviewPlaceholder extends StatelessWidget {
  const MediaPreviewPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.5),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(7.5),
            ),
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: const AspectRatio(aspectRatio: 16 / 9),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2.5),
                    child: Column(
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: Row(
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
