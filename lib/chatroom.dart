import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ChatRoom extends StatefulWidget {
  String? name;
  ChatRoom({Key? key, this.name}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final scrollControler =ScrollController();
  String? messages;
  Timestamp? time;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      // appBar: AppBar(backgroundColor:Colors.green.shade50,
      //     title: Text(
      //         style: TextStyle(
      //             color: Colors.green.shade900, fontWeight: FontWeight.bold),
      //         widget.name.toString().toUpperCase())),
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
              documents=documents.reversed.toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: documents.length,
                        reverse: true,
                        controller: scrollController,
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
                                          color: Colors.blue)
                                      : const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          color: Colors.white70),
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
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold)),
                                            Text(
                                              documents[index]['Message'],
                                              style: const TextStyle(
                                                  color: Colors.black, fontSize: 16),
                                            )
                                          ],
                                        )));
                        },
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(radius: 25,child: Icon(CupertinoIcons.plus,color: Colors.white,),backgroundColor: Colors.blue),
            SizedBox(
            width: 10,),
            Expanded(
                            child: SizedBox(
                              height: 55,
                              child: TextField(
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide.none),
                                      hintText: 'type something....',hintStyle: TextStyle(color: Colors.blue)),
                                  controller: messageController),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            messageController.text == ''
                                ? Vibration.vibrate(duration: 100)
                                : addData();
                            scrollController.animateTo(0,duration:const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            messageController.text = '';
                          },
                          child: CircleAvatar(backgroundColor: Colors.blue,radius: 25,
                            child: Icon(Icons.send,color: Colors.white,size: 25),
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              );
            }
          },
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
