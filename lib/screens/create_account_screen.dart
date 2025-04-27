import 'package:flutter/material.dart';
import 'package:location/location.dart' as locationLib;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  DateTime? birthDate;
  String location = '';
  String phoneNumber = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _getLocation() async {
    var locationService = locationLib.Location();
    try {
      var locationData = await locationService.getLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = '';
        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          address += placemark.locality!;
        }
        if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += placemark.administrativeArea!;
        }
        setState(() {
          location = address.isNotEmpty ? address : 'Address not found';
        });
      } else {
        setState(() {
          location = 'Could not determine address';
        });
      }
    } catch (e) {
      setState(() {
        location = 'Could not determine location';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch location: $e')),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepend +91 to the phone number
      String formattedPhoneNumber = '+91$phoneNumber';
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: formattedPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            Navigator.pushNamed(
              context,
              '/final-step',
              arguments: {
                'name': name,
                'birthDate': birthDate,
                'location': location,
                'phoneNumber': formattedPhoneNumber,
              },
            );
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Phone verification failed: ${e.message}')),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.pushNamed(
              context,
              '/otp-verification',
              arguments: {
                'name': name,
                'birthDate': birthDate,
                'location': location,
                'phoneNumber': formattedPhoneNumber,
                'verificationId': verificationId,
              },
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initiating phone verification: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fix the errors in the form')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Account')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => name = value,
              validator: (value) => value!.isEmpty ? 'Name is required' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Birthday',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: birthDate != null
                    ? '${birthDate!.year}-${birthDate!.month}-${birthDate!.day}'
                    : '',
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: birthDate ?? DateTime(1990, 1, 1),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.purple,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: Colors.black,
                        ),
                        dialogBackgroundColor: Colors.white,
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null && picked != birthDate) {
                  setState(() {
                    birthDate = picked;
                  });
                }
              },
              validator: (value) => value!.isEmpty ? 'Birthday is required' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: _getLocation,
                ),
              ),
              controller: TextEditingController(text: location),
              readOnly: false,
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
              validator: (value) => value!.isEmpty ? 'Location is required' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixText: '+91 ',
                hintText: '9876543210',
                helperText: 'Enter your 10-digit phone number',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              onChanged: (value) => phoneNumber = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                  return 'Phone number must be exactly 10 digits';
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
              onPressed: _submitForm,
              child: Text('Next', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}