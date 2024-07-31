import 'package:flutter/material.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:gester/provider/menu_provider.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/provider/home_screen_provider.dart';
import 'package:gester/view/home/screens/homescreen.dart';
import 'package:gester/view/stay/StayScreen.dart';

import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:svg_flutter/svg_flutter.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavgationScreenState();
}

class _NavgationScreenState extends State<NavigationScreen> {
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    StayScreen()
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    updateProvider();
  }

  updateProvider() async {
    

   await Provider.of<UserDataProvider>(context, listen: false).updateUser();
    await Provider.of<UserDataProvider>(context, listen: false)
        .getStayDetails();
        await Provider.of<UserDataProvider>(context, listen: false)
        .getPGDetails();
    await Provider.of<MenuProvider>(context, listen: false).getMenu();
    await Provider.of<HomeScreenProvider>(context,listen: false).fetchTimeFromServer();
    Provider.of<HomeScreenProvider>(context,listen: false).startLocalClock();
  }

 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
          body: Center(child: _widgetOptions[_selectedIndex]),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 25,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/images/navigation/myfood.svg",
                          color: _selectedIndex == 0
                              ? const Color(0xFF1D2036)
                              : Colors.grey,
                          height: 22,
                        ),
                        Text(
                          "My food",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _selectedIndex == 0
                                      ? const Color(0xFF1D2036)
                                      : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_COLOR_LIGHT.withOpacity(0.2),
                    // border: Border.all(color: AppColor.PRIMARY)
                  ),
                  child: const SizedBox(),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/images/navigation/mystay.svg",
                          color: _selectedIndex == 1
                              ? const Color(0xFF1D2036)
                              : Colors.grey,
                        ),
                        Text("My Stay",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedIndex == 1
                                        ? const Color(0xFF1D2036)
                                        : Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
