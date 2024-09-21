import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/meal_customization_provider.dart';
import 'package:gester/provider/menu_provider.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/utils/widgets/textbutton.dart';
import 'package:gester/view/home/widgets/drop_down_menu.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class MenuCustomizationScreen extends StatefulWidget {
  final DateTime datetime;
  const MenuCustomizationScreen({super.key, required this.datetime});

  @override
  State<MenuCustomizationScreen> createState() =>
      _MenuCustomizationScreenState();
}

class _MenuCustomizationScreenState extends State<MenuCustomizationScreen> {
  final List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final List<String> _rotilist = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
  ];
  final Map<double, String> _ricequantity = { //TODO: make utility function for this
    0: "No rice",
    0.2: "Bohot kam",
    0.5: "Half",
    0.8: "Full",
    1: "Extra full",
  };

  final Map<String, double> _ricequantityDouble = {
    "No rice": 0,
    "Bohot kam": 0.2,
    "Half": 0.5,
    "Full": 0.8,
    "Extra full": 1
  };

  int _dayselectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.datetime.hour >= 21) {
      _dayselectedIndex = widget.datetime.weekday==7?0:widget.datetime.weekday;
    } else {
      _dayselectedIndex = widget.datetime.weekday - 1;
    }
  }

  bool _sameformorning = false;
  bool _sameforevening = false;

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserDataProvider>(context);
    final menuprovider = Provider.of<MenuProvider>(context);
    final showRaitaandSalad =
        userprovider.user.subscription.subscriptionCode == "P004"
            ? false
            : true;
    return Consumer<MealCustomizationProvider>(
        builder: (context, mealCustomizationProvider, child) {
      final morningmealcustomization = mealCustomizationProvider.morningData;
      final eveningmealcustomization = mealCustomizationProvider.eveningData;
      final oldmorningData = mealCustomizationProvider.oldmorningData;
      final oldeveningData = mealCustomizationProvider.oldeveningData;

      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Meal customization",
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
                  horizontal: Dimensions.paddingSizeSmall),
              child: Column(
                children: [
                  Row(
                          children: List.generate(
                              _days.length,
                              (index) => Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _dayselectedIndex = index;
                                        });
                                      },
                                      child: Container(
                                        key: ValueKey<int>(
                                            index), // Ensure unique key for each child
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                          right: Dimensions.paddingSizeExtraSmall,
                                          left: Dimensions.paddingSizeExtraSmall,
                                          top: Dimensions.paddingSizeLarge,
                                        ),
                                        decoration: BoxDecoration(
                                            color: index == _dayselectedIndex
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          _days[index],
                                          style: TextStyle(
                                            color: index == _dayselectedIndex
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                  const Gap(20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Row(
                            children: [
                              const Gap(20),
                              Text("Morning(Breakfast & Lunch)",
                                  style: Theme.of(context).textTheme.displayMedium),
                            ],
                          ),
                          const Gap(15),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                DropDownMenuWidget(
                                  title: "Dietary Preference",
                                  choosenvalue: (String value) {
                                    morningmealcustomization[_dayselectedIndex]
                                        .dietaryPrefrence = value;
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: menuprovider
                                      .menu!
                                      .weeklyMenu[
                                          Utils.getDayName(_dayselectedIndex + 1)]![4]
                                          ["lunch"]
                                      .cast<String>(),
                                  value: morningmealcustomization[_dayselectedIndex]
                                      .dietaryPrefrence,
                                ),
                                DropDownMenuWidget(
                                  title: "Number of roti",
                                  choosenvalue: (String value) {
                                    morningmealcustomization[_dayselectedIndex]
                                        .numberofRoti = int.parse(value);
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: _rotilist,
                                  value: morningmealcustomization[_dayselectedIndex]
                                      .numberofRoti
                                      .toString(),
                                ),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                DropDownMenuWidget(
                                  title: "Rice quantity",
                                  choosenvalue: (String value) {
                                    morningmealcustomization[_dayselectedIndex]
                                        .riceQuantity = _ricequantityDouble[value]!;
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: _ricequantity.values.toList(),
                                  value: _ricequantity[
                                      morningmealcustomization[_dayselectedIndex]
                                          .riceQuantity]!,
                                ),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                DropDownMenuWidget(
                                  title: "Opt for daal",
                                  choosenvalue: (String value) {
                                    morningmealcustomization[_dayselectedIndex].daal =
                                        value == "Yes" ? true : false;
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: const ["Yes", "No"],
                                  value:
                                      morningmealcustomization[_dayselectedIndex].daal
                                          ? "Yes"
                                          : "No",
                                ),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                DropDownMenuWidget(
                                  title: "Opt for sukhi sabji",
                                  choosenvalue: (String value) {
                                    morningmealcustomization[_dayselectedIndex]
                                        .sukhiSabji = value == "Yes" ? true : false;
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: const ["Yes", "No"],
                                  value: morningmealcustomization[_dayselectedIndex]
                                          .sukhiSabji
                                      ? "Yes"
                                      : "No",
                                ),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                showRaitaandSalad
                                    ? DropDownMenuWidget(
                                        title: "Raita",
                                        choosenvalue: (String value) {
                                          morningmealcustomization[_dayselectedIndex]
                                              .raita = value == "Yes" ? true : false;
                                          mealCustomizationProvider.notifylistner();
                                        },
                                        list: const ["Yes", "No"],
                                        value: morningmealcustomization[
                                                    _dayselectedIndex]
                                                .raita
                                            ? "Yes"
                                            : "No")
                                    : Container(),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                showRaitaandSalad
                                    ? DropDownMenuWidget(
                                        title: "Salad",
                                        choosenvalue: (String value) {
                                          morningmealcustomization[_dayselectedIndex]
                                              .salad = value == "Yes" ? true : false;
                                          mealCustomizationProvider.notifylistner();
                                        },
                                        list: const ["Yes", "No"],
                                        value: morningmealcustomization[
                                                    _dayselectedIndex]
                                                .salad
                                            ? "Yes"
                                            : "No",
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Checkbox(
                                  value: _sameformorning,
                                  onChanged: (value) {
                                    setState(() {
                                      _sameformorning = value!;
                                    });
                                  }),
                              Text(
                                "Same for every morning",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const Gap(20),
                          Row(
                            children: [
                              const Gap(20),
                              Text("Evening (Dinner)",
                                  style: Theme.of(context).textTheme.displayMedium),
                            ],
                          ),
                          const Gap(15),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                DropDownMenuWidget(
                                  title: "Dietary Preference",
                                  choosenvalue: (String value) {
                                    eveningmealcustomization[_dayselectedIndex]
                                        .dietaryPrefrence = value;
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: menuprovider
                                      .menu!
                                      .weeklyMenu[
                                          Utils.getDayName(_dayselectedIndex + 1)]![4]
                                          ["dinner"]
                                      .cast<String>(),
                                  value: eveningmealcustomization[_dayselectedIndex]
                                      .dietaryPrefrence,
                                ),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                DropDownMenuWidget(
                                  title: "Number of roti",
                                  choosenvalue: (String value) {
                                    eveningmealcustomization[_dayselectedIndex]
                                        .numberofRoti = int.parse(value);
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: _rotilist,
                                  value: eveningmealcustomization[_dayselectedIndex]
                                      .numberofRoti
                                      .toString(),
                                ),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                DropDownMenuWidget(
                                  title: "Rice quantity",
                                  choosenvalue: (String value) {
                                    eveningmealcustomization[_dayselectedIndex]
                                        .riceQuantity = _ricequantityDouble[value]!;
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: _ricequantity.values.toList(),
                                  value: _ricequantity[
                                      eveningmealcustomization[_dayselectedIndex]
                                          .riceQuantity]!,
                                  // value: 'c',
                                ),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                DropDownMenuWidget(
                                  title: "Opt for daal",
                                  choosenvalue: (String value) {
                                    eveningmealcustomization[_dayselectedIndex].daal =
                                        value == "Yes" ? true : false;
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: const ["Yes", "No"],
                                  value:
                                      eveningmealcustomization[_dayselectedIndex].daal
                                          ? "Yes"
                                          : "No",
                                ),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                DropDownMenuWidget(
                                  title: "Opt for sukhi sabji",
                                  choosenvalue: (String value) {
                                    eveningmealcustomization[_dayselectedIndex]
                                        .sukhiSabji = value == "Yes" ? true : false;
                                    mealCustomizationProvider.notifylistner();
                                  },
                                  list: const ["Yes", "No"],
                                  value: eveningmealcustomization[_dayselectedIndex]
                                          .sukhiSabji
                                      ? "Yes"
                                      : "No",
                                ),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                showRaitaandSalad
                                    ? DropDownMenuWidget(
                                        title: "Raita",
                                        choosenvalue: (String value) {
                                          eveningmealcustomization[_dayselectedIndex]
                                              .raita = value == "Yes" ? true : false;
                                          mealCustomizationProvider.notifylistner();
                                        },
                                        list: const ["Yes", "No"],
                                        value: eveningmealcustomization[
                                                    _dayselectedIndex]
                                                .raita
                                            ? "Yes"
                                            : "No",
                                      )
                                    : Container(),
                                const Divider(
                                  color: AppColor.BG_COLOR,
                                  height: 1,
                                ),
                                showRaitaandSalad
                                    ? DropDownMenuWidget(
                                        title: "Salad",
                                        choosenvalue: (String value) {
                                          eveningmealcustomization[_dayselectedIndex]
                                              .salad = value == "Yes" ? true : false;
                                          mealCustomizationProvider.notifylistner();
                                        },
                                        list: const ["Yes", "No"],
                                        value: eveningmealcustomization[
                                                    _dayselectedIndex]
                                                .salad
                                            ? "Yes"
                                            : "No",
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Checkbox(
                                  value: _sameforevening,
                                  onChanged: (value) {
                                    setState(() {
                                      _sameforevening = value!;
                                    });
                                  }),
                              Text(
                                "Same for every evening",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 200,
                            child: Center(
                                child: SvgPicture.asset(
                                    "assets/images/gester food stay.svg")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.GREY_COLOR_LIGHT.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child:
                    // bool isChanged = (userprovider.oldeveningData !=
                    //         morningmealcustomization) ||
                    //     (userprovider.oldeveningData != eveningmealcustomization);
                    TextCommonButton(
                  title: "Save & continue",
                  color: true //TODO ; compare instance of classes for button color
                      ? AppColor.PRIMARY
                      : AppColor.GREY.withOpacity(0.2),
                  textColor: AppColor.WHITE,
                  isloader: mealCustomizationProvider.loader,
                  onTap: () async {
                    if (userprovider.user.userType != "PGUser") {
                      Utils.showWithSingleButton(
                          context, "Your currently don't have any Active Plan ",
                          onTap: () {
                        Navigator.pop(context);
                      }, buttonTitle: 'Okay, Got it');
                    } else {
                      if (widget.datetime.hour >= 17 &&
                          widget.datetime.hour < 21) {
                        Utils.showWithSingleButton(context,
                            "You can't customize today's meal between 5pm to 9pm",
                            onTap: () {
                          Navigator.pop(context);
                        }, buttonTitle: 'Okay, Got it');
                      } else {
                        await mealCustomizationProvider.updateMealCustomization(
                            userprovider.user.userId,
                            userprovider.user.pgNumber,
                            userprovider.user.fname,
                            morningmealcustomization[_dayselectedIndex]
                                .toJson(),
                            eveningmealcustomization[_dayselectedIndex]
                                .toJson(),
                            _sameformorning,
                            _sameforevening,
                            _dayselectedIndex + 1,
                            userprovider.user.breakfast,
                            userprovider.user.lunch,
                            userprovider.user.dinner,
                            widget.datetime,
                            userprovider.user.photoUrl);
                        mealCustomizationProvider.setoldMealCustomization(
                            morningmealcustomization, eveningmealcustomization);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        Utils.showWithNoButton(context,
                            title: "Meal Customized Successfully");
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
