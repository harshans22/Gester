import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/widgets/activebutton.dart';
import 'package:gester/view/home/widgets/cotaniner_with_padding.dart';
import 'package:gester/view/home/widgets/drop_down_menu.dart';
import 'package:gester/view/home/widgets/meal_subscription_container.dart';
import 'package:svg_flutter/svg.dart';

class MealSubscription extends StatelessWidget {
  const MealSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          "Meal Subscription",
          style: Theme.of(context).textTheme.displayMedium,
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
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraLarge,
                  horizontal: Dimensions.paddingSizeExtraLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Super saver PG Plan",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Gap(10),
                      ActiveButton(),
                    ],
                  ),
                  Text(
                    "Included in your stay Home 2 Home",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const Gap(20),
            const Row(
              children: [
                MealSubscriptionDataContainer(
                  image: "assets/images/meal subscription/rupee.svg",
                  title: "₹0",
                  name: 'Money',
                ),
                Gap(5),
                MealSubscriptionDataContainer(
                  image: "assets/images/meal subscription/meals.svg",
                  title: "7/90",
                  name: 'Meals',
                ),
                Gap(5),
                MealSubscriptionDataContainer(
                  image: "assets/images/meal subscription/calender.svg",
                  title: "23",
                  name: 'Days',
                ),
              ],
            ),
           const Gap(15),
            Container(
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              ),
              child: Column(
                children: [
                  DropDownMenuWidget(
                    title: "Plan status",
                    choosenvalue: (String value) {},
                    list: const ["Active", "Inactive", "Away"],
                     initialvalue:"Active",
                  ),
                 const Divider(
                    color: AppColor.BG_COLOR,
                    thickness: 1,
                    height: 1,
                  ),
                 const ContainerWithPaddingMealSubscription(
                    content: 'Plan Details',
                  ),
                 const Divider(
                    color: AppColor.BG_COLOR,
                    thickness: 1,
                    height: 1,
                  ),
                 const ContainerWithPaddingMealSubscription(
                    content: 'Payments',
                  ),
                 const Divider(
                    color: AppColor.BG_COLOR,
                    thickness: 1,
                    height: 1,
                  ),
                 const ContainerWithPaddingMealSubscription(
                    content: 'Change or end subscription plan',
                  ),
                ],
              ),
            ),
            Expanded(child: SvgPicture.asset("assets/images/gester food stay.svg"))
          ],
        ),
      ),
    );
  }
}
