import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swift_storage/api/services/database.dart';
import 'package:swift_storage/global/const.dart';
import 'room_on_denial.dart';
import 'room_on_error.dart';

import 'room_on_access.dart';

final _database = Get.put(DataBaseController());

class RoomView extends StatelessWidget {
  const RoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return FutureBuilder(
          future: _database.validateUser(),
          builder: (context, AsyncSnapshot<Status> snapshot) {
            if (snapshot.hasError) {
              return const RoomOnError();
            }
            if (snapshot.hasData) {
              final status = snapshot.data!;
              if (status == Status.approved) {
                return const RoomOnAccess();
              } else if (status == Status.denied) {
                return const RoomOnDenial();
              } else if (status == Status.unknown) {
                return const RoomOnError();
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}
