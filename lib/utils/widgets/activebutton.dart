import 'package:flutter/material.dart';
import 'package:gester/resources/color.dart';

class ActiveButton extends StatelessWidget {
  const ActiveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                              color: AppColor.GREEN_COLOR,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Active",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: AppColor.WHITE),
                          ),
                        );
  }
}