import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swift_storage/screen/room_view.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'global/const.dart';
import 'screen/landing_view.dart';

final _firebaseAuth = FirebaseAuth.instance;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _firebaseAuth.signInAnonymously();
  FirebaseAuth.instance.setPersistence(Persistence.SESSION);
  runApp(const RootWidget());
}

class RootWidget extends StatelessWidget {
  const RootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          title: "Home",
          page: () => const LandingView(),
        ),
        GetPage(
          name: '/room/:roomId',
          title: "Room ID : ${Get.parameters["roomId"]}",
          page: () => const RoomView(),
        ),
      ],
      theme: ThemeData(
        fontFamily: "Poppins",
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: secondary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(secondary),
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(16),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
