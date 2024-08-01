import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/firebase_methods/auth_methods.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/view/navigationbar/naviagation.dart';
import 'package:svg_flutter/svg.dart';
import 'package:svg_flutter/svg_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Image.asset(
          "assets/images/sign_in_page/Cover image.png",
          width: double.infinity,
          fit: BoxFit.fill,
         height: MediaQuery.of(context).size.height*0.8,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge,
                vertical: Dimensions.paddingSizeDefault),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                  topRight: Radius.circular(Dimensions.radiusExtraLarge)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(20),
                SvgPicture.asset("assets/images/Gester logo.svg"),
                const Gap(30),
                GestureDetector(
                  onTap: () async {
                    if (kIsWeb) {
                      print("googgle");
                      // Create a new provider
                      await AuthMethods().googleloginweb();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavigationScreen()),
                      );

                      // Or use signInWithRedirect
                      // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
                    } else {
                      await AuthMethods().googleLogin();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavigationScreen()),
                      );
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/google.png",
                          height: 25,
                          width: 25,
                          fit: BoxFit.fill,
                        ),
                        const Gap(10),
                        const Text(
                          "Continue with google",
                          style: TextStyle(
                              color: Color(
                                0xFF1D2036,
                              ),
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "or continue without login",
                    style: TextStyle(
                        color: Color(
                          0xFF1D2036,
                        ),
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const Gap(30),
                const Text(
                  "By continuing you agree to our",
                  style: TextStyle(
                      color: Color(
                        0xFF1D2036,
                      ),
                      fontSize: 13,
                      fontWeight: FontWeight.w300),
                ),
                const Text(
                  "Terms of Service, Privacy Policy and Content Policy",
                  style: TextStyle(
                      color: Color(
                        0xFF1D2036,
                      ),
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                const Gap(10),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _buildBody())));
  }
}
