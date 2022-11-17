import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swift_storage/global/snackbar.dart';
import 'package:uuid/uuid.dart';
import '../api/services/database.dart';
import '../global/const.dart';

final _database = DataBaseController();

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              if (constraints.maxWidth > 768) {
                return Row(
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        color: primary,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/cloud-computing 128px.png",
                              ),
                              const Text(
                                "Swift Storage",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Center(
                        child: SingleChildScrollView(
                          child: FormWidget(),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: double.maxFinite,
                      color: const Color(0xff41436A),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/cloud-computing 128px.png",
                            ),
                            const Text(
                              "Swift Storage",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const FormWidget(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _joinRoomForm = GlobalKey<FormState>();
  final _createRoomForm = GlobalKey<FormState>();
  final _passwordCreateRoom = TextEditingController();
  final _roomIdCreateRoom = TextEditingController();
  final _passwordJoinRoom = TextEditingController();
  final _roomIdJoinRoom = TextEditingController();
  bool isVisibleJoin = true;
  bool isVisibleCreate = true;

  @override
  void initState() {
    super.initState();
    _roomIdCreateRoom.text = const Uuid().v4().substring(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    onJoinRoomPressed() async {
      if (_joinRoomForm.currentState!.validate()) {
        try {
          await _database
              .joinRoom(_roomIdJoinRoom.text, _passwordJoinRoom.text)
              .then(
            (data) async {
              if (data == true) {
                Get.offNamed("/room/${_roomIdJoinRoom.text}");
              } else if (data == "No room found") {
                showSnackBar(context, "No Room found", color: Colors.red);
              } else {
                showSnackBar(
                  context,
                  "Something went wrong",
                  color: Colors.red,
                );
              }
            },
          );
        } catch (err) {
          showSnackBar(context, err.toString());
        }
      }
    }

    onCreateRoomPressed() async {
      if (_createRoomForm.currentState!.validate()) {
        try {
          await _database
              .createRoom(_roomIdCreateRoom.text, _passwordCreateRoom.text)
              .then(
            (value) {
              Get.offNamed("/room/${_roomIdCreateRoom.text}");
            },
          );
        } catch (e) {
          showSnackBar(context, e.toString());
        }
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 48.0,
            vertical: 28,
          ),
          child: Form(
            key: _createRoomForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Create room",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: _roomIdCreateRoom,
                  decoration: const InputDecoration(
                    hintText: "Room ID",
                    labelText: "Room ID",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a value";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordCreateRoom,
                  obscureText: isVisibleCreate,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: (isVisibleCreate)
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() => isVisibleCreate = !isVisibleCreate);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a value";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: onCreateRoomPressed,
                  child: const Text(
                    "Create Room",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 48.0,
            vertical: 28,
          ),
          child: Form(
            key: _joinRoomForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Join room",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                TextFormField(
                  controller: _roomIdJoinRoom,
                  decoration: const InputDecoration(
                    hintText: "Room ID",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a value";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordJoinRoom,
                  obscureText: isVisibleJoin,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: (isVisibleJoin)
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() => isVisibleJoin = !isVisibleJoin);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a value";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: onJoinRoomPressed,
                  child: const Text(
                    "Join Room",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
