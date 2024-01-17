import 'package:flutter/material.dart';
import 'chatroom.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? Name ;

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.network(
              width: 100,
              'https://cdn-icons-png.flaticon.com/512/9356/9356566.png'),
          const SizedBox(
            height: 10,
          ),
          const Text(
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              'Chat Room'),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Email',
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2)),

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'password',
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue,width: 2)),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 60,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ChatRoom(
                      name:nameController.text
                    );
                  },
                ));
                                },
              child: Text(
                'Enter',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          )
        ],
      ),
    ));
  }
}
