import 'dart:io';

import 'package:complaints/data/complaint.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserComplaintProvider extends StateNotifier<List<Complaint>> {
  UserComplaintProvider() : super(const []);

  void add_complaint(String title, File image) {
    final newComplaint = Complaint(title: title, image: image);
    state = [newComplaint, ...state];
  }
}

final userComplaintProvider =
    StateNotifierProvider<UserComplaintProvider, List<Complaint>>(
  (ref) => UserComplaintProvider(),
);
