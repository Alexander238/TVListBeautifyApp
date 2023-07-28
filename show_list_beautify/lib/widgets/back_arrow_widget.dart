import 'package:flutter/material.dart';
import 'package:show_list_beautify/themes/theme.dart';

class ArrowButton extends StatelessWidget {
  final String text;
  final IconData startIcon;
  final Function? onClick;

  const ArrowButton(
      {required this.text, required this.startIcon, this.onClick, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (onClick == null) {
              Navigator.pop(context);
            } else {
              onClick!();
            }
          },
          icon: Icon(
            startIcon,
            color: whiteText,
          ),
        ),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 20, color: whiteText)),
      ],
    );
  }
}
