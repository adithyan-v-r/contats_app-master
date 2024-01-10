import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

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
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(backgroundColor:Colors.green.shade50,
          title: Text(
              style: TextStyle(
                  color: Colors.green.shade900, fontWeight: FontWeight.bold),
              widget.name.toString().toUpperCase())),
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
                          padding: documents[index]['Name'] == widget.name
                              ? const EdgeInsets.all(15)
                              : const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 10, top: 10),
                          margin: const EdgeInsets.all(10),
                          child: documents[index]['Name'] == widget.name
                              ? Text(documents[index]['Message'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(documents[index]['Name'],
                                        style: const TextStyle(
                                            color: Colors.lime,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      documents[index]['Message'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                )));
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green.shade50,
        height: 70,
        child: Row(
          children: [
            Expanded(
                child: TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        hintText: 'Type something...'),
                    controller: messageController)),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                messageController.text == ''
                    ? Vibration.vibrate(duration: 100)
                    : addData();
                messageController.text = '';
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: BorderRadius.circular(30)),
                child: Icon(Icons.send, size: 30, color: Colors.white),
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
