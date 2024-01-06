import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  String? name;
  ChatRoom({Key? key, this.name}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String? messages;
  Timestamp? time;
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .orderBy('TimeStamp')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<DocumentSnapshot> documents = snapshot.data!.docs;

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: documents[index]['Name'] == widget.name
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: width * 0.7),
                      decoration: documents[index]['Name'] == widget.name
                          ? const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              color: Colors.green)
                          : const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Colors.blue),
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(documents[index]['Name'],
                              style: const TextStyle(
                                  color: Colors.lime,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            documents[index]['Message'],
                            style: const TextStyle(color: Colors.white),

                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: Row(
          children: [
            Expanded(
                child: TextField(
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        hintText: 'type something...'),
                    controller: messageController)),
            SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                addData();
                messageController.text = '';
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30)),
                child: Icon(Icons.send, size: 30, color: Colors.white60),
              ),
            )
          ],
        ),
      ),
    );
  }

  addData() async {
    setState(() {
      messages = messageController.text.toString();
    });
    var timeStamp = DateTime.timestamp();
    await FirebaseFirestore.instance.collection('messages').add(
        {"Name": widget.name, "TimeStamp": timeStamp, "Message": messages});
  }
}
