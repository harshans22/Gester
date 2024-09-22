import 'package:flutter/material.dart';

class CarouselImageSlider extends StatelessWidget {
  final String image;
  const CarouselImageSlider({super.key,required this.image});

  @override
  Widget build(BuildContext context) {

  
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image:  DecorationImage(
          image: NetworkImage(
             image ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
