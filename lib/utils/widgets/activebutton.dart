import 'package:flutter/material.dart';
import 'package:gester/resources/color.dart';

class ActiveButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onTap;
  const ActiveButton(
      {super.key,
      required this.color,
      required this.onTap,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColor.WHITE),
        ),
      ),
    );
  }
}
