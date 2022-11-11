import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'api/room_controller.dart';
import 'firebase_options.dart';
import 'global/colors.dart';
import 'screen/landing_view.dart';
import 'screen/room_view.dart';

final _roomCtr = Get.put(RoomController());

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(RootWidget());
}

class RootWidget extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
        pathPatterns: ['/room/*'],
        check: (context, location) {
          return _roomCtr.getAuthStatus;
        },
        beamToNamed: (_, __) => '/',
      ),
    ],
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) {
          return BeamPage(
            key: UniqueKey(),
            title: "Home",
            child: const LandingView(),
          );
        },
        '/room/:roomId': (context, state, data) {
          final roomId = state.pathParameters["roomId"];
          return BeamPage(
            popToNamed: '/',
            key: UniqueKey(),
            title: "RoomId : $roomId",
            child: const RoomView(),
          );
        },
      },
    ),
  );

  RootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
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
