import 'package:contacts_app/db/database_helper.dart';
import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/screens/add_edit_contact_screen.dart';
import 'package:contacts_app/screens/contact_detail_screen.dart';
import 'package:contacts_app/widgets/empty_state_widget.dart';
import 'package:contacts_app/widgets/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:contacts_app/widgets/contact_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final _searchController = TextEditingController();

  List<Contact> _contacts = [];

  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _contacts.where((c) => c.isFavorite == 1).toList();
    final others = _contacts.where((c) => c.isFavorite == 0).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(Icons.search),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _isSearching
                ? TextField(
                    controller: _searchController,
                    onChanged: _onSearchChange,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _contacts.isEmpty
                  ? EmptyStateWidget()
                  : ListView(
                      children: [
                        if (favorites.isNotEmpty) ...[
                          SectionTitleWidget(text: 'Favorite'),
                          ...favorites.map(
                            (c) => ContactWidget(
                              contact: c,
                              onTap: () {
                                _goToContactDetail(c);
                              },
                            ),
                          ),
                        ],
                        if (others.isNotEmpty) ...[
                          SectionTitleWidget(text: 'All Contacts'),
                          ...others.map(
                            (c) => ContactWidget(
                              contact: c,
                              onTap: () {
                                _goToContactDetail(c);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddContact,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.person_add_alt_1),
      ),
    );
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    final contacts = await _dbHelper.getAllcontacts();

    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  Future<void> _onSearchChange(String query) async {
    if (query.trim().isEmpty) {
      _loadContacts();
      return;
    }
    final results = await _dbHelper.searchcontacts(query.trim());
    setState(() => _contacts = results);
  }

  Future<void> _goToAddContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditContactScreen()),
    );
    if (result == true) {
      _loadContacts();
    }
  }

  Future<void> _goToContactDetail(Contact contact) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailScreen(contact: contact),
      ),
    );
    if (result == true) {
      _loadContacts();
    }
  }
}
