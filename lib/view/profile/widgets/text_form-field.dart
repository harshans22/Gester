
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';

class TextFieldProfile extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final bool? showpassword;
  const TextFieldProfile({
    super.key,
    required this.controller,
    required this.title, this.showpassword=false,
  });

  @override
  State<TextFieldProfile> createState() => _TextFieldProfileState();
}

class _TextFieldProfileState extends State<TextFieldProfile> {
 

  
  @override
  Widget build(BuildContext context) {
    ValueNotifier _obsecurePassword =  
      ValueNotifier<bool>(false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(5),
        ValueListenableBuilder(
          valueListenable: _obsecurePassword,
          builder: (context,value,child) {
            return TextFormField(
              //scrollPadding: EdgeInsets.all(0),
              obscureText: _obsecurePassword.value,
              controller: widget.controller,
              decoration: InputDecoration(
                 suffixIcon:widget.showpassword!? InkWell(
                          onTap: () {
                            _obsecurePassword.value = !_obsecurePassword.value;
                          },
                          child: Icon(value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility)):null,
                  isDense: true,
                  
                  contentPadding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  filled: true,
                  fillColor: AppColor.TextformFeild),
            );
          }
        ),
      ],
    );
  }
}
