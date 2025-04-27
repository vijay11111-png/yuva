import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yuva/models/college.dart';
import 'package:yuva/services/college_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class FinalStepScreen extends StatefulWidget {
  const FinalStepScreen({super.key});

  @override
  _FinalStepScreenState createState() => _FinalStepScreenState();
}

class _FinalStepScreenState extends State<FinalStepScreen> {
  final _formKey = GlobalKey<FormState>();
  String collegeName = '';
  List<String> interests = ['Coding', 'Music', 'Sports'];
  List<String> selectedInterests = [];
  String? collegeIdPath;
  final CollegeService _collegeService = CollegeService();
  List<College> collegeSuggestions = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name = '';
  DateTime? birthDate;
  String location = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        name = args['name'] ?? '';
        birthDate = args['birthDate'] as DateTime?;
        location = args['location'] ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _collegeService.fetchColleges();
  }

  void _pickCollegeId() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        collegeIdPath = pickedFile.path;
      });
    }
  }

  void _updateSuggestions(String input) {
    setState(() {
      collegeSuggestions = _collegeService.getSuggestions(input);
    });
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate() && _auth.currentUser != null) {
      String? collegeIdUrl;
      if (collegeIdPath != null) {
        final ref = _storage.ref().child('college_ids/${_auth.currentUser!.uid}.png');
        await ref.putFile(File(collegeIdPath!));
        collegeIdUrl = await ref.getDownloadURL();
      }

      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'name': name,
        'birthDate': birthDate?.toIso8601String(),
        'location': location,
        'collegeName': collegeName,
        'interests': selectedInterests,
        'collegeIdUrl': collegeIdUrl,
      });
      Navigator.pushNamed(context, '/profile'); // Navigate to profile after signup
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign up')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter your college name'),
              onChanged: _updateSuggestions,
            ),
            ...collegeSuggestions.map((college) => ListTile(
              title: Text(college.name ?? 'Unknown College'),
              onTap: () {
                setState(() {
                  collegeName = college.name ?? '';
                  _collegeService.joinCollegeClub(college.id);
                });
              },
            )),
            if (collegeSuggestions.isEmpty && collegeName.isNotEmpty) ...[
              Text('College not found. Admins will be notified.'),
              ElevatedButton(
                onPressed: () => _collegeService.notifyAdmin(collegeName),
                child: Text('Submit'),
              ),
            ],
            ElevatedButton(
              onPressed: _pickCollegeId,
              child: Text('Upload College ID Card Picture'),
            ),
            if (collegeIdPath != null) Text('ID Uploaded'),
            SizedBox(height: 16),
            Wrap(
              children: interests.map((interest) => ChoiceChip(
                label: Text(interest),
                selected: selectedInterests.contains(interest),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedInterests.add(interest);
                    } else {
                      selectedInterests.remove(interest);
                    }
                  });
                },
              )).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[400]),
              onPressed: _submitData,
              child: Text('Let\'s Go'),
            ),
          ],
        ),
      ),
    );
  }
}