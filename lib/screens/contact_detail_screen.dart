import 'package:contacts_app/db/database_helper.dart';
import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/screens/add_edit_contact_screen.dart';
import 'package:contacts_app/widgets/info_card_widget.dart';
import 'package:flutter/material.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;
  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final _dbHelper = DatabaseHelper.instance;
  late Contact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              _contact.isFavorite == 1 ? Icons.star : Icons.star_border,
              color: _contact.isFavorite == 1 ? Colors.amber : Colors.blueGrey,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('${_contact.name} ${_contact.surname}'),
              ),
            ),
            InfoCardWidget(
              icon: Icons.phone_android_outlined,
              label: 'Phone number',
              value: _contact.phone,
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _editContact,
                    icon: Icon(Icons.edit_outlined),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(15),
                      ),
                    ),
                    label: Text('Edit'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _deleteContact,
                    icon: Icon(Icons.edit_outlined),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(15),
                      ),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    label: Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditContactScreen(contact: _contact),
      ),
    );
    if (result == true) {
      final updatedList = await _dbHelper.searchcontacts(_contact.phone);
      if (updatedList.isNotEmpty) {
        setState(() {
          _contact = updatedList.first;
        });
      }
    }
  }

  Future<void> _deleteContact() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Contact'),
        content: Text('Are you sure you want delete ${_contact.name} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _dbHelper.deleteContact(_contact.id!);
      Navigator.pop(context, true);
    }
  }

  Future<void> _toggleFavorite() async {
    final newValue = _contact.isFavorite == 1 ? 0 : 1;
    await _dbHelper.toggleFavorite(_contact.id!, newValue);
    setState(() {
      _contact = _contact.copyWith(isFavorite: newValue);
    });
  }
}
