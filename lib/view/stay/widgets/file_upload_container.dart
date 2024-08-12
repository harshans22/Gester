import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:svg_flutter/svg.dart';

class FileUploadContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String line1;
  final String line2;
  const FileUploadContainer(
      {super.key,
      required this.image,
      required this.onTap,
      required this.line1,
      required this.line2});

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
                horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: const Color.fromRGBO(255, 255, 255, 1)),
            alignment: Alignment.center,
            child: Column(
              children: [
                SvgPicture.asset(
                  image,
                ),
                const Gap(10),
                Text(
                  line1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  line2,//TODO: use themefile to set textstyle
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    height: 1.1,
                    color: AppColor.GREY_COLOR_LIGHT.withOpacity(0.5)
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      ),
    );
  }
}
