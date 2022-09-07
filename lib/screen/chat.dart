import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_auth.dart';
import '../firebase/firebase_firestore.dart';
import '../model/info.dart';
import '../util/helper.dart';
import '../widget/message_text.dart';

class ChatScreen extends StatefulWidget {
  var currentUser = FirebaseAuth.instance.currentUser!.email!;

  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with Helper {
  late TextEditingController messageText;

  @override
  void initState() {
    // TODO: implement initState
    messageText = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            const SizedBox(width: 10),
            const Text('MessageMe')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // add here logout function
              unawaited(FBAuthController().logOut());
              Navigator.pushReplacementNamed(context, '/welcome_screen');
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot<Info>>(
                stream: FBFireStore().readMessage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(

                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => MessageText(
                          sender: snapshot.data!.docs[index].data().sender,
                          text: snapshot.data!.docs[index].data().text,
                          isME: widget.currentUser ==
                              snapshot.data!.docs[index].data().sender,
                        ));
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.red,
                        ),
                        SizedBox(height: 10),
                        Text("you don't have any data ..!"),
                      ],
                    );
                  }
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageText,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          hintText: 'Write your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async => await performSend(),
                      child: Text(
                        'send',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> performSend() async {
    if (checkData()) {
      await send();
      messageText.clear();
    }
  }

  bool checkData() {
    if (messageText.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'write the message to sed it ..!! ', error: true);
    return false;
  }

  Future<void> send() async {
    await FBFireStore().createMessage(info: info);
  }

  Info get info {
    Info info = Info();
    info.text = messageText.text;
    info.sender = widget.currentUser;
    info.time = FieldValue.serverTimestamp();
    return info;
  }
}