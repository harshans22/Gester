import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/meal_customization_provider.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/widgets/textbutton.dart';
import 'package:gester/view/home/widgets/drop_down_menu.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class MenuCustomizationScreen extends StatefulWidget {
  final int weekday;
  const MenuCustomizationScreen({super.key, required this.weekday});

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
  final Map<double, String> _ricequantity = {
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

    // TODO: implement initState
    super.initState();
    _dayselectedIndex = widget.weekday - 1;
  }

  bool _sameformorning = false;
  bool _sameforevening = false;
  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserDataProvider>(context);
    final morningmealcustomization =
        Provider.of<UserDataProvider>(context).user.morning;
    final eveningmealcustomization =
        Provider.of<UserDataProvider>(context).user.evening;
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  height: 50,
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
                  const Gap(Dimensions.paddingSizeExtraLarge),
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
                          title: "Number of roti",
                          choosenvalue: (String value) {
                            morningmealcustomization.numberofRoti =
                                int.parse(value);
                          },
                          list: _rotilist,
                          initialvalue:
                              morningmealcustomization.numberofRoti.toString(),
                        ),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                          title: "Rice quantity",
                          choosenvalue: (String value) {
                            morningmealcustomization.riceQuantity =
                                _ricequantityDouble[value]!;
                          },
                          list: _ricequantity.values.toList(),
                          initialvalue: _ricequantity[
                              morningmealcustomization.riceQuantity]!,
                        ),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                          title: "Opt for daal",
                          choosenvalue: (String value) {
                            morningmealcustomization.daal =
                                value == "Yes" ? true : false;
                          },
                          list: const ["Yes", "No"],
                          initialvalue:
                              morningmealcustomization.daal ? "Yes" : "No",
                        ),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                          title: "Opt for sukhi sabji",
                          choosenvalue: (String value) {
                            morningmealcustomization.sukhiSabji =
                                value == "Yes" ? true : false;
                          },
                          list: const ["Yes", "No"],
                          initialvalue: morningmealcustomization.sukhiSabji
                              ? "Yes"
                              : "No",
                        ),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                            title: "Raita",
                            choosenvalue: (String value) {
                              morningmealcustomization.raita =
                                  value == "Yes" ? true : false;
                            },
                            list: const ["Yes", "No"],
                            initialvalue:
                                morningmealcustomization.raita ? "Yes" : "No"),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                          title: "Salad",
                          choosenvalue: (String value) {
                            morningmealcustomization.salad =
                                value == "Yes" ? true : false;
                          },
                          list: const ["Yes", "No"],
                          initialvalue:
                              morningmealcustomization.salad ? "Yes" : "No",
                        ),
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
                          title: "Number of roti",
                          choosenvalue: (String value) {
                            eveningmealcustomization.numberofRoti =
                                int.parse(value);
                          },
                          list: _rotilist,
                          initialvalue:
                              eveningmealcustomization.numberofRoti.toString(),
                        ),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                          title: "Rice quantity",
                          choosenvalue: (String value) {
                            eveningmealcustomization.riceQuantity =
                                _ricequantityDouble[value]!;
                          },
                          list: _ricequantity.values.toList(),
                          initialvalue: _ricequantity[
                              eveningmealcustomization.riceQuantity]!,
                          // initialvalue: 'c',
                        ),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                          title: "Opt for daal",
                          choosenvalue: (String value) {
                            eveningmealcustomization.daal =
                                value == "Yes" ? true : false;
                          },
                          list: const ["Yes", "No"],
                          initialvalue:
                              eveningmealcustomization.daal ? "Yes" : "No",
                        ),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                          title: "Opt for sukhi sabji",
                          choosenvalue: (String value) {
                            eveningmealcustomization.sukhiSabji =
                                value == "Yes" ? true : false;
                          },
                          list: const ["Yes", "No"],
                          initialvalue: eveningmealcustomization.sukhiSabji
                              ? "Yes"
                              : "No",
                        ),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                          title: "Raita",
                          choosenvalue: (String value) {
                            eveningmealcustomization.raita =
                                value == "Yes" ? true : false;
                          },
                          list: const ["Yes", "No"],
                          initialvalue:
                              eveningmealcustomization.raita ? "Yes" : "No",
                        ),
                        const Divider(
                          color: AppColor.BG_COLOR,
                          height: 1,
                        ),
                        DropDownMenuWidget(
                          title: "Salad",
                          choosenvalue: (String value) {
                            eveningmealcustomization.salad =
                                value == "Yes" ? true : false;
                          },
                          list: const ["Yes", "No"],
                          initialvalue:
                              eveningmealcustomization.salad ? "Yes" : "No",
                        ),
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
                  const Gap(40),
                  Consumer<MealCustomizationProvider>(
                    builder: (context, value, child) => TextCommonButton(
                      title: "Save & continue",
                      color: AppColor.PRIMARY,
                      textColor: AppColor.WHITE,
                      isloader: value.getLoader,
                      onTap: () {
                        value.updateMealCustomization(
                            userprovider.user.userId,
                            morningmealcustomization.toJson(),
                            eveningmealcustomization.toJson(),
                            _sameformorning,
                            _sameforevening,
                            _dayselectedIndex);
                      },
                    ),
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
        ),
      ),
    );
  }
}
