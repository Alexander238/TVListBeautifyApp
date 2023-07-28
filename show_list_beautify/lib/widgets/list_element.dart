import 'package:flutter/material.dart';
import 'package:show_list_beautify/themes/theme.dart';

class NamedPictureCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final Future<String> image;

  const NamedPictureCard({
    Key? key,
    required this.name,
    required this.onTap,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: image,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
         return InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage(snapshot.data!),
                  fit: BoxFit.cover,
                ),
              ),
              ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
