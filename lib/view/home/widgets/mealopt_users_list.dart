import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/utils/utilities.dart';

class UsersMealOptList extends StatelessWidget {
  final String pgNumber;
  final DateTime datetime;
  final String userId;
  const UsersMealOptList(
      {super.key,
      required this.pgNumber,
      required this.datetime,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Kitchen")
              .doc(Utils.getDate(datetime))
              .collection("MealOpt")
              .where("dropname", isEqualTo: pgNumber)
              .where("totalMealOpt", isGreaterThan: 0)
              // .where("userId" ,isEqualTo:userId)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              logger.e("Error: ${snapshot.error}");
              return Center(
                child: Text("An error occurred: ${snapshot.error}"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }
            if (snapshot.data!.docs.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Meal opted by",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColor.GREY.withOpacity(0.5),
                        fontWeight: FontWeight.w700),
                  ),
                  const Gap(2),
                  Row(
                    children: [
                      ...List.generate(
                        snapshot.data!.docs.length,
                        (index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 2),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(snapshot.data!.docs[index]
                                        .data()['photoUrl'] ??
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWwfGUCDwrZZK12xVpCOqngxSpn0BDpq6ewQ&s"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      const Gap(2),
                      ...List.generate(
                        snapshot.data!.docs.length,
                        (index) {
                          if (index > 5) {
                            return Container();
                          }
                          if (index == 0) {
                            return Text(
                                snapshot.data!.docs[index].data()['fname'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color:
                                            AppColor.BLACK.withOpacity(0.8)));
                          } else if (index < snapshot.data!.docs.length - 1) {
                            return Text(
                                ", " +
                                    snapshot.data!.docs[index].data()['fname'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color:
                                            AppColor.BLACK.withOpacity(0.8)));
                          } else {
                            return Text(
                                " & " +
                                    snapshot.data!.docs[index].data()['fname'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color:
                                            AppColor.BLACK.withOpacity(0.8)));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
            return Text("People are opting their meal 🍛",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColor.BLACK.withOpacity(0.8)));
          }),
    );
  }
}

class LeftCenterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //create a custom clipper
    Path path = Path();
    path.moveTo(0, 0);
    // Curve starting from the left top, dipping inward to clip a portion
    path.lineTo(0, size.height / 20);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, 0, size.height - size.height / 20);
    path.lineTo(0, size.height);

    // Close the path along the remaining sides of the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    // Complete the clip
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
