import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/utils/widgets/profile_container.dart';
import 'package:gester/utils/widgets/textbutton.dart';
import 'package:gester/provider/home_screen_provider.dart';
import 'package:gester/view/home/screens/QuickAcessScreens/MenuCustomizationScreen.dart';
import 'package:gester/view/home/screens/QuickAcessScreens/meal_history_screen.dart';
import 'package:gester/view/home/screens/QuickAcessScreens/menu.dart';
import 'package:gester/view/home/widgets/QuickAccessContainer.dart';
import 'package:gester/view/home/widgets/counterbox.dart';
import 'package:gester/view/home/widgets/menuwidget.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//dialog for success mealopted
  show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
            insetPadding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeExtraLarge),
            backgroundColor: AppColor.WHITE,
            surfaceTintColor: AppColor.WHITE,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeExtraLarge),
              //alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/images/homepage/checkIconGreen.svg"),
                  const Gap(10),
                  Text(
                    "Your meal has been opted!",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColor.PRIMARY, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final homescreenprovider =
        Provider.of<HomeScreenProvider>(context, listen: true);
    final user = Provider.of<UserDataProvider>(context).user;
    final userprovider = Provider.of<UserDataProvider>(context);
    DateTime datetime = homescreenprovider.dateTime;
    int hour = datetime.hour;
    String timeRefrence = "Today";
    if (hour >= 21) {
      datetime = datetime.add(const Duration(days: 1)); //adding date after 9 PM
      timeRefrence = "Tomorrow";
    }

    //show save changes button
    bool showSaveChangesButton = false;
    if (user.breakfast != userprovider.oldbreakfast ||
        user.lunch != userprovider.oldlunch ||
        user.dinner != userprovider.olddinner) {
      if (user.breakfast != userprovider.oldbreakfast ||
          user.lunch != userprovider.oldlunch) {
        if (datetime.hour < 5) {
          showSaveChangesButton = true;
        } else {
          userprovider.resetMealOpt();
          showSaveChangesButton = false;
        }
      }
      if (user.dinner != userprovider.olddinner) {
        if (datetime.hour < 21) {
          //when user is on app ex-8:59 he is on app and saves some value to reset at 9:01
          showSaveChangesButton = true;
        } else {
          userprovider.resetMealOpt();
          showSaveChangesButton = false;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileContainer(),
        const Gap(10),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: Column(
                //  mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault,
                        horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Your meal subscription",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const Gap(10),
                            TextCommonButton(
                              title: "Active",
                              color: AppColor.GREEN_COLOR,
                              textColor: AppColor.WHITE,
                              onTap: () {},
                              fontsize: 12,
                              paddingvertical: 2,
                              paddingHorizontal: Dimensions.paddingSizeSmall,
                              fontWeight: FontWeight.w400,
                            ),
                            // Expanded(child: Container()),
                            // GestureDetector(
                            //     onTap: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (_) =>
                            //                   const MealSubscription()));
                            //     },
                            //     child: const Icon(Icons.chevron_right)),
                          ],
                        ),
                        const Gap(Dimensions.paddingSizeSmall),
                        Text(
                            "Meal opt for $timeRefrence (${"${Utils.getDayName(datetime.weekday)}, ${datetime.day} ${Utils.getMonthName(datetime.month)}"})",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w400)),
                        const Text("Included in your stay at H2H",
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFFB4B4B4))),
                        const Gap(4),
                        homescreenprovider.showEveningTimer
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  color: const Color(0xFFFAA139),
                                ),
                                child: Text(
                                    "  Meal opt closing at 5 PM. Order within ${Utils.getTimeinMinSec(homescreenprovider.dateTime)} mins  ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColor.WHITE,
                                            fontWeight: FontWeight.w100,
                                            height: 1.5)),
                              )
                            : Container(),
                        homescreenprovider.showMorningTimer
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  color: const Color(0xFFFAA139),
                                ),
                                child: Text(
                                  "  Meal opt closing at 5 AM. Order within ${Utils.getTimeinMinSec(homescreenprovider.dateTime)} mins  ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: AppColor.WHITE,
                                          fontWeight: FontWeight.w100,
                                          height: 1.5),
                                ),
                              )
                            : Container(),
                        const Gap(10),
                        const Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CounterBox(
                              name: "Breakfast",
                              isbrekfast: true,
                            ),
                            Gap(10),
                            CounterBox(
                              name: "Lunch",
                              islunch: true,
                            ),
                            Gap(10),
                            CounterBox(
                              name: "Dinner",
                              isdinner: true,
                            ),
                          ],
                        ),
                        const Gap(10),
                        showSaveChangesButton
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextCommonButton(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MenuCustomizationScreen(
                                                      datetime: datetime,
                                                    )));
                                      },
                                      paddingvertical:
                                          Dimensions.paddingSizeSmall,
                                      title: "Customize meal",
                                      color: Colors.transparent,
                                      textColor: AppColor.bluecolor,
                                      borderColor: AppColor.bluecolor,
                                      fontWeight: FontWeight.w400,
                                      isloader: false,
                                    ),
                                  ),
                                  const Gap(5),
                                  Expanded(
                                    child: TextCommonButton(
                                      onTap: () async {
                                        await homescreenprovider.updatemealOpt(
                                            user.breakfast,
                                            user.lunch,
                                            user.dinner,
                                            user.userId,
                                            user.pgNumber,
                                            user.fname,
                                            user.morning.toJson(),
                                            user.evening.toJson());
                                        userprovider.setoldMealtype(
                                            user.breakfast,
                                            user.lunch,
                                            user.dinner);
                                        if (!homescreenprovider.mealoptloader) {
                                          if (!context.mounted) return;
                                          show(context);
                                        }
                                      },
                                      paddingvertical:
                                          Dimensions.paddingSizeSmall,
                                      title: "Save changes",
                                      color: AppColor.bluecolor,
                                      textColor: AppColor.WHITE,
                                      fontWeight: FontWeight.w400,
                                      isloader:
                                          homescreenprovider.mealoptloader,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  const Gap(30),
                  const Text("Today's menu",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      )),
                  const Gap(20),
                  MenuWidget(
                    dateTime: datetime,
                  ),
                  const Gap(20),
                  const Text(
                    "Quick Access",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      QuickAccessContainer(
                        image: "assets/images/homepage/menu.svg",
                        line1: "This week's",
                        line2: "menu",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MenuCard()));
                        },
                      ),
                      QuickAccessContainer(
                        image: "assets/images/homepage/customization.svg",
                        line1: "My meal",
                        line2: "customization",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuCustomizationScreen(
                                        datetime: datetime,
                                      )));
                        },
                      ),
                      QuickAccessContainer(
                        image: "assets/images/homepage/mealopt.svg",
                        line1: "View past",
                        line2: "meal opt",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MealHistoryScreen(
                                        userId: user.userId,
                                      )));
                        },
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
        ),
      ],
    );
  }
}
