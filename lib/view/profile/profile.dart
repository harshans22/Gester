import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gester/main.dart';
import 'package:gester/provider/home_screen_provider.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/app_constants.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/utils/widgets/activebutton.dart';
import 'package:gester/view/home/screens/QuickAcessScreens/menu_customization_screen.dart';
import 'package:gester/view/home/screens/QuickAcessScreens/meal_history_screen.dart';
import 'package:gester/view/meal_subscription/meal_subscription_screen.dart';
import 'package:gester/view/profile/aboutUs.dart';
import 'package:gester/view/profile/profilesetting.dart';
import 'package:gester/view/profile/widgets/Container_with_padding.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataProvider>(context, listen: true).user;
    final dateTime = Provider.of<HomeScreenProvider>(context).dateTime;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile",
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
                vertical: Dimensions.paddingSizeLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileSetting()));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                    child: Row(
                      children: [
                        user.photoUrl.isNotEmpty
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(user.photoUrl),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Icon(
                                  Icons.person,
                                  size: 80,
                                )),
                        const Gap(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (user.fname + user.lname).isEmpty
                                        ? user.username
                                        : (user.fname + user.lname),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                              Text(
                                user.email,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              ActiveButton(
                                  color: Appconstants.subscriptionStatusColor[user.subscription.status]!,
                              title: user.subscription.status,
                                onTap: () {
                                  
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(25),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  ),
                  child: Column(
                    children: [
                      ContainerWithPadding(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MealSubscriptionScreen()));
                          },
                          content: "Your meal subscription",
                          image: "assets/images/profile/meal subscription.svg"),
                      const Divider(
                        color: AppColor.BG_COLOR,
                        height: 1,
                      ),
                      ContainerWithPadding(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MenuCustomizationScreen(
                                          datetime: dateTime,
                                        )));
                          },
                          content: "Meal Customization",
                          image:
                              "assets/images/profile/meal customization.svg"),
                      const Divider(
                        color: AppColor.BG_COLOR,
                        height: 1,
                      ),
                      ContainerWithPadding(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealHistoryScreen(
                                          userId: user.userId,
                                        )));
                          },
                          content: "Meal opt history",
                          image: "assets/images/profile/meal history.svg"),
                    ],
                  ),
                ),
                const Gap(25),
                const Row(
                  children: [
                    Gap(10),
                    Text(
                      "Other information",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
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
                      ContainerWithPadding(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AboutUs()));
                            //Utils.flushbarErrorMessage("login", context);
                          },
                          content: "About us",
                          image: "assets/images/profile/about us.svg"),
                      const Divider(
                        color: AppColor.BG_COLOR,
                        height: 1,
                      ),
                      ContainerWithPadding(
                          onTap: () {
                            //print("called");
                            Utils.showWithDoubleButton(
                                context,
                                "You are about to logout",
                                "Are you sure you want to log out?",
                                onYes: () async {
                              try {
                                if (kIsWeb) {
                                  // Google logout for web
                                  await FirebaseAuth.instance.signOut();
                                } else {
                                  // Google logout for mobile
                                  await GoogleSignIn().signOut();
                                  await FirebaseAuth.instance.signOut();
                                }
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const MyApp()),
                                  (Route<dynamic> route) => false,
                                );
                              } catch (e) {
                                final Logger logger = Logger();
                                logger.e("Sign-out failed: ${e.toString()}");
                              }
                            }); //popUP
                          },
                          content: "Log out",
                          image: "assets/images/profile/logout.svg"),
                    ],
                  ),
                ),
                Expanded(
                    child: Center(
                        child: SvgPicture.asset(
                            "assets/images/gester food stay.svg")))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
