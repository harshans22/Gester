import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';

class MealHistoryScreen extends StatelessWidget {
  final String userId;
  const MealHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {

    int calculateTotalMonthlyMeal(Map<String, Map<String,dynamic>> month) {
      int total = 0;
      month.forEach((key, value) {
        Map<String,dynamic> dailyMeal = value;
        int totalperdaymeal = dailyMeal["breakfast"]+
            dailyMeal["lunch"]+
            dailyMeal["dinner"];
        total += totalperdaymeal;
      });
      return total;
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Meal History",
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
                  children: [
                    FutureBuilder(
                        future: FireStoreMethods().getMonthlyMealOpt(userId),
                        builder: (context,
                            AsyncSnapshot<
                                    Map<String,
                                        Map<String, Map<String, dynamic>>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<String> months = snapshot.data!.keys.toList().reversed.toList();
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                String monthKey = months[index];
                                var data = snapshot.data;
                                Map<String, Map<String, dynamic>> monthData =
                                    data![monthKey]!;
                                int totalMeals = calculateTotalMonthlyMeal(monthData);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeDefault),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Gap(10),
                                          Text("$monthKey 2024",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium),
                                          const Gap(10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.paddingSizeSmall,
                                                vertical: Dimensions
                                                    .paddingSizeExtraSmall),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '$totalMeals',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          color: AppColor
                                                              .GREEN_COLOR),
                                                ),
                                                Text(
                                                  ' Meals',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color: AppColor
                                                              .GREEN_COLOR,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const Gap(10),
                                      Container(
                                        // padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeDefault),
                                        decoration: BoxDecoration(
                                            color: AppColor.SECONDARY,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: List.generate(
                                              monthData.length, (i) {
                                            List<String> days =
                                                monthData.keys.toList().reversed.toList();
                                                 String inputDate = days[i];
  DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(inputDate);
  String formattedDate = DateFormat('dd MMMM').format(parsedDate);
                                            String dayKey = days[i];
                                            Map<String,dynamic> mealData = monthData[dayKey]!;
                                            int totalperdaymeal = 0;
                                            totalperdaymeal = mealData["breakfast"]+
                                                mealData["lunch"]+
                                                mealData["dinner"];
                                            return Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeDefault,
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${mealData["breakfast"].toString()} Breakfast, ${mealData["lunch"].toString()} Lunch, ${mealData["dinner"].toString()} Dinner',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                          color: AppColor.BLACK,
                                                                          fontWeight: FontWeight.w500
                                                                    ),
                                                              )
                                                            ],
                                                          ),
                                                          Text(formattedDate,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall)
                                                        ],
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeSmall,
                                                            vertical: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: totalperdaymeal ==
                                                                  0
                                                              ? AppColor
                                                                  .RED_COLOR
                                                                  .withOpacity(
                                                                      0.1)
                                                              : AppColor
                                                                  .GREEN_COLOR
                                                                  .withOpacity(
                                                                      0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              '$totalperdaymeal',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                    color: totalperdaymeal ==
                                                                            0
                                                                        ? AppColor
                                                                            .RED_COLOR
                                                                            .withOpacity(
                                                                                0.8)
                                                                        : AppColor
                                                                            .GREEN_COLOR,
                                                                            fontWeight: FontWeight.w900
                                                                  ),
                                                            ),
                                                            Text(
                                                              'Meals',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                      color: totalperdaymeal ==
                                                                              0
                                                                          ? AppColor.RED_COLOR.withOpacity(
                                                                              0.8)
                                                                          : AppColor
                                                                              .GREEN_COLOR,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Divider(
                                                  color: AppColor.BG_COLOR,
                                                  height: 1,
                                                  thickness: 1,
                                                )
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }),
                    SizedBox(
                      height: 200,
                      child: SvgPicture.asset(
                          "assets/images/gester food stay.svg"),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
