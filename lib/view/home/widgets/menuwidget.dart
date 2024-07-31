import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/menu_provider.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> todaysMenu =
        Provider.of<MenuProvider>(context, listen: true).getTodaysMenu();
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeDefault,
          horizontal: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Breakfast",
                style: TextStyle(fontSize: 13),
              ),
              const Gap(20),
              Expanded(
                child: Text(
                  todaysMenu[0],
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          const Gap(5),
          Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Lunch",
                style: TextStyle(fontSize: 13),
              ),
              const Gap(40),
              Expanded(
                child: Text(
                  todaysMenu[1],
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          const Gap(5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dinner",
                style: TextStyle(fontSize: 13),
              ),
              const Gap(38),
              Expanded(
                child: Text(
                todaysMenu[2],
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
