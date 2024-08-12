import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/widgets/textbutton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:svg_flutter/svg.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static pickImage(ImageSource source) async {
    final ImagePicker imagepicker = ImagePicker();
    XFile? file = await imagepicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
   // print("No Image selected");
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    //focus change
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message, Color color) {
    //similar to snack bar
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: color,
        fontSize: 15,
        timeInSecForIosWeb: 4);
  }

  static String generateUserId(){
    return const Uuid().v1();
  }

  static void flushbarErrorMessage(String message, BuildContext context) {
    //best UI
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        backgroundColor: Colors.red,
        message: message,
        duration: const Duration(seconds: 2),
      )..show(context),
    );
  }

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  //for getting string date from date(DD-MM-YY)
  // static String getStringDate(){
  //   DateTime now = DateTime.now();
  //   String date = "${now.day}-${now.month<10?0+now.month:now.month}-${now.year}";
  //   return date;
  // }
  static String getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  //write a function for getmonth according to month int value
  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  //get datein DD-MM-YYYY format for DateTime
  static String getDate(DateTime dateTime) {
    return "${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.year}";
  }

  static String getTimeinMinSec(DateTime now) {
    //write a string to calculate minute and second in reverrse order like a stopwatch
    String minute =
        (60 - now.minute) < 10 ? "0${(60 - now.minute)}" : "${60 - now.minute}";
    String second =
        (60 - now.second) < 10 ? "0${(60 - now.second)}" : "${60 - now.second}";
    return "$minute:$second";
  }


  static showWithDoubleButton(
      BuildContext context, String title, String content,
      {required VoidCallback onYes}) {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: Dialog(
                      insetPadding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraLarge),
                      backgroundColor: AppColor.WHITE,
                      surfaceTintColor: AppColor.WHITE,
                      child: Container(
                        // margin:const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeExtraLarge),
                        //alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                                "assets/images/homepage/alert icon.svg"),
                            const Gap(10),
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: AppColor.PRIMARY,
                                      fontWeight: FontWeight.w600),
                            ),
                            const Gap(10),
                            Text(
                              content,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: AppColor.GREY_COLOR_LIGHT,
                                      fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            const Gap(10),
                            Row(
                              children: [
                                Expanded(
                                    child: TextCommonButton(
                                  paddingvertical: Dimensions.paddingSizeSmall,
                                  title: "No",
                                  color: Colors.transparent,
                                  textColor: AppColor.PRIMARY,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  borderColor: AppColor.PRIMARY,
                                )),
                                const Gap(5),
                                Expanded(
                                    child: TextCommonButton(
                                  paddingvertical: Dimensions.paddingSizeSmall,
                                  title: "Yes",
                                  color: AppColor.PRIMARY,
                                  textColor: AppColor.WHITE,
                                  onTap: onYes,
                                )),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ));
  }

  //single button pop up
  static showWithSingleButton(BuildContext context, String content,
      {required VoidCallback onTap, required String buttonTitle}) {
    showDialog(
        //  traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
        context: context,
        builder: (context) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraOverLarge),
                  child: Dialog(
                      insetPadding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraLarge),
                      backgroundColor: AppColor.WHITE,
                      surfaceTintColor: AppColor.WHITE,
                      child: Container(
                        // margin:const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeExtraLarge),
                        //alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                                "assets/images/homepage/alert icon.svg"),
                            const Gap(10),
                            Text(
                              content,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: AppColor.GREY_COLOR_LIGHT,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                            ),
                            const Gap(20),
                            SizedBox(
                              width: 120,
                              child: TextCommonButton(
                                paddingvertical: Dimensions.paddingSizeSmall,
                                title: buttonTitle,
                                color: AppColor.PRIMARY,
                                textColor: AppColor.WHITE,
                                onTap: onTap,
                                fontWeight: FontWeight.w300,
                        
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ));
  }


  //popUp with no button
  static showWithNoButton(BuildContext context,{required String title}) {
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
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColor.PRIMARY, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            )));
  }

  //get date functon from firebaseString Date
  static DateTime getDateFromFirebase(String dateString) {
    // Replace the timezone offset to match Dart's expected format
    dateString = dateString.replaceFirstMapped(
      RegExp(r'([+-]\d{2})(\d{2})$'),
      (Match m) => '${m[1]}:${m[2]}',
    );
    // Parse the date string
    DateTime parsedDate = DateTime.parse(dateString);

    return parsedDate;
  }
}
