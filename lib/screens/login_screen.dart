import 'package:flutter/material.dart'; // Core Flutter package for UI components
import 'package:google_fonts/google_fonts.dart'; // For custom fonts

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form's state
  String phoneNumber = ''; // Stores the user's phone number input

  // Method to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Navigate to OTP verification screen, passing the phone number
      Navigator.pushNamed(
        context,
        '/otp-verification',
        arguments: {
          'phoneNumber': phoneNumber, // Pass phone number for OTP verification
          'isLogin': true, // Flag to indicate this is a login flow
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF370F60), // Matches WelcomeScreen gradient
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Go back to WelcomeScreen
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF370F60),
              Color(0xFF370F60),
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 20),
                Text(
                  'Enter Your Phone Number',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'We will send an OTP to verify your phone number',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.length < 10) {
                      return 'Phone number must be at least 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[400],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    'Send OTP',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}