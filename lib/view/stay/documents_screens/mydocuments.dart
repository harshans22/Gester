import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/user_documents_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/utils/widgets/textbutton.dart';
import 'package:gester/view/stay/widgets/file_upload_contain.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MyDocuments extends StatefulWidget {
  final String userId;
  const MyDocuments({super.key, required this.userId});

  @override
  State<MyDocuments> createState() => _MyDocumentsState();
}

class _MyDocumentsState extends State<MyDocuments> {
  var logger = Logger();
  bool isloading = true;
  Future<void> getDocuments() async {
    //get documents from api
    try {
      await Provider.of<UserKYCDocumentsProvider>(context)
          .getKYCDocuments(widget.userId);
    } catch (e) {
      logger.e(e.toString());
    }finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getDocuments();
  }

  Uint8List? _adhaarFront;
  Uint8List? _adhaarBack;
  Uint8List? _workProof;
  Uint8List? _collegeProof;
  Uint8List? _photo;

  //for selecting image
  selectImage(BuildContext context, int imageNumber) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppColor.WHITE,
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Icon(Icons.photo_camera),
                    Gap(10),
                    Text("Take a photo"),
                  ],
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await Utils.pickImage(
                    ImageSource.camera,
                  );
                  switch (imageNumber) {
                    case 1:
                      setState(() {
                        _adhaarFront = file;
                      });
                      break;
                    case 2:
                      setState(() {
                        _adhaarBack = file;
                      });
                      break;
                    case 3:
                      setState(() {
                        _workProof = file;
                      });
                      break;
                    case 4:
                      setState(() {
                        _collegeProof = file;
                      });
                      break;
                    case 5:
                      setState(() {
                        _photo = file;
                      });
                      break;
                    default:
                      return;
                  }
                },
              ),
              const Divider(
                color: AppColor.BG_COLOR,
                height: 1,
                thickness: 2,
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Icon(Icons.photo_library),
                    Gap(10),
                    Text("Choose from gallery"),
                  ],
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await Utils.pickImage(
                    ImageSource.gallery,
                  );
                  switch (imageNumber) {
                    case 1:
                      setState(() {
                        _adhaarFront = file;
                      });
                      break;
                    case 2:
                      setState(() {
                        _adhaarBack = file;
                      });
                      break;
                    case 3:
                      setState(() {
                        _workProof = file;
                      });
                      break;
                    case 4:
                      setState(() {
                        _collegeProof = file;
                      });
                      break;
                    case 5:
                      setState(() {
                        _photo = file;
                      });
                      break;
                    default:
                      return;
                  }
                },
              ),
              const Divider(
                color: AppColor.BG_COLOR,
                height: 1,
                thickness: 2,
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final documents =
        Provider.of<UserKYCDocumentsProvider>(context, listen: true)
            .kycDocuments;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "My Documents",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            backgroundColor: AppColor.WHITE,
            surfaceTintColor: Colors.transparent,
            shadowColor: AppColor.GREY_COLOR_LIGHT.withOpacity(0.3),
            centerTitle: true,
            elevation: 5,
          ),
          body:isloading?const SpinKitFadingCircle(color: AppColor.PRIMARY,) :Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Text("Aadhaar",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700)),
                const Gap(10),
                Row(
                  children: [
                    FileUpload(
                        line1: "Upload Adhaar Front",
                        line2: "",
                        currentImage: _adhaarFront,
                        oldImage: documents!.adhaarFront,
                        onedit: () {
                          selectImage(context, 1);
                        },
                        ondelete: () {
                          setState(() {
                            _adhaarFront = null;
                          });
                        },
                        onUpload: () async {
                          try {
                            await selectImage(context, 1);
                          } catch (e) {
                            logger.e(e.toString());
                          }
                        }),
                    const Gap(5),
                    FileUpload(
                        line1: "Upload Adhaar Back",
                        line2: "",
                        currentImage: _adhaarBack,
                        oldImage: documents.adhaarBack,
                        onedit: () {
                          selectImage(context, 2);
                        },
                        ondelete: () {
                          setState(() {
                            _adhaarBack = null;
                          });
                        },
                        onUpload: () async {
                          try {
                            await selectImage(context, 2);
                          } catch (e) {
                            logger.e(e.toString());
                          }
                        }),
                  ],
                ),
                const Gap(20),
                Text("Proof",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700)),
                const Gap(20),
                Row(
                  children: [
                    FileUpload(
                        line1: "Upload work proof",
                        line2:
                            "Offer letter, internship letter and salary slip",
                        currentImage: _workProof,
                        oldImage: documents.workProof,
                        onedit: () {
                          selectImage(context, 3);
                        },
                        ondelete: () {
                          setState(() {
                            _workProof = null;
                          });
                        },
                        onUpload: () async {
                          try {
                            await selectImage(context, 3);
                          } catch (e) {
                            logger.e(e.toString());
                          }
                        }),
                    const Gap(5),
                    FileUpload(
                        line1: "Upload College proof",
                        line2:
                            "Admission letter, Collge ID or enrollment recipt",
                        currentImage: _collegeProof,
                        oldImage: documents.collegeProof,
                        onedit: () {
                          selectImage(context, 4);
                        },
                        ondelete: () {
                          setState(() {
                            _collegeProof = null;
                          });
                        },
                        onUpload: () async {
                          try {
                            await selectImage(context, 4);
                          } catch (e) {
                            logger.e(e.toString());
                          }
                        }),
                  ],
                ),
                const Gap(20),
                Text("Photo",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700)),
                const Gap(20),
                Row(
                  children: [
                    FileUpload(
                        line1: "Upload passport size photo",
                        line2: "file format should be .jpeg, .jpg and png",
                        currentImage: _photo,
                        oldImage: documents.photo,
                        onedit: () {
                          selectImage(context, 5);
                        },
                        ondelete: () {
                          setState(() {
                            _photo = null;
                          });
                        },
                        onUpload: () async {
                          try {
                            await selectImage(context, 5);
                          } catch (e) {
                            logger.e(e.toString());
                          }
                        }),
                    Flexible(child: Container())
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.GREY_COLOR_LIGHT.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Consumer<UserKYCDocumentsProvider>(
                  builder: (context, value, child) {
                return TextCommonButton(
                  title: "Save & continue",
                  color: AppColor.PRIMARY,
                  textColor: AppColor.WHITE,
                  isloader: value.isLoading,
                  onTap: () async {
                    try {
                      await value.uploadKYCDocuments(_adhaarFront, _adhaarBack,
                          _workProof, _collegeProof, _photo, widget.userId);
                    } catch (e) {
                      logger.e(e.toString());
                    }
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    Utils.showWithNoButton(context,
                        title: "Documents Uploaded Successfully");
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
