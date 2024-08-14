import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:logger/logger.dart';
import 'package:svg_flutter/svg.dart';

class FileUpload extends StatelessWidget {
  final Uint8List? currentImage;
  final String oldImage;
  final VoidCallback onedit;
  final VoidCallback ondelete;
  final VoidCallback onUpload;
  final String line1;
  final String line2;
  const FileUpload(
      {super.key,
      required this.currentImage,
      required this.oldImage,
      required this.onedit,
      required this.ondelete,
      required this.onUpload,
      required this.line1,
      required this.line2});

  @override
  Widget build(BuildContext context) {
    return (currentImage == null)
        ? ((oldImage.isNotEmpty)
            ? Flexible(
                fit: FlexFit.tight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Image.network(
                        oldImage,
                        height: 110,
                        fit: BoxFit.fill,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                         
                          return Image.asset(
                            "assets/images/stay/noImage.jpg",
                            height: 110,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    child: Image.network(oldImage),
                                  ),
                                );
                              });
                        },
                        child: SizedBox(
                          height: 110,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: onedit,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeDefault,
                                      vertical:
                                          Dimensions.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusLarge)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/stay/edit.svg"),
                                      Gap(5),
                                      Text(
                                        "Edit",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: AppColor.WHITE),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: GestureDetector(
                  onTap: onUpload,
                  child: Container(
                      height: 110,
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeDefault,
                          horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusLarge),
                          color: const Color.fromRGBO(255, 255, 255, 1)),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/images/stay/upload.svg",
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
                          line2.isNotEmpty
                              ? Text(
                                  line2, //TODO: use themefile to set textstyle
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      height: 1.1,
                                      color: AppColor.GREY_COLOR_LIGHT
                                          .withOpacity(0.5)),
                                  textAlign: TextAlign.center,
                                )
                              : Container(),
                        ],
                      )),
                ),
              ))
        : Flexible(
            fit: FlexFit.tight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Image.memory(
                    currentImage!,
                    height: 110,
                    fit: BoxFit.fill,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        "assets/images/stay/noImage.jpg",
                        height: 110,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: SizedBox(
                                child: Image.memory(currentImage!, height: 300,
                                width: 300,fit: BoxFit.fill,),
                              ),
                            );
                          });
                    },
                    child: SizedBox(
                      height: 110,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: ondelete,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault,
                                  vertical: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusLarge)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete,size: 15,color: AppColor.WHITE,),
                                  Gap(5),
                                  Text(
                                    "Delete",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: AppColor.WHITE),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
