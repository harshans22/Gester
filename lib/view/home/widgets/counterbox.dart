import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/provider/meal_customization_provider.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/app_constants.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/provider/home_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class CounterBox extends StatefulWidget {
  final String name;
  final bool isbrekfast;
  final bool islunch;
  final bool isdinner;
  const CounterBox({
    super.key,
    required this.name,
    this.isbrekfast = false,
    this.islunch = false,
    this.isdinner = false,
  });

  @override
  State<CounterBox> createState() => _CheckBoxWigdetState();
}

class _CheckBoxWigdetState extends State<CounterBox> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = Provider.of<HomeScreenProvider>(context)
        .dateTime; //TODO: make date time such that u don't need always check the condition of after 9

    return Consumer<UserDataProvider>(builder: (context, userprovider, child) {
      bool isactive =
          userprovider.user.subscription.status == Appconstants.statusActive;

      bool isPGUser = userprovider.user.subscription.subscriptionCode == "P004";
      bool canbeAddedPGUser = ((userprovider.totalMealopt >= 3) ? false : true);
      bool canbeChanged = (widget.isbrekfast || widget.islunch)
          ? ((dateTime.hour < 5 || dateTime.hour >= 21) ? true : false)
          : ((dateTime.hour < 17 || dateTime.hour >= 21) ? true : false);
      bool containsMeal = widget.isbrekfast // to show ADD or (- 1 +)
          ? userprovider.user.breakfast > 0
          : widget.islunch
              ? userprovider.user.lunch > 0
              : userprovider.user.dinner > 0;
      int currentValue = widget.isbrekfast
          ? userprovider.user.breakfast
          : widget.islunch
              ? userprovider.user.lunch
              : userprovider.user.dinner;
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeExtraSmall,horizontal: Dimensions.paddingSizeExtraSmall),
          // margin:const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: isPGUser
                  ? ((containsMeal && canbeChanged)
                      ? AppColor.bluecolor.withOpacity(0.3)
                      : Colors.transparent)
                  : Colors.transparent,
              border: Border.all(
                color: isPGUser
                    ? ((containsMeal && canbeChanged)
                        ? AppColor.bluecolor
                        : Colors.grey)
                    : Colors.grey,
              )),
          child: Column(
            children: [
              SvgPicture.asset(isPGUser
                  ? (canbeChanged
                      ? (containsMeal
                          ? "assets/images/homepage/checkIconblue.svg"
                          : "assets/images/homepage/checkIcon.svg")
                      : "assets/images/homepage/checkIcon.svg")
                  : "assets/images/homepage/checkIcon.svg"),
              const Gap(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: isPGUser
                            ? (canbeChanged
                                ? (containsMeal
                                    ? AppColor.bluecolor
                                    : Colors.grey)
                                : Colors.grey)
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                        ),
                  ),
                  Gap(4),
                  SvgPicture.asset(
                    widget.isbrekfast || widget.islunch
                        ? Appconstants.dietaryPrefrenceImageIcon[context
                            .read<MealCustomizationProvider>()
                            .oldmorningData[dateTime.hour >= 21
                                ? dateTime.weekday
                                : dateTime.weekday - 1]
                            .dietaryPrefrence]
                        : Appconstants.dietaryPrefrenceImageIcon[context
                            .read<MealCustomizationProvider>()
                            .oldeveningData[dateTime.hour >= 21
                                ? dateTime.weekday
                                : dateTime.weekday - 1]
                            .dietaryPrefrence],
                  )
                ],
              ),
              const Gap(5),
              Container(
                width: double.infinity,
                //  padding:const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(
                        color: isPGUser
                            ? (canbeAddedPGUser
                                ? !canbeChanged
                                    ? AppColor.GREY_COLOR_LIGHT.withOpacity(0.4)
                                    : AppColor.bluecolor
                                : AppColor.GREY_COLOR_LIGHT.withOpacity(0.4))
                            : AppColor.GREY_COLOR_LIGHT.withOpacity(0.4),
                        width: 0.8)),
                child: containsMeal
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                if (!canbeChanged) {
                                  Utils.showWithSingleButton(context,
                                      "Your ${widget.name} is Locked. Cannot be changed after ${(widget.isbrekfast || widget.islunch) ? '5 AM' : '5 PM'}",
                                      buttonTitle: "Okay, Got it!", onTap: () {
                                    Navigator.pop(context);
                                  });
                                } else if (currentValue == 1) {
                                  Utils.showWithDoubleButton(
                                      context,
                                      "You are about to cancel a meal",
                                      "Are you sure you want to cancel your ${widget.name}. This Action can be undone before ${(widget.isbrekfast || widget.islunch) ? '5 AM' : '5 PM'}",
                                      onYes: () {
                                    userprovider.updateMealOpt(
                                        currentValue - 1,
                                        widget.isbrekfast,
                                        widget.islunch,
                                        widget.isdinner,
                                        userprovider.user.userType,
                                        true);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  if(userprovider.user.subscription.status == Appconstants.statusAway){
                                    userprovider.setsubscriptionstatus("Active");
                                    //update subsription in database
                                    FireStoreMethods()
                                   .changemealSubscriptionStatus(
                                    userprovider.user.userId,
                                    userprovider.user.subscription);
                                    }
                                  
                                  userprovider.updateMealOpt(
                                      currentValue - 1,
                                      widget.isbrekfast,
                                      widget.islunch,
                                      widget.isdinner,
                                      userprovider.user.userType,
                                      true);
                                }
                              },
                              child: Icon(Icons.remove,
                                  color: canbeChanged
                                      ? AppColor.bluecolor
                                      : AppColor.GREY.withOpacity(0.6))),
                          Text(
                            currentValue.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: canbeChanged
                                        ? AppColor.bluecolor
                                        : AppColor.GREY.withOpacity(0.6),
                                    fontSize: 18),
                          ),
                          InkWell(
                              onTap: () {
                                if (canbeAddedPGUser && canbeChanged) {
                                   if(userprovider.user.subscription.status == Appconstants.statusAway){
                                    userprovider.setsubscriptionstatus("Active");
                                    FireStoreMethods()
                                   .changemealSubscriptionStatus(
                                    userprovider.user.userId,
                                    userprovider.user.subscription);
                                  }
                                  userprovider.updateMealOpt(
                                      currentValue + 1,
                                      widget.isbrekfast,
                                      widget.islunch,
                                      widget.isdinner,
                                      userprovider.user.userType);
                                } else if (!canbeAddedPGUser && canbeChanged) {
                                  Utils.showWithSingleButton(context,
                                      "You cannot opt more than a total of 3 meals in a day",
                                      onTap: () {
                                    Navigator.pop(context);
                                  }, buttonTitle: "Okay, Got it!");
                                } else {
                                  Utils.showWithSingleButton(context,
                                      "Your ${widget.name} is Locked. Cannot be changed after ${(widget.isbrekfast || widget.islunch) ? '5 AM' : '5 PM'}",
                                      buttonTitle: "Okay, Got it!", onTap: () {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: Icon(Icons.add,
                                  color: (canbeAddedPGUser && canbeChanged)
                                      ? AppColor.bluecolor
                                      : AppColor.GREY.withOpacity(0.6))),
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          if (!isPGUser) {
                            Utils.showWithSingleButton(context,
                                "Your currently don't have any Active Plan ",
                                onTap: () {
                              Navigator.pop(context);
                            }, buttonTitle: 'Okay, Got it');
                          } else if (canbeChanged && canbeAddedPGUser) {
                             if(userprovider.user.subscription.status == Appconstants.statusAway){
                                    userprovider.setsubscriptionstatus("Active");
                                    FireStoreMethods()
                                   .changemealSubscriptionStatus(
                                    userprovider.user.userId,
                                    userprovider.user.subscription);
                                  }
                                  
                            userprovider.updateMealOpt(
                                currentValue + 1,
                                widget.isbrekfast,
                                widget.islunch,
                                widget.isdinner,
                                userprovider.user.userType);
                          } else if (canbeChanged && !canbeAddedPGUser) {
                            Utils.showWithSingleButton(context,
                                "You cannot opt more than a total of 3 meals in a day",
                                onTap: () {
                              Navigator.pop(context);
                            }, buttonTitle: "Okay, Got it!");
                          } else {
                            Utils.showWithSingleButton(context,
                                "Your ${widget.name} is Locked. Cannot be changed after ${(widget.isbrekfast || widget.islunch) ? '5 AM' : '5 PM'}",
                                buttonTitle: "Okay, Got it!", onTap: () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Text(
                          "ADD",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: isPGUser
                                        ? (canbeAddedPGUser
                                            ? !canbeChanged
                                                ? AppColor.GREY_COLOR_LIGHT
                                                    .withOpacity(0.4)
                                                : AppColor.bluecolor
                                            : AppColor.GREY_COLOR_LIGHT
                                                .withOpacity(0.4))
                                        : AppColor.GREY_COLOR_LIGHT
                                            .withOpacity(0.4),
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
