import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/view/stay/widgets/file_upload_container.dart';
import 'package:image_picker/image_picker.dart';

class MyDocuments extends StatefulWidget {
  const MyDocuments({super.key});

  @override
  State<MyDocuments> createState() => _MyDocumentsState();
}

class _MyDocumentsState extends State<MyDocuments> {
  Uint8List? _adhaarFront;
  Uint8List? _adhaarBack;
  Uint8List? _workProof;
  Uint8List? _collegeProof;
  Uint8List? _photo;

  @override
  Widget build(BuildContext context) {
    Future<Uint8List?> selectImage(BuildContext context) async {
      Uint8List? selectedPhoto;
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

                    selectedPhoto = file;
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
                    selectedPhoto = file;
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
      return selectedPhoto;
    }

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
                        ? FileUploadContainer(
                            image: "assets/images/stay/upload.svg",
                            line1: "Upload Aadhaar Front",
                            line2: "",
                            onTap: ()async {
                            
                            //   _adhaarFront=  await selectImage(context);
                            // setState(() {
                              
                            // });
                            })
                        : Image.memory(_adhaarFront!),
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
