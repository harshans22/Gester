import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:svg_flutter/svg.dart';

import '../../../resources/color.dart';

class MealSubscriptionDataContainer extends StatelessWidget {
  final String image;
  final String title;
  final String name;
  const MealSubscriptionDataContainer(
      {super.key, required this.image, required this.title, required this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: AppColor.WHITE,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
           const Gap(10),
            Row(
              children: [
                SvgPicture.asset(image,height: 20,width: 20,fit: BoxFit.fill,),
                const Gap(5),
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w400,color: AppColor.GREY_COLOR_LIGHT),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
