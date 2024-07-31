import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
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
   DateTime dateTime = Provider.of<HomeScreenProvider>(context,listen: true).dateTime!;
    return Consumer<UserDataProvider>(builder: (context, userprovider, child) {
      bool canbeAddedPGUser=(userprovider.user.userType=="PGUser")?((userprovider.totalMealopt>=3)?false:true):true;
      bool canbeChanged = (widget.isbrekfast || widget.islunch)
          ? ((dateTime.hour < 5 || dateTime.hour >= 21)
              ? true
              : false)
          : ((dateTime.hour < 20 || dateTime.hour >= 21)
              ? true
              : false);
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
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          // margin:const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: (containsMeal && canbeChanged)
                ? AppColor.bluecolor.withOpacity(0.3)
                : Colors.transparent,
            border: Border.all(
                color:( containsMeal && canbeChanged) ? AppColor.bluecolor : Colors.grey),
          ),
          child: Column(
            children: [
              SvgPicture.asset(canbeChanged? (containsMeal
                  ? "assets/images/homepage/checkIconblue.svg"
                  : "assets/images/homepage/checkIcon.svg"):"assets/images/homepage/checkIcon.svg"),
              const Gap(5),
              Text(
                widget.name,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color:canbeChanged? (containsMeal ? AppColor.bluecolor : Colors.grey):Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              const Gap(5),
              Container(
                  width: double.infinity,
                  //  padding:const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(
                          color:canbeAddedPGUser? !canbeChanged
                              ? AppColor.GREY_COLOR_LIGHT.withOpacity(0.4)
                              : AppColor.bluecolor:
                              AppColor.GREY_COLOR_LIGHT.withOpacity(0.4),
                          width: 0.8)),
                  child: containsMeal
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (canbeChanged) {
                                    userprovider.updateMealOpt(
                                        currentValue - 1,
                                        widget.isbrekfast,
                                        widget.islunch,
                                        widget.isdinner,userprovider.user.userType,true);
                                  } else {
                                    Utils.flushbarErrorMessage(
                                        "Cannot be Opted", context);
                                  }
                                },
                                child:  Icon(Icons.remove,
                                    color:canbeChanged? AppColor.bluecolor:AppColor.GREY.withOpacity(0.6))),
                            Text(
                              currentValue.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: canbeChanged? AppColor.bluecolor:AppColor.GREY.withOpacity(0.6),fontSize: 18),
                            ),
                            InkWell(
                                onTap: () {
                                  if (canbeChanged) {
                                    userprovider.updateMealOpt(
                                        currentValue + 1,
                                        widget.isbrekfast,
                                        widget.islunch,
                                        widget.isdinner,userprovider.user.userType);
                                  } else {
                                    Utils.flushbarErrorMessage(
                                        "Cannot be Opted", context);
                                  }
                                },
                                child:  Icon(Icons.add,
                                    color:(canbeAddedPGUser && canbeChanged)?AppColor.bluecolor:AppColor.GREY.withOpacity(0.6))),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            if (canbeChanged) {
                              userprovider.updateMealOpt(
                                  currentValue + 1,
                                  widget.isbrekfast,
                                  widget.islunch,
                                  widget.isdinner,userprovider.user.userType);
                            } else {
                              Utils.flushbarErrorMessage(
                                  "Cannot be Opted", context);
                            }
                          },
                          child: Text(
                            "ADD",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color:canbeAddedPGUser? !canbeChanged
                                          ? AppColor.GREY_COLOR_LIGHT
                                              .withOpacity(0.4)
                                          : AppColor.bluecolor:
                                          AppColor.GREY_COLOR_LIGHT.withOpacity(0.4),
                                      fontWeight: FontWeight.w800,
                                      height: 1.5,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ))
            ],
          ),
        ),
      );
    });
  }
}
