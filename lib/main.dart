import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swift_storage/screen/room_view/room_view.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'global/const.dart';
import 'screen/landing_view/landing_view.dart';

final _firebaseAuth = FirebaseAuth.instance;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _firebaseAuth.signInAnonymously();
  await _firebaseAuth.setPersistence(Persistence.LOCAL);
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
            backgroundColor: WidgetStateProperty.all(secondary),
            padding: WidgetStateProperty.all(
              const EdgeInsets.all(16),
            ),
          ),
        ),
      ),
    );
  }
}
