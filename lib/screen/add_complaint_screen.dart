import 'dart:io';

import 'package:complaints/provider/user_complaint_provider.dart';
import 'package:complaints/widget/image_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddComplaintScreen extends ConsumerStatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  ConsumerState<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends ConsumerState<AddComplaintScreen> {
  final _titlecontroller = TextEditingController();
  File? _selectedimage;
  var _isLoading = false;

  void _saveComplaint() async {
    final user1 = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user1.uid)
        .get();

    final enteredText = _titlecontroller.text;

    if (enteredText.isEmpty || _selectedimage == null) {
      return;
    }

    ref
        .read(userComplaintProvider.notifier)
        .add_complaint(enteredText, _selectedimage!);

    String username = "footballoutlash@gmail.com";
    String password = 'sxydtyrhoqkodupt';
    final smtpServer = gmail(username, password);

    final String name = userData.data()!['username'];

    setState(() {
      _isLoading = true;
    });

    final message = Message()
      ..from = Address(username, name)
      ..recipients.add(const Address('vishakhnair22@gmail.com'))
      ..subject = 'Regarding $enteredText Complaint'
      ..text =
          'Dear Sir,\nI hope this email finds you well.\nI am writing to bring to your attention an issue with the $enteredText in my office. Unfortunately, it has not been functioning properly for the past few days, causing significant discomfort during working hours. I have attached an image of the $enteredText for your reference.. \nThank you for your understanding and cooperation. \nBest regards, \n$name'
      ..attachments = [
        FileAttachment(_selectedimage!)
          ..location = Location.attachment
          ..cid = '<myimg@3.141>'
      ];

    try {
      await send(message, smtpServer);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Complaints"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Complaint Title",
              ),
              controller: _titlecontroller,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 10,
            ),
            ImageInput(
              onPickedImage: (image) {
                _selectedimage = image;
              },
            ),
            if (_isLoading == true) const CircularProgressIndicator(),
            if (_isLoading == false)
              ElevatedButton.icon(
                  onPressed: _saveComplaint,
                  icon: const Icon(Icons.add_circle_rounded),
                  label: const Text("Submit Complaint"))
          ],
        ),
      ),
    );
  }
}
