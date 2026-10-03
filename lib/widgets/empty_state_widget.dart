import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Image.asset('assets/images/empty_contacts.png', width: 200),
          Text(
            'You have no contacts yet',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          Text(
            'Press on + button to add contacts ',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
