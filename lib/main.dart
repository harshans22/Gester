import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gester/firebase_options.dart';
import 'package:gester/provider/meal_customization_provider.dart';
import 'package:gester/provider/menu_provider.dart';
import 'package:gester/provider/user_documents_provider.dart';
import 'package:gester/provider/user_provider.dart';
import 'package:gester/resources/theme.dart';
import 'package:gester/view/auth/screens/sign_in_screen.dart';
import 'package:gester/provider/home_screen_provider.dart';
import 'package:gester/view/navigationbar/naviagation.dart';
import 'package:gester/view/profile/provider/profile_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkifLogin() {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkifLogin();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => MealCustomizationProvider()),
        ChangeNotifierProvider(create: (_) => UserKYCDocumentsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getAppTheme(),
        title: "Gester",
        home: isLogin ? const NavigationScreen() : const SignInScreen(),
      ),
    );
  }
}
