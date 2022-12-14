import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hoteldise/models/hotel.dart';
import 'package:hoteldise/models/room_type.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:hoteldise/themes/constants.dart';
import 'package:hoteldise/widgets/text_widget.dart';

class BookRoom extends StatefulWidget {
  const BookRoom({
    Key? key,
    required this.hotel,
    required this.auth,
  }) : super(key: key);

  final Hotel hotel;
  final AuthBase auth;

  @override
  State<BookRoom> createState() => _BookRoomState();
}

class _BookRoomState extends State<BookRoom> {
  final TextEditingController nameInput = TextEditingController();
  final TextEditingController surnameInput = TextEditingController();
  final TextEditingController numberInput = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<RoomType> rooms = [];
  late RoomType selectedRoom;
  Key _refreshKey = UniqueKey();

  @override
  void dispose() {
    super.dispose();
    nameInput.dispose();
    surnameInput.dispose();
    numberInput.dispose();
  }

  @override
  void initState() {
    rooms = widget.hotel.rooms
        .where((room) => room.numOfFreeSuchRooms > 0)
        .toList();
    selectedRoom = rooms[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: nameInput,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        nameInput.text = value!;
      },
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Name',
        hintText: "Enter your name",
      ),
    );
    final surnameField = TextFormField(
      controller: surnameInput,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        surnameInput.text = value!;
      },
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Surname',
        hintText: "Enter your surname",
      ),
    );
    final numberField = TextFormField(
      controller: numberInput,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        numberInput.text = value!;
      },
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Phone number',
        hintText: "Enter your phone number",
      ),
    );

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Book room",
            style: TextStyle(color: secondaryColor, fontSize: 25),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          nameField,
                          const SizedBox(
                            height: 10.0,
                          ),
                          surnameField,
                          const SizedBox(
                            height: 20.0,
                          ),
                          numberField,
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Text('Free rooms in this hotel:',
                              style: TextStyle(
                                  fontSize: 18, color: lightGreyColor)),
                          const SizedBox(
                            height: 20.0,
                          ),
                          roomsScrol(),
                          const SizedBox(
                            height: 120.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor),
                              child: const Text(
                                "Pay",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                if (nameInput.text.isNotEmpty &&
                                    surnameInput.text.isNotEmpty &&
                                    numberInput.text.isNotEmpty) {
                                  _showPopup(nameInput.text, surnameInput.text,
                                      numberInput.text);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Check the correctness of the entered data!",
                                      toastLength: Toast.LENGTH_LONG,
                                      webPosition: "top",
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16.0);
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                ],
              ))
            ],
          ),
        )));
  }

  Widget eachRoom(RoomType room) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRoom = room;
          _refreshKey = UniqueKey();
        });
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: elevatedGrey,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
                width: 3,
                color: selectedRoom == room ? primaryColor : elevatedGrey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.bed_outlined),
            AppText(
              text: 'Place in room: ${room.numOfPlaces}',
              color: lightGreyColor,
              size: 14,
              overflow: TextOverflow.ellipsis,
            ),
            AppText(
              text: 'Cost: ${room.price.price} ${room.price.currency}',
              color: lightGreyColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget roomsScrol() {
    return SizedBox(
      key: _refreshKey,
      height: 78,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.separated(
            shrinkWrap: true,
            itemCount: rooms.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return eachRoom(rooms[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                )),
      ),
    );
  }

  Future _showPopup(String name, String surname, String number) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: SizedBox(
                  width: 350,
                  height: 400,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      title: const Text(
                        "Payment",
                        style: TextStyle(color: primaryColor),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    body: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Data about you: ',
                                    style: TextStyle(
                                        fontSize: 20, color: secondaryColor),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Your name: $name',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Your surname: $surname',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Your phone number: $number',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Your chosen room: ',
                                    style: TextStyle(
                                        fontSize: 20, color: secondaryColor),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Number of places in room: ${selectedRoom.numOfPlaces}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Facilities:',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  getFacilities(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Cost: ${selectedRoom.price.price} ${selectedRoom.price.currency}/per night',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor),
                                      child: Text(
                                        "Pay ${selectedRoom.price.price} ${selectedRoom.price.currency}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg:
                                                "You have successfully paid for the booking",
                                            toastLength: Toast.LENGTH_LONG,
                                            webPosition: "top",
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: 16.0);
                                        Navigator.of(context)
                                          ..pop()
                                          ..pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )));
        });
  }

  getFacilities() {
    if (selectedRoom.facilities != null) {
      for (var i in selectedRoom.facilities!) {
        return Text(
          '  — $i',
          style: const TextStyle(
            fontSize: 16,
          ),
        );
      }
    } else {
      return const Text(
        '  No facilities in this room',
        style: TextStyle(
          fontSize: 16,
        ),
      );
    }
  }
}
