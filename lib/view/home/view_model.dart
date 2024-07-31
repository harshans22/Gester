import 'package:flutter/material.dart';

class HomeScreenModel with ChangeNotifier {
  bool _isbreakfast = false;
  bool _islunch = false;
  bool _isdinner = false;
  bool get breakfast =>_isbreakfast;
  bool get lunch =>_islunch;
  bool get dinner =>_isdinner;
  updatebreakfast(bool value){
    _isbreakfast = value;
    notifyListeners();
  }
  updatelunch(bool value){
    _islunch = value;
    notifyListeners();
  }
  updatedinner(bool value){
    _isdinner = value;
    notifyListeners();
  }
}
