import 'package:flutter/material.dart';
import 'package:gester/resources/color.dart';

class ActiveButton extends StatelessWidget {
  final bool isactive;
  final VoidCallback onTap;
  const ActiveButton({super.key, required this.isactive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
            color: isactive ? AppColor.GREEN_COLOR : AppColor.RED_COLOR,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          isactive ? "Active" : "Inactive",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColor.WHITE),
        ),
      ),
    );
  }
}
