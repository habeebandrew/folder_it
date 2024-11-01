import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleAndBackButtonWidget extends StatelessWidget {
  TitleAndBackButtonWidget({
    required this.title,
    super.key,
  });
  String title;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            // constraints: const BoxConstraints(minWidth: 22, maxWidth: 22),
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded)),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
        ),
      ],
    );
  }
}
