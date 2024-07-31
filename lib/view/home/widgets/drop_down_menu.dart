import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';

class DropDownMenuWidget extends StatefulWidget {
  final ValueChanged<String> choosenvalue;
  final String title;
  final String initialvalue;
  final List<String> list;
  const DropDownMenuWidget({
    super.key,
    required this.choosenvalue,
    required this.title,
    required this.list,
    required this.initialvalue,
  });
  @override
  State<DropDownMenuWidget> createState() => _DropDownMenuWidgetState();
}

class _DropDownMenuWidgetState extends State<DropDownMenuWidget> {
  late String _value;

  @override
  void initState() {
    // TODO: implement initState
    _value = widget.initialvalue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeLarge),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppColor.GREY_COLOR_LIGHT.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5)),
            height: 25,
            width: 110,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            child: DropdownButton<String>(
              value: _value,
              icon: Transform.rotate(
                angle: 1.5708,
                child: const Icon(
                  Icons.chevron_right,
                  size: 16,
                )),
              underline: Container(
                height: 0,
              ),
              isExpanded: true,
              style: const TextStyle(color: AppColor.BLACK),
              onChanged: (String? value) {
                setState(() {
                  _value = value!;
                });
                widget.choosenvalue(_value);
              },
              items:
                  widget.list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
