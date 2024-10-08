import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/home_screen_provider.dart';
import 'package:gester/provider/meal_customization_provider.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/app_constants.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/utils/widgets/activebutton.dart';
import 'package:gester/utils/widgets/profile_container.dart';
import 'package:gester/utils/widgets/textbutton.dart';
import 'package:gester/view/home/screens/QuickAcessScreens/meal_history_screen.dart';
import 'package:gester/view/home/screens/QuickAcessScreens/menu.dart';
import 'package:gester/view/home/screens/QuickAcessScreens/menu_customization_screen.dart';
import 'package:gester/view/home/widgets/QuickAccessContainer.dart';
import 'package:gester/view/home/widgets/add_note_dialog.dart';
import 'package:gester/view/home/widgets/carosuel_image_container.dart';
import 'package:gester/view/home/widgets/counterbox.dart';
import 'package:gester/view/home/widgets/mealopt_users_list.dart';
import 'package:gester/view/home/widgets/menuwidget.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

//dialog for success mealopted
  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserDataProvider>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileContainer(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraSmall),
              child: Column(
                //  mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //carosuel slider for banner
                  Consumer<HomeScreenProvider>(
                    builder: (context, value, child) => Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              value.setbannerIndex(index);
                            },
                            autoPlayCurve:
                                Curves.linear, //TODO: change animation
                            autoPlayInterval: const Duration(seconds: 30),
                            autoPlay: true,
                            enlargeCenterPage: true,
                            enlargeFactor: 0,
                            viewportFraction: 1,
                            height: 125,
                          ),
                          items: List.generate(
                              value.bannerImages.length,
                              (index) => CarouselImageSlider(
                                  image: value.bannerImages[index])),
                        ),
                        //white dots for banner
                        Positioned(
                          bottom: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: value.bannerImages
                                .asMap()
                                .entries
                                .map((entry) {
                              return Container(
                                width: value.bannerIndex == entry.key ? 12 : 7,
                                height: 7.0,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3.0,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                    color: value.bannerIndex == entry.key
                                        ? AppColor.GREY_COLOR_LIGHT
                                            .withOpacity(0.5)
                                        : Colors.transparent),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(10),

                  //meal Opt Container
                  //TODO: make it as a widget
                  //TODO: this container is rebuild every second fix that or optimize that
                  Consumer<HomeScreenProvider>(
                    builder: (context, homescreenprovider, child) {
                      //reset meal opt at 9 PM and 5 AM and 5 PM
                      if ((homescreenprovider.dateTime.hour == 21 ||
                              homescreenprovider.dateTime.hour == 17 ||
                              homescreenprovider.dateTime.hour == 5) &&
                          homescreenprovider.dateTime.minute == 0 &&
                          homescreenprovider.dateTime.second == 0) {
                        userprovider.resetMealOpt();
                      }
                      DateTime datetime = homescreenprovider.dateTime;
                      int hour = datetime.hour;
                      if (hour >= 21) {
                        homescreenprovider.settimeRefrence(
                            "Tomorrow's"); //TODO: don't do it here make something else
                        datetime = datetime.add(const Duration(days: 1));
                      }
                      return Container(
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
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                const Gap(10),
                                ActiveButton(
                                  color: Appconstants.subscriptionStatusColor[
                                      userprovider.user.subscription.status]!,
                                  title: userprovider.user.subscription.status,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const Gap(Dimensions.paddingSizeSmall),
                            Text(
                                "Meal opt for ${homescreenprovider.dateTime.hour >= 21 ? "tomorrow" : "today"} (${"${Utils.getDayName(datetime.weekday)}, ${datetime.day} ${Utils.getMonthName(datetime.month)}"})",
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
                                                fontWeight: FontWeight.w400,
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
                                              fontWeight: FontWeight.w400,
                                              height: 1.5),
                                    ),
                                  )
                                : Container(),
                            const Gap(10),

                            const CounterBox(
                              name: "Breakfast",
                              isbrekfast: true,
                            ),
                            const Gap(10),
                            const CounterBox(
                              name: "Lunch",
                              islunch: true,
                            ),
                            const Gap(10),
                            const CounterBox(
                              name: "Dinner",
                              isdinner: true,
                            ),

                            const Gap(10),

                            //to show add note
                            if (userprovider.user.breakfast > 0 ||
                                userprovider.user.lunch > 0 ||
                                userprovider.user.dinner > 0)
                              const AddNote(),
                            const Gap(10),
                            (userprovider.user.breakfast !=
                                        userprovider.oldbreakfast ||
                                    userprovider.user.lunch !=
                                        userprovider.oldlunch ||
                                    userprovider.user.dinner !=
                                        userprovider.olddinner)
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
                                                          datetime:
                                                              homescreenprovider
                                                                  .dateTime,
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
                                            // await FireStoreMethods()
                                            //     .updatePGUsersMealOpt(
                                            //         userprovider.user.pgNumber,
                                            //         userprovider.user.userId,
                                            //         datetime,
                                            //         (userprovider.user.breakfast +
                                            //             userprovider.user.lunch +
                                            //             userprovider.user.dinner),
                                            //         userprovider.user.photoUrl,
                                            //         userprovider.user.fname);
                                            if (!context.mounted) return;
                                            await homescreenprovider
                                                .updatemealOpt(
                                                    userprovider.user.breakfast,
                                                    userprovider.user.lunch,
                                                    userprovider.user.dinner,
                                                    userprovider.user.userId,
                                                    userprovider.user.pgNumber,
                                                    userprovider.user.fname,
                                                    userprovider.user.photoUrl,
                                                    context
                                                        .read<
                                                            MealCustomizationProvider>()
                                                        .oldmorningData[
                                                            homescreenprovider
                                                                        .dateTime
                                                                        .hour >=
                                                                    21
                                                                ? (datetime.weekday ==
                                                                        7)
                                                                    ? 0
                                                                    : datetime
                                                                        .weekday
                                                                : datetime.weekday -
                                                                    1]
                                                        .toJson(),
                                                    context
                                                        .read<
                                                            MealCustomizationProvider>()
                                                        .oldeveningData[
                                                            homescreenprovider
                                                                        .dateTime
                                                                        .hour >=
                                                                    21
                                                                ? (datetime.weekday ==
                                                                        7)
                                                                    ? 0
                                                                    : datetime
                                                                        .weekday
                                                                : datetime
                                                                        .weekday -
                                                                    1]
                                                        .toJson());
                                            userprovider.setoldMealtype(
                                                userprovider.user.breakfast,
                                                userprovider.user.lunch,
                                                userprovider.user.dinner);
                                            if (!homescreenprovider.loader) {
                                              if (!context.mounted) return;

                                              Utils.flushbarErrorMessage(
                                                  "Your meal has been opted!",context);
                                            }
                                            if (homescreenprovider.userDataModel
                                                .note.isNotEmpty) {
                                              await homescreenprovider
                                                  .updateNoteKitchenData(
                                                      homescreenprovider
                                                          .userDataModel.note);
                                              //TODO this is jugaad not usefull when kitchen data also exists only usefull when kitchen data is not there mean all mealopt are zero and you add note and mealopt together
                                            }
                                          },
                                          paddingvertical:
                                              Dimensions.paddingSizeSmall,
                                          title: "Save changes",
                                          color: AppColor.bluecolor,
                                          textColor: AppColor.WHITE,
                                          fontWeight: FontWeight.w400,
                                          isloader: homescreenprovider.loader,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            const Gap(5),
                            //pg users profile
                            child!,
                          ],
                        ),
                      );
                    },
                    child: UsersMealOptList(
                      pgNumber: userprovider.user.pgNumber,
                      datetime:
                          context.read<HomeScreenProvider>().dateTime.hour >= 21
                              ? context
                                  .read<HomeScreenProvider>()
                                  .dateTime
                                  .add(const Duration(days: 1))
                              : context.read<HomeScreenProvider>().dateTime,
                      userId: userprovider.user.userId,
                    ),
                  ),

                  const Gap(20),
                  Text(
                      " ${context.read<HomeScreenProvider>().timeRefrence} menu",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      )),
                  const Gap(20),
                  MenuWidget(
                    dateTime: context.read<HomeScreenProvider>().dateTime,
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
                                        datetime: context
                                            .read<HomeScreenProvider>()
                                            .dateTime,
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
                                        userId: userprovider.user.userId,
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
