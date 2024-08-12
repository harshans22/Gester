import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/dimensions.dart';
import 'package:gester/view/profile/profile.dart';
import 'package:provider/provider.dart';

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataProvider>(context, listen: true).user;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
              // child:user!.photoUrl.isNotEmpty?NetworkImage(user.photoUrl):Icon(Icons.person) as ;
              child: user.photoUrl.isNotEmpty
                  ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                      child: Image.network(user.photoUrl,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
      return Image.asset("assets/images/profile/dummy profile.webp",height: 60,width: 60,fit: BoxFit.cover,); 
    },),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                      )),
            ),
            const Gap(15),
            Row(
              children: [
                Text(
                  "Hi ${user.fname}",
                  style: const TextStyle(
                      color: Color(
                        0xFF1D2036,
                      ),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
