import 'package:flutter/material.dart';

class NamedPictureCard extends StatelessWidget {
  final String name;
  final Function onTap;
  final Future<String> image;

  NamedPictureCard({
    required this.name,
    required this.onTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Column(
          children: [
            Expanded(child: 
            FutureBuilder<String>(
              future: image,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading image');
                } else {
                  return Image.network(
                    snapshot.data!, 
                    fit: BoxFit.cover,
                    );
                }
              },
            ),)
          ],
        ),
      ),
    );
  }
}
