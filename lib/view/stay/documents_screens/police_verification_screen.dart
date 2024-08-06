import 'package:flutter/material.dart';
import 'package:gester/resources/color.dart';
import 'package:lottie/lottie.dart';

class PoliceVerificationScreen extends StatelessWidget {
  const PoliceVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
           appBar: AppBar(
            title: Text(
              "Police Verification",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          
            backgroundColor: AppColor.WHITE,
            surfaceTintColor: Colors.transparent,
            shadowColor: AppColor.GREY_COLOR_LIGHT.withOpacity(0.3),
            centerTitle: true,
            elevation: 5,
          ),
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No data available",style: Theme.of(context).textTheme.displayMedium,),
              Text("Please try again after sometime",style: Theme.of(context).textTheme.bodyMedium,),
            //  LottieBuilder.asset("assets/images/no internet.json"),
            ],
          )),
        ),
      ),
    );
  }
}