import 'package:academy/chat/UserMessagingScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatScreen extends StatefulWidget {
  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  List<ChatUser> _users = [];

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadUsers();
  }

  String _searchQuery = '';

  List<ChatUser> get _filteredUsers {
    return _users.where((user) {
      final displayName = user.displayName.toLowerCase();
      final searchQuery = _searchQuery.toLowerCase();
      return displayName.contains(searchQuery);
    }).toList();
  }

  Future<void> _loadUsers() async {
    final snapshot = await _firestore.collection('users').get();
    print("User data fetched: ${snapshot.docs.length} documents");

    setState(() {
      _users = snapshot.docs
          .where((doc) => doc.id != _currentUser!.uid)
          .map((doc) => ChatUser.fromSnapshot(doc))
          .toList();
    });
    print("Users loaded: ${_users.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
                ),
              hintText: 'Find Your Class Mate',
              suffixIcon: const Icon(Icons.search)
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredUsers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_filteredUsers[index].displayName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserMessagingScreen(
                        currentUser: _currentUser!,
                        otherUser: _filteredUsers[index],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChatUser {
  final String uid;
  final String displayName;

  ChatUser({required this.uid, required this.displayName});

  factory ChatUser.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final displayName = data['firstName'] as String? ?? 'Unknown'; // Provide a default value if null
    return ChatUser(uid: snapshot.id, displayName: displayName);
  }
}



