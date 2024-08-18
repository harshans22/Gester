import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/menu_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:provider/provider.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    final weekPeriod=Provider.of<MenuProvider>(context,listen: true).menu!.weekPeriod;
    final  menu =
        Provider.of<MenuProvider>(context,listen: true).menu!.weeklyMenu;

    List<String> _days = menu.keys.toList();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Weekly menu",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            backgroundColor: AppColor.WHITE,
            surfaceTintColor: Colors.transparent,
            shadowColor: AppColor.GREY_COLOR_LIGHT.withOpacity(0.3),
            centerTitle: true,
            elevation: 5,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeDefault),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(weekPeriod,
                      style: Theme.of(context).textTheme.displayMedium),
                  Gap(20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraLarge,
                        vertical: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault)),
                    child: Column(
                      children: List.generate(_days.length, (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _days[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Breakfast - ${menu[_days[index]]![0]}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(height: 1.1)),
                                        Text("Lunch - ${menu[_days[index]]![1]}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(height: 1.1)),
                                        Text("Dinner - ${menu[_days[index]]![2]}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(height: 1.1)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
