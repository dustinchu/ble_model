import 'package:flutter/material.dart';

class ArrowAppbar extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const ArrowAppbar({@required this.onPressed, @required this.text, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
            onPressed: onPressed),
        Expanded(
          flex: 1,
          child: Center(child: Text(text, style: TextStyle(fontSize: 20))),
        ),
        // SizedBox(
        //   width: 30.0,
        // )
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.transparent,
            ),
            onPressed: null),
      ],
    );
  }
}
