import 'package:contacts_app/db/database_helper.dart';
import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/widgets/build_field_widget.dart';
import 'package:flutter/material.dart';

class AddEditContactScreen extends StatefulWidget {
  final Contact? contact;
  const AddEditContactScreen({super.key, this.contact});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper.instance;

  late TextEditingController _nameController;
  late TextEditingController _sureNameController;
  late TextEditingController _phoneController;

  bool get _isEditing => widget.contact != null;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _sureNameController = TextEditingController(
      text: widget.contact?.surname ?? '',
    );
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Contact' : 'Add Contact'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 15,
            children: [
              BuildFieldWidget(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              BuildFieldWidget(
                controller: _sureNameController,
                label: 'Surname',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter surname';
                  }
                  return null;
                },
              ),
              BuildFieldWidget(
                controller: _phoneController,
                label: 'Phone number',
                icon: Icons.phone_android_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter phone';
                  }
                  return null;
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveContact,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(15),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : Text(_isEditing ? 'Save Changes' : 'Add Contact'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final contact = Contact(
      name: _nameController.text.trim(),
      surname: _sureNameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (_isEditing) {
      await _dbHelper.updateContact(contact);
    } else {
      await _dbHelper.insertContact(contact);
    }
    Navigator.pop(context, true);
  }
}
