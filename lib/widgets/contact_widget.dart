import 'package:contacts_app/contact_model.dart';
import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  final ContactModel contact;
  const ContactWidget({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(0xff7B7B7B),
        child: Icon(Icons.person, color: Color(0xffFEFEFE), size: 30),
      ),
      title: Text(contact.contactName),
      subtitle: Text(contact.contactNumber),
      trailing: IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Calling ${contact.contactName}')),
          );
        },
        icon: Icon(Icons.call, color: Color(0xff07AE2C), size: 30),
      ),
    );
  }
}
