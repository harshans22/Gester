import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/user_documents_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/view/stay/widgets/file_upload_container.dart';
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

  Future<void> getDocuments() async {
    //get documents from api
    try {
      await Provider.of<UserKYCDocumentsProvider>(context)
          .getKYCDocuments(widget.userId);
    } catch (e) {
      logger.e(e.toString());
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
        Provider.of<UserKYCDocumentsProvider>(context).kycDocuments;

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
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Text("Aadhar",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700)),
                const Gap(10),
                Row(
                  children: [
                    (_adhaarFront == null)
                        ? ((documents!.adhaarFront.isNotEmpty)
                            ? Flexible(
                                fit: FlexFit.tight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  child: Stack(
                                    fit: StackFit.passthrough,
                                    children: [
                                      Image.network(
                                        documents.adhaarFront,
                                        height: 100,
                                        fit: BoxFit.fill,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                              logger.e(exception);
                                          return CircularProgressIndicator();
                                        },
                                      ),
                                      Container(
                                        height: 100,
                                        color: Colors.black.withOpacity(0.4),
                                        child: Center(
                                          child: TextButton(
                                              onPressed: () {
                                                selectImage(context, 1);
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                color: AppColor.WHITE,
                                                size: 35,
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : FileUploadContainer(
                                image: "assets/images/stay/upload.svg",
                                line1: "Upload Aadhaar Front",
                                line2: "",
                                onTap: () async {
                                  try {
                                    await selectImage(context, 1);
                                  } catch (e) {
                                    logger.e(e.toString());
                                  }
                                }))
                        : Flexible(
                            fit: FlexFit.tight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault),
                              child: Stack(
                                fit: StackFit.passthrough,
                                children: [
                                  Image.memory(
                                    _adhaarFront!,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                  Container(
                                    height: 100,
                                    color: Colors.black.withOpacity(0.4),
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _adhaarFront = null;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: AppColor.WHITE,
                                            size: 35,
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    const Gap(5),
                    FileUploadContainer(
                        image: "assets/images/stay/upload.svg",
                        line1: "Upload Aadhaar Back",
                        line2: "",
                        onTap: () {}),
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
                    FileUploadContainer(
                        image: "assets/images/stay/upload.svg",
                        line1: "Upload work proof",
                        line2: "Offer letter, internship letter or salary slip",
                        onTap: () {}),
                    const Gap(5),
                    FileUploadContainer(
                        image: "assets/images/stay/upload.svg",
                        line1: "Upload College proof ",
                        line2:
                            "Admission letter, college ID or enrollement recipt",
                        onTap: () {}),
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
                    FileUploadContainer(
                        image: "assets/images/stay/upload.svg",
                        line1: "Upload passport size photo",
                        line2: "Upload only .jpeg, jpg and png format",
                        onTap: () {}),
                    Flexible(child: Container())
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
