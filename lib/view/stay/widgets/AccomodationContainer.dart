import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/dimensions.dart';

class AccomodationContainer extends StatelessWidget {
  final String title;
  final String content;
  const AccomodationContainer({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        ),
        alignment: Alignment.center,
        child:  Column(
          children: [
            Text(
              title,
              style:const TextStyle(
                  color: Color(0xFF1D2036),
                  fontSize: 10,
                  fontWeight: FontWeight.w800),
            ),
            const Gap(3),
            Text(
              content,
              style:const TextStyle(color: Color(0xFF1D2036), fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
