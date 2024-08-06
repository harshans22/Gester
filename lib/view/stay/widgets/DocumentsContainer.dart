import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:svg_flutter/svg.dart';

class DocumentsContainer extends StatelessWidget {
  final String image;
  final String line1;
  final String line2;
  final VoidCallback onTap;
  const DocumentsContainer(
      {super.key, required this.image, required this.line1,required this.line2,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap:onTap ,
        child: Container(
            margin:
                const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeDefault,
                horizontal: Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
            alignment: Alignment.center,
            child: Column(
              children: [
                SvgPicture.asset(
                  image,
                ),
                const Gap(5),
                Text(line1,
                    style:const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, height: 1),
                    textAlign: TextAlign.center,),
                Text(line2,
                    style:const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, height: 1),
                    textAlign: TextAlign.center),
              ],
            )),
      ),
    );
  }
}
