import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutDialogue extends StatelessWidget {
  const AboutDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 300,
      maxWidth: 300,
      child: AlertDialog(
        title: const Text(
          "Swift Storage",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await launchUrlString(
                "https://www.linkedin.com/in/vedant-barve/",
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.linkedin,
              color: Color(0xff0A66C2),
            ),
          ),
          IconButton(
            onPressed: () async {
              await launchUrlString(
                "https://github.com/vedantbarve/swift_storage",
              );
            },
            icon: const FaIcon(FontAwesomeIcons.github),
          ),
        ],
        content: const ListTile(
          title: Text(
            "Swift storage is a temporary storage solution for day to day tasks like sharing small documents between devices.",
          ),
          subtitle: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 14),
                Text("Features :"),
                Text("1. Upto 50MB storage per room."),
                Text("2. Instaneously joining rooms using QR code."),
                Text(
                    "3. All room data and storage data gets cleared at 24:00 IST.")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
