import 'package:contacts_app/models/contact.dart';
import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  final Contact contact;
  final void Function()? onTap;
  const ContactWidget({super.key, required this.contact, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Color(0xff7B7B7B),
          child: Icon(Icons.person, color: Color(0xffFEFEFE), size: 30),
        ),
        title: Text('${contact.name}  ${contact.surname}'),
        subtitle: Text(contact.phone),
        trailing: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Calling ${contact.phone}')));
          },
          icon: Icon(Icons.call, color: Color(0xff07AE2C), size: 30),
        ),
      ),
    );
  }
}
