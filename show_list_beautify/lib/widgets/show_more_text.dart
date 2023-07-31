import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowMoreText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ShowMoreText({
    required this.text,
    required this.maxLines,
  });

  @override
  _ShowMoreTextState createState() => _ShowMoreTextState();
}

class _ShowMoreTextState extends State<ShowMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _isExpanded ? null : widget.maxLines,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12 % MediaQuery.of(context).size.width,
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(_isExpanded ? "Show Less" : "Show More",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10 % MediaQuery.of(context).size.width,
                )),
          ),
        )
      ],
    );
  }
}
