import 'package:complaints/provider/user_complaint_provider.dart';
import 'package:complaints/screen/add_complaint_screen.dart';
import 'package:complaints/screen/complaints_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userComplaints = ref.watch(userComplaintProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaints List"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      floatingActionButton: IconButton.filled(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const AddComplaintScreen()));
        },
        icon: const Icon(Icons.add),
        iconSize: 40,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ComplaintsListScreen(
          complaints: userComplaints,
        ),
      ),
    );
  }
}
