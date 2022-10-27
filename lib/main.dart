import 'package:flutter/material.dart';
import 'package:hoteldise/pages/auth/sign_in_screen.dart';
import 'package:hoteldise/pages/auth/sign_up_screen.dart';
import 'package:hoteldise/pages/hotels/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => AuthService(),
      child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: const Center(
            child: SpinKitThreeInOut(
              color: Colors.yellowAccent,
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
              '/': (context) => const SignInScreen(),
            },
          )),
    );
  }
}
