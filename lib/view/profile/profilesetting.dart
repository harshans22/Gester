
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/utils/utilities.dart';
import 'package:gester/utils/widgets/textbutton.dart';
import 'package:gester/view/profile/provider/profile_provider.dart';
import 'package:gester/view/profile/widgets/text_form-field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  Uint8List? _file;
  late TextEditingController _firstname;
  late TextEditingController _lastname;
  late TextEditingController _dateofBirth;
  late TextEditingController _phonenumber;
  late TextEditingController _username;
  late TextEditingController _email;
  late TextEditingController _gender;
  late TextEditingController _password;

  ValueNotifier<bool> isChanged = ValueNotifier<bool>(false);

  void _addListeners() {
    _firstname.addListener(_onTextChanged);
    _lastname.addListener(_onTextChanged);
    _dateofBirth.addListener(_onTextChanged);
    _phonenumber.addListener(_onTextChanged);
    _username.addListener(_onTextChanged);
    _email.addListener(_onTextChanged);
    _gender.addListener(_onTextChanged);
    _password.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    isChanged.value = true;
  }

  @override
  void dispose() {
    // Dispose controllers and ValueNotifier
    _firstname.dispose();
    _lastname.dispose();
    _dateofBirth.dispose();
    _phonenumber.dispose();
    _username.dispose();
    _email.dispose();
    _gender.dispose();
    _password.dispose();
    isChanged.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = Provider.of<UserDataProvider>(context, listen: false).user;
    _firstname = TextEditingController(text: user!.fname);
    _gender = TextEditingController(text: user.gender);
    _lastname = TextEditingController(text: user.lname);
    _email = TextEditingController(text: user.email);
    _phonenumber = TextEditingController(text: user.phoneNumber);
    _dateofBirth = TextEditingController(text: user.dateOfbirth);
    _username = TextEditingController(text: user.username);
    _password = TextEditingController(text: user.password);
    _addListeners();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataProvider>(context,listen: false).user;
    
    selectImage(BuildContext context) async {
      return showDialog(
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
                    setState(() {
                      isChanged.value = true;
                      _file = file;
                    });
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
                    setState(() {
                      isChanged.value = true;
                      _file = file;
                    });
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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
          backgroundColor: AppColor.WHITE,
          appBar: AppBar(
            backgroundColor: AppColor.WHITE,
            title: Text(
              "Profile setting",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            elevation: 2,
            surfaceTintColor: Colors.transparent,
            shadowColor: AppColor.GREY_COLOR_LIGHT.withOpacity(0.6),
            centerTitle: true,
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10),
                  Center(
                    child: Stack(
                      children: [
                        user.photoUrl.isNotEmpty?CircleAvatar(
                          backgroundImage: _file == null
                              ? NetworkImage(user.photoUrl)
                              : MemoryImage(_file!) as ImageProvider,
                          radius: 40,
                        ):_file==null?Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: const Icon(Icons.person,size: 80,)):CircleAvatar(
                          backgroundImage: MemoryImage(_file!) as ImageProvider,
                          radius: 40,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              selectImage(context);
                            },
                            child: SvgPicture.asset(
                                "assets/images/profile/camera.svg"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                          child: TextFieldProfile(
                        controller: _firstname,
                        title: "First name",
                      )),
                      const Gap(10),
                      Expanded(
                          child: TextFieldProfile(
                        controller: _lastname,
                        title: "Last name",
                      )),
                    ],
                  ),
                  const Gap(15),
                  Row(
                    children: [
                      Expanded(
                          child: TextFieldProfile(
                        controller: _gender,
                        title: "Gender",
                      )),
                      const Gap(10),
                      Expanded(
                          child: TextFieldProfile(
                        controller: _dateofBirth,
                        title: "Date of birth",
                      )),
                    ],
                  ),
                  const Gap(15),
                  TextFieldProfile(
                    controller: _phonenumber,
                    title: "Phone number",
                  ),
                  const Gap(10),
                  TextFieldProfile(
                    controller: _username,
                    title: "Username",
                  ),
                  const Gap(10),
                  TextFieldProfile(
                    controller: _email,
                    title: "Email",
                  ),
                  const Gap(10),
                  TextFieldProfile(
                    showpassword: true,
                    controller: _password,
                    title: "Password",
                  ),
                  const Gap(40),
                  ValueListenableBuilder<bool>(
                    valueListenable: isChanged,
                    builder: (context, value, child) {
                      return Consumer<ProfileProvider>(
                        builder: (context, profileprovider, child) => 
                         TextCommonButton(
                           //isloader: false,
                           isloader: profileprovider.loading,
                           title: "Save & continue",
                           color: value
                               ? AppColor.PRIMARY
                               : AppColor.GREY.withOpacity(0.2),
                           textColor:  AppColor.WHITE, onTap: () async{ 
                              if (value) {
                            await profileprovider.uploadChangedData(_file,user.userId,user.photoUrl,_firstname.text,_lastname.text,_dateofBirth.text,_phonenumber.text,_username.text,_email.text,_password.text,_gender.text);
                             Provider.of<UserDataProvider>(context, listen: false)
                                 .updateUser();
                           } else {
                             Utils.toastMessage(
                                 "Please make some changes", Colors.red);
                           }
                            } ,
                         )
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
