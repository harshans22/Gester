
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gester/resources/dimensions.dart';

class TextCommonButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final bool isloader;
  final double paddingvertical;
  final Color borderColor;
  final VoidCallback onTap;
  final double fontsize;
  final FontWeight fontWeight;
  final Color loaderColor;
  final double paddingHorizontal;
  const TextCommonButton(
      {super.key,
      this.fontsize = 14,
      required this.title,
      this.paddingHorizontal=0,
      required this.color,
      required this.textColor,
      this.isloader = false,
      this.paddingvertical = Dimensions.paddingSizeDefault,
      this.borderColor = const Color.fromRGBO(0, 0, 0, 0),
      required this.onTap,
      this.fontWeight = FontWeight.w700,
      this.loaderColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
      // width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: paddingvertical,horizontal: paddingHorizontal),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraOverLarge),
        ),
        alignment: Alignment.center,
        child: isloader
            ? SpinKitWave(
                color: loaderColor,
                size: 20.0,
              )
            : Text(
                title,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: textColor,
                    fontWeight: fontWeight,
                    fontSize: fontsize),
              ),
      ),
    );
  }
}
