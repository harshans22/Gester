import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/app_constants.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/utils/widgets/activebutton.dart';
import 'package:gester/view/home/widgets/cotaniner_with_padding.dart';
import 'package:gester/view/home/widgets/drop_down_menu.dart';
import 'package:gester/view/home/widgets/meal_subscription_container.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class MealSubscriptionScreen extends StatelessWidget {
  const MealSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserDataProvider>(context, listen: true);

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
                        userprovider.user.subscription.planName,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const Gap(10),
                      ActiveButton(
                        color: Appconstants.subscriptionStatusColor[
                            userprovider.user.subscription.status]!,
                        title: userprovider.user.subscription.status,
                        onTap: () {},
                      )
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
            Row(
              children: [
                MealSubscriptionDataContainer(
                  image: "assets/images/meal subscription/rupee.svg",
                  title:
                      userprovider.user.subscription.subscriptionCode == "P004"
                          ? "_"
                          : "₹0",
                  name: 'Money',
                ),
                const Gap(5),
                MealSubscriptionDataContainer(
                  image: "assets/images/meal subscription/meals.svg",
                  title: userprovider.user.subscription.subscriptionCode ==
                          Appconstants.subsciptionCode4
                      ? "_"
                      : "",
                  name: 'Meals',
                ),
                const Gap(5),
                MealSubscriptionDataContainer(
                  image: "assets/images/meal subscription/calender.svg",
                  title: userprovider.user.subscription.subscriptionCode ==
                          Appconstants.subsciptionCode4
                      ? "_"
                      : "",
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
                    choosenvalue: (String value) async {
                      userprovider.setsubscriptionstatus(value);
                      if (!context.mounted) return;
                      Utils.showWithNoButton(context,
                          title:
                              "Your plan subscription was changed to $value");
                      await Future.delayed(const Duration(seconds: 2));
                      try {
                        String res = await FireStoreMethods()
                            .changemealSubscriptionStatus(
                                userprovider.user.userId,
                                userprovider.user.subscription);
                        if (res == "success") {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        logger.e(e.toString());
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        Utils.toastMessage("Failed to change your plan Status",
                            Colors.red.withOpacity(0.7));
                      }
                    },
                    list: ["Active", "Away"],
                    //TODO: add this array to constant file
                    value: userprovider.user.subscription.status,
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
                  // const ContainerWithPaddingMealSubscription(
                  //   content: 'Payments',
                  // ),
                  const Divider(
                    color: AppColor.BG_COLOR,
                    thickness: 1,
                    height: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      Utils.showWithNoButton(context,
                          title: "Contact Us",
                          imagePath: "assets/images/meal subscription/whatsapp.svg");
                    },
                    child: const ContainerWithPaddingMealSubscription(
                      content: 'Change or end subscription plan',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: SvgPicture.asset("assets/images/gester food stay.svg"))
          ],
        ),
      ),
    );
  }
}
