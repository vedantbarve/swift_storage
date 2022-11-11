import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../api/room_controller.dart';
import '../api/services/database.dart';
import '../global/colors.dart';
import '../global/navigation.dart';

final _database = DataBaseController();
final _roomCtr = Get.put(RoomController());

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  void initState() {
    super.initState();
    _roomIdCreateRoom.text = const Uuid().v4().substring(0, 5);
  }

  final _joinRoomForm = GlobalKey<FormState>();
  final _createRoomForm = GlobalKey<FormState>();
  final _passwordCreateRoom = TextEditingController();
  final _roomIdCreateRoom = TextEditingController();
  final _passwordJoinRoom = TextEditingController();
  final _roomIdJoinRoom = TextEditingController();

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
                        child: const Center(
                          child: Text(
                            "Swift Storage",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Center(
                        child: SingleChildScrollView(
                          child: FormWidget(
                            createRoomForm: _createRoomForm,
                            roomIdCreateRoom: _roomIdCreateRoom,
                            passwordCreateRoom: _passwordCreateRoom,
                            joinRoomForm: _joinRoomForm,
                            roomIdJoinRoom: _roomIdJoinRoom,
                            passwordJoinRoom: _passwordJoinRoom,
                          ),
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
                      child: const Center(
                        child: Text(
                          "Swift Storage",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    FormWidget(
                      createRoomForm: _createRoomForm,
                      roomIdCreateRoom: _roomIdCreateRoom,
                      passwordCreateRoom: _passwordCreateRoom,
                      joinRoomForm: _joinRoomForm,
                      roomIdJoinRoom: _roomIdJoinRoom,
                      passwordJoinRoom: _passwordJoinRoom,
                    ),
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

class FormWidget extends StatelessWidget {
  const FormWidget({
    Key? key,
    required GlobalKey<FormState> createRoomForm,
    required TextEditingController roomIdCreateRoom,
    required TextEditingController passwordCreateRoom,
    required GlobalKey<FormState> joinRoomForm,
    required TextEditingController roomIdJoinRoom,
    required TextEditingController passwordJoinRoom,
  })  : _createRoomForm = createRoomForm,
        _roomIdCreateRoom = roomIdCreateRoom,
        _passwordCreateRoom = passwordCreateRoom,
        _joinRoomForm = joinRoomForm,
        _roomIdJoinRoom = roomIdJoinRoom,
        _passwordJoinRoom = passwordJoinRoom,
        super(key: key);

  final GlobalKey<FormState> _createRoomForm;
  final TextEditingController _roomIdCreateRoom;
  final TextEditingController _passwordCreateRoom;
  final GlobalKey<FormState> _joinRoomForm;
  final TextEditingController _roomIdJoinRoom;
  final TextEditingController _passwordJoinRoom;

  @override
  Widget build(BuildContext context) {
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
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a value";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                Hero(
                  tag: _roomIdCreateRoom.text,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_createRoomForm.currentState!.validate()) {
                        try {
                          await _database
                              .createRoom(
                            _roomIdCreateRoom.text,
                            _passwordCreateRoom.text,
                          )
                              .then((value) {
                            _roomCtr.setRoomId(_roomIdCreateRoom.text);
                            _roomCtr.setAuthStatus(true);
                            pushReplacement(context, _roomIdCreateRoom.text);
                          });
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }
                    },
                    child: const Text(
                      "Create Room",
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
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
                  decoration: const InputDecoration(
                    hintText: "Password",
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
                  onPressed: () async {
                    if (_joinRoomForm.currentState!.validate()) {
                      await _database
                          .authenticate(
                        _roomIdJoinRoom.text,
                        _passwordJoinRoom.text,
                      )
                          .then(
                        (data) {
                          if (data == true) {
                            _roomCtr.setRoomId(_roomIdJoinRoom.text);
                            _roomCtr.setAuthStatus(true);
                            pushReplacement(context, _roomIdJoinRoom.text);
                          } else if (data == "No room found") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No Room found"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Something went wrong"),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
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
