import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/utils/widgets/profile_container.dart';
import 'package:gester/view/stay/documents_screens/kyc%20_agreement_screen.dart';
import 'package:gester/view/stay/documents_screens/mydocuments.dart';
import 'package:gester/view/stay/documents_screens/police_verification_screen.dart';
import 'package:gester/view/stay/widgets/AccomodationContainer.dart';
import 'package:gester/view/stay/widgets/DocumentsContainer.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class StayScreen extends StatelessWidget {
  const StayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stayDetails = Provider.of<UserDataProvider>(context).stayDetails;
 
    final pgdetails = Provider.of<UserDataProvider>(context).pgDetails;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const ProfileContainer(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.network(
                        //   pgdetails.coverPhoto,
                        //   fit: BoxFit.fitWidth,
                        //   width: double.infinity,
                        // ),
                        ClipRRect(
                          borderRadius:const BorderRadius.only(topLeft:Radius.circular(Dimensions.radiusLarge) ,topRight:Radius.circular(Dimensions.radiusLarge) ),
                          child: Image.network(
                            pgdetails.coverPhoto,
                            fit: BoxFit.fitWidth,
                            height: 200,
                           width: double.infinity,
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return const Text('Failed to load image');
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "H2H ${stayDetails.pgNumber}",
                                  style:const TextStyle(
                                      color: Color(0xFF1D2036),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                    ),
                                    Text(
                                      pgdetails.pgAddress,
                                      style: const TextStyle(
                                          color: Color(0xFF1D2036),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                // Row(
                                //   children: [
                                //     const Text("User ID :",
                                //         style: TextStyle(
                                //             color: Color(0xFF1D2036),
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w500)),
                                //     Text(
                                //       userData.email,
                                //       style: const TextStyle(
                                //           color: Color(0xFF1D2036),
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    const Text("Stay ID :",
                                        style: TextStyle(
                                            color: Color(0xFF1D2036),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 1)),
                                    Text(
                                      '${stayDetails.pgNumber}${stayDetails.room}0${stayDetails.bed}',
                                      style: const TextStyle(
                                          color: Color(0xFF1D2036),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                  ],
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  const Gap(20),
                  const Text(
                    "Accomodation Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(10),
                  Row(children: [
                    AccomodationContainer(
                        title: "PG #", content: stayDetails.pgNumber),
                    AccomodationContainer(
                        title: "Room #", content: stayDetails.room),
                    AccomodationContainer(
                        title: "Bed #", content: stayDetails.bed.toString()),
                  ]),
                  const Gap(10),
                  Row(children: [
                    AccomodationContainer(
                        title: "Start Date",
                        content: Utils.getDate(stayDetails.startDate)),
                    AccomodationContainer(
                        title: "Security Deposit",
                        content: '₹${stayDetails.securityDeposit}'),
                    AccomodationContainer(
                        title: "Rent", content: '₹${stayDetails.rent.toString()}',)
                  ]),
                  const Gap(20),
                  const Text(
                    "My Files",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(10),
                   Row(
                    children: [
                       DocumentsContainer(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: ((context) =>const MyDocuments() )));
                        },
                          image: "assets/images/stay/mydocuments.svg",
                          line1: "My",
                          line2: "Documents",),
                      DocumentsContainer(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: ((context) =>const KYCAgreementScreen() )));
                          },
                          image: "assets/images/stay/kyc icon.svg",
                          line1: "View ",
                          line2: "KYC",),
                      DocumentsContainer(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: ((context) =>const PoliceVerificationScreen() )));
                          },
                          image: "assets/images/stay/police icon.svg",
                          line1: "View",
                          line2: "PCC",),
                    ],
                  ),
                  // const Gap(20),
                  // const Text(
                  //   "UseFull information",
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  // const Gap(10),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: Dimensions.paddingSizeSmall),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius:
                  //         BorderRadius.circular(Dimensions.radiusLarge),
                  //   ),
                  //   child: const Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text("  Wifi Password"),
                  //       Divider(
                  //         color: AppColor.BG_COLOR,
                  //         height: 20,
                  //       ),
                  //       Text("  Rule Book"),
                  //       Divider(
                  //         color: AppColor.BG_COLOR,
                  //         thickness: 2,
                  //       ),
                  //       Text("  How to turn water on/off"),
                  //       Divider(
                  //         color: AppColor.BG_COLOR,
                  //         thickness: 2,
                  //       ),
                  //       Text("  How to turn on/off RO water purifier"),
                  //       Divider(
                  //         color: AppColor.BG_COLOR,
                  //         thickness: 2,
                  //       ),
                  //       Text("  How to use washinh machine"),
                  //       Divider(
                  //         color: AppColor.BG_COLOR,
                  //         thickness: 2,
                  //       ),
                  //       Text("  How to use induction cooker"),
                  //       Divider(
                  //         color: AppColor.BG_COLOR,
                  //         thickness: 2,
                  //       ),
                  //       Text("   to use mircowave"),
                  //       Divider(
                  //         color: AppColor.BG_COLOR,
                  //         thickness: 2,
                  //       ),
                  //       Text("  Gyser instruction"),
                  //     ],
                  //   ),
                  // ),
                  const Gap(20),

                  InkWell(
                    onTap: () async {
                      final Uri url = Uri.parse('https://wa.me/918882638903');
                      try{
                        await launchUrl(url);
                      }catch(e){
                        print(e);
                      }
                      
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            Dimensions.radiusExtraOverLarge),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              "assets/images/stay/feedback Icon.svg"),
                          const Gap(10),
                          const Text(
                            "Submit feedback/complaint",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: SvgPicture.asset(
                          "assets/images/gester food stay.svg"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
