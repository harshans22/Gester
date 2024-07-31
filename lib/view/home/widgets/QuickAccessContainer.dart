import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:svg_flutter/svg.dart';

class QuickAccessContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String line1;
  final String line2;
  const QuickAccessContainer(
      {super.key, required this.image,required this.onTap, required this.line1, required this.line2});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            margin:
                const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeDefault,
                horizontal: Dimensions.paddingSizeExtraSmall
                ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: const Color.fromRGBO(255, 255, 255, 1)),
            alignment: Alignment.center,
            child: Column(
              children: [
                SvgPicture.asset(
                  image,
                ),
                Gap(10),
                Text(
                  line1,
                  style:const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  line2,
                  style:const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      ),
    );
  }
}
