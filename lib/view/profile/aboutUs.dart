import 'package:flutter/material.dart';
import 'package:gester/resources/color.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:svg_flutter/svg.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
         constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
            appBar: AppBar(
                title: Text(
                  "Weekly menu",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                backgroundColor: AppColor.WHITE,
                surfaceTintColor: Colors.transparent,
                shadowColor: AppColor.GREY_COLOR_LIGHT.withOpacity(0.3),
                centerTitle: true,
                elevation: 5,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraLarge,
                            vertical: Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault)),
                        child: Column(
                          children: [
                            Text('''About Us\n
Welcome to Gester: Food, Accommodation & More, where we redefine the urban living experience by seamlessly integrating premium accommodation services and nutritious tiffin meals into one comprehensive platform.\n
Our Mission\n
At Gester, our mission is to simplify and enhance the everyday lives of urban dwellers by providing reliable, convenient, and high-quality living and dining solutions. We strive to deliver personalized services that cater to the unique needs of each individual, ensuring a comfortable and fulfilling lifestyle.\n
What We Offer\n
- Premium Accommodation: We offer top-notch PG accommodations for both students and young professionals, ensuring a safe, comfortable, and welcoming environment. Our PGs come with all the essential amenities to make your stay pleasant and stress-free.\n
- Nutritious Tiffin Services: Our tiffin service provides delicious, home-style meals tailored to your dietary preferences and nutritional needs. With a fixed staple menu for each day of the week and options for meal customization, we guarantee fresh and healthy meals delivered right to your doorstep.\n
- Integrated Platform: Gester combines accommodation and meal services into one easy-to-use app, providing a seamless experience from booking your stay to managing your meals.\n
Why Choose Gester?\n
- Convenience: Our app allows you to manage both your accommodation and meal plans in one place, making urban living hassle-free.\n
- Quality: We are committed to maintaining high standards in both our living spaces and our food offerings, ensuring you receive the best possible service.\n
- Personalization: Whether it’s your living arrangements or your meals, we offer customized solutions to meet your specific needs.\n
- Sustainability: We take pride in minimizing food wastage through efficient meal planning and communication, contributing to a more sustainable future.\n
Join Us\n
At Gester, we believe in making urban living simpler and more enjoyable. Join us and experience the convenience, quality, and personalization that our platform offers. Whether you’re looking for a comfortable place to stay or nutritious meals to keep you going, Gester is here to serve you.\n
Contact Us\n
For more information or inquiries, please feel free to reach out to us at bookmyh2h@gmail.com or +918882638903.\n
We look forward to welcoming you to the Gester family!\n
''',style: Theme.of(context).textTheme.bodyMedium,),
                          ],
                        ),
                        
                      ),
                       SizedBox(
                    height: 200,
                    child: Center(
                        child: SvgPicture.asset(
                            "assets/images/gester food stay.svg")),
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