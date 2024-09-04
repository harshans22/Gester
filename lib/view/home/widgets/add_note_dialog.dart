import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/home_screen_provider.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/widgets/textbutton.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class AddNote extends StatelessWidget {

  const AddNote({super.key});

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserDataProvider>(context, listen: true);
    final homescreenprovider =
        Provider.of<HomeScreenProvider>(context, listen: true);
    return  GestureDetector(
      onTap: () {
        //to set old value of note in controller if user does not save it
        homescreenprovider.noteController =
            TextEditingController(text: homescreenprovider.userDataModel.note);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall,
                    horizontal: Dimensions.paddingSizeSmall),
                actionsPadding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeDefault,
                    horizontal: Dimensions.paddingSizeDefault),
                insetPadding:
                    const EdgeInsets.all(Dimensions.paddingSizeDefault),
                backgroundColor: AppColor.BG_COLOR.withOpacity(0.9),
                title: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add a note",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColor.PRIMARY)),
                    SvgPicture.asset(
                      "assets/images/homepage/note_icon.svg",
                      color: AppColor.BLACK,
                      height: 15,
                      width: 15,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
                content: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 350,
                    minWidth: MediaQuery.of(context).size.width < 350
                        ? MediaQuery.of(context).size.width
                        : 350,
                  ),
                  child: TextField(
                    maxLines: 10,
                    controller: homescreenprovider.noteController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.WHITE,
                      focusColor: AppColor.WHITE,
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: AppColor.bluecolor.withOpacity(0.4))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: AppColor.bluecolor.withOpacity(0.4))),
                    ),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TextCommonButton(
                            borderColor: AppColor.PRIMARY,
                            fontWeight: FontWeight.w400,
                            paddingvertical: Dimensions.paddingSizeSmall,
                            title: "Discard",
                            color: Colors.transparent,
                            textColor: AppColor.PRIMARY,
                            onTap: () {
                              Navigator.pop(context);
                            }),
                      ),
                      const Gap(10),
                      Expanded(
                        child: TextCommonButton(
                            isloader: homescreenprovider.loader,
                            fontWeight: FontWeight.w400,
                            paddingvertical: Dimensions.paddingSizeSmall,
                            title: "Save",
                            color: AppColor.PRIMARY,
                            textColor: AppColor.WHITE,
                            onTap: () async {
                              await homescreenprovider
                                  .updateNoteUserData(
                                      homescreenprovider.noteController!.text);
                              await homescreenprovider
                                  .updateNoteKitchenData(
                                      homescreenprovider.noteController!.text);
                              homescreenprovider.updateUserNote(
                                  homescreenprovider.noteController!.text);//assign new note after changing old one
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  )
                ],
              );
            });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: AppColor.bluecolor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: AppColor.bluecolor.withOpacity(0.4)),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      userprovider.user.note.isEmpty
                          ? "Add a note"
                          : userprovider.user.note,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.bluecolor,
                          ),
                    ),
                  ),
                  const SizedBox(
                      width:
                          24), // Adds space for the icon to ensure it does not overlap the text
                ],
              ),
              Positioned(
                right: 0, // Positions the icon at the end
                child: SvgPicture.asset(
                  "assets/images/homepage/note_icon.svg",
                  height: 20, // Adjust the height as needed
                  width: 20,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ),
    ); 
  }
}
