import 'package:flutter/material.dart';
import 'package:complaints/data/complaint.dart';

class ComplaintsListScreen extends StatelessWidget {
  const ComplaintsListScreen({super.key, required this.complaints});

  final List<Complaint> complaints;

  @override
  Widget build(BuildContext context) {
    if (complaints.isEmpty) {
      return Center(
        child: Text("No Complaints Added",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground)),
      );
    }

    return ListView.builder(
      itemCount: complaints.length,
      itemBuilder: (ctx, index) => ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(complaints[index].image),
        ),
        title: Text(
          complaints[index].title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
