import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_auth.currentUser != null) {
      final doc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      setState(() {
        userData = doc.data();
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_auth.currentUser != null && userData != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update(userData!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Name: ${userData!['name'] ?? 'Not set'}'),
          Text('Birth Date: ${userData!['birthDate'] ?? 'Not set'}'),
          Text('Location: ${userData!['location'] ?? 'Not set'}'),
          Text('College: ${userData!['collegeName'] ?? 'Not set'}'),
          Text('Interests: ${userData!['interests']?.join(', ') ?? 'None'}'),
          ElevatedButton(
            onPressed: _saveChanges,
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}