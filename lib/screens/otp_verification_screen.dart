import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String otp = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _verifyOTP(String verificationId, String name, DateTime? birthDate, String location, String phoneNumber) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushNamed(
        context,
        '/final-step',
        arguments: {
          'name': name,
          'birthDate': birthDate,
          'location': location,
          'phoneNumber': phoneNumber,
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Verified Successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String name = args['name'];
    final DateTime? birthDate = args['birthDate'];
    final String location = args['location'];
    final String phoneNumber = args['phoneNumber'];
    final String verificationId = args['verificationId'];

    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: $name', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                'Birth Date: ${birthDate != null ? "${birthDate.year}-${birthDate.month}-${birthDate.day}" : "Not set"}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Location: $location', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => otp = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'OTP is required';
                  }
                  if (value.length != 6) {
                    return 'OTP must be 6 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[400],
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _verifyOTP(verificationId, name, birthDate, location, phoneNumber);
                  }
                },
                child: Text('Verify OTP', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}