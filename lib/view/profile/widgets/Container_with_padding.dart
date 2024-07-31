import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:svg_flutter/svg.dart';

class ContainerWithPadding extends StatelessWidget {
  final String content;
  final VoidCallback onTap;
  final String image;
  const ContainerWithPadding({super.key, required this.content, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
       // borderRadius: BorderRadiusDirectional.only(to),
        splashColor: AppColor.GREY_COLOR_LIGHT.withOpacity(0.3),
       // highlightColor: Colors.red.withOpacity(0.1),
        onTap:onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeLarge),
          child: Row(
                          children: [
                            SvgPicture.asset(
                               image),
                            const Gap(5),
                            Expanded(
                                child: Text(
                              content,
                              style: Theme.of(context).textTheme.titleLarge,
                            )),
                           const Icon(Icons.chevron_right)
                          ],
                        ),
        ),
      ),
    );
  }
}