import 'package:flutter/material.dart';

class Container2 extends StatelessWidget {
  const Container2({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
       
        color: Colors.yellow,
        child: Column(
        
          children: [
            Text("harsh"),
          ],
        ),
      ),
    );
  }
}