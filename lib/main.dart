import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hoteldise/pages/auth/sign_in_screen.dart';
import 'package:hoteldise/pages/auth/sign_up_screen.dart';
import 'package:hoteldise/pages/hotels/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:hoteldise/utils/welcome.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../themes/colors.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => AuthService(),
      child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: const Center(
            child: SpinKitThreeInOut(
              color: primaryColor,
              size: 50.0,
            ),
          ),
          child: MaterialApp(
            title: "HotelDise",
            initialRoute: '/',
            routes: {
              '/home': (context) => const HotelsHome(),
              '/signIn': (context) => const SignInScreen(),
              '/signUp': (context) => const SignUpScreen(),
              '/': (context) => const HotelsHome(),
            },
            theme: ThemeData.dark(),
          )),
    );
  }
}
