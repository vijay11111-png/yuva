import 'package:flutter/material.dart'; // Core Flutter package for UI components
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'login_screen.dart'; // Corrected import path (same directory)

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key}); // Constructor for WelcomeScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, // Gradient starts from the top-left corner
            end: Alignment.bottomRight, // Gradient ends at the bottom-right corner
            colors: [
              Color(0xFF370F60), // Vibrant purple color for the top-left
              Color(0xFF370F60), // Lighter purple color for the bottom-right
            ],
          ),
        ), // Gradient background for a dynamic look
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers children vertically
              children: [
                const Spacer(flex: 13), // Adds flexible spacing at the top (adjusts dynamically)
                Image.asset(
                  'assets/welcome_image.png', // Path to the welcome image asset
                  height: 180, // Sets the height of the image for balance
                  alignment: Alignment.center, // Ensures the image is centered
                ),
                const SizedBox(height: 10), // Adds vertical spacing
                Text(
                  'Welcome to YUVA', // Title text
                  style: GoogleFonts.poppins(
                    color: Colors.white, // White text color
                    fontSize: 28, // Larger font size for emphasis
                    fontWeight: FontWeight.w700, // Bold weight for prominence
                    letterSpacing: 0.5, // Slight letter spacing for elegance
                  ),
                ),
                const SizedBox(height: 12), // Adds vertical spacing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40), // Adds horizontal padding
                  child: Text(
                    'Join over 10,000 learners over the world and enjoy online education!', // Subtitle text
                    textAlign: TextAlign.center, // Centers the text horizontally
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.85), // Slightly transparent white text
                      fontSize: 16, // Smaller font size for readability
                      fontWeight: FontWeight.w400, // Regular weight for subtlety
                      height: 1.5, // Line height for better readability
                    ),
                  ),
                ),
                const Spacer(flex: 1), // Adds spacing before the button (adjusts dynamically)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // Glassmorphic effect (semi-transparent)
                    borderRadius: BorderRadius.circular(16), // Rounds the corners of the container
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Slight shadow for depth
                        blurRadius: 10, // Blurs the shadow for a softer look
                        offset: const Offset(0, 4), // Offsets the shadow downward
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Transparent to show the container's effect
                      shadowColor: Colors.transparent, // No additional shadow for the button
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40, // Horizontal padding for the button
                        vertical: 16, // Vertical padding for the button
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // Rounds the corners of the button
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-account'); // Navigates to the create account screen
                    },
                    child: Text(
                      'Create an account', // Button text
                      style: GoogleFonts.poppins(
                        color: Colors.black, // White text color
                        fontSize: 18, // Larger font size for emphasis
                        fontWeight: FontWeight.w600, // Semi-bold weight for clarity
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Adds vertical spacing
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // Navigate to the login screen
                  },
                  child: Text(
                    'Already have an account? Log in', // Text for the login option
                    style: GoogleFonts.poppins(
                      color: Colors.white, // White text color
                      fontSize: 14, // Smaller font size for subtlety
                      fontWeight: FontWeight.w500, // Medium weight for balance
                      decoration: TextDecoration.underline, // Underlines the text for style
                      decorationColor: Colors.white.withOpacity(0.7), // Slightly transparent underline
                    ),
                  ),
                ),
                const Spacer(flex: 2), // Adds spacing at the bottom (adjusts dynamically)
              ],
            ),
          ),
        ),
      ),
    );
  }
}