# Registration Module

This module handles the user registration process with a 3-step flow for new users who have successfully verified their OTP.

## Structure

```
lib/registration/
├── models/
│   └── user_registration_model.dart      # Data model for registration
├── services/
│   ├── registration_service.dart         # Firebase operations
│   └── location_service.dart             # GPS and geocoding
├── controllers/
│   └── registration_controller.dart      # State management
├── screens/
│   ├── registration_screen.dart          # Main registration flow
│   └── personal_info_screen.dart         # Step 1: Personal info
├── widgets/
│   └── progress_indicator_widget.dart    # Step progress UI
└── registration.dart                     # Module exports
```

## Features

### Step 1: Personal Information ✅
- Full name input with validation
- Date of birth picker (18+ years only)
- Gender selection (Male/Female/Other) with icons
- Location detection with GPS
- Manual location entry (street and city)
- Progress indicator showing all 3 steps

### Step 2: Academic Information (Placeholder)
- College selection
- Course selection  
- Year of study
- Will be implemented in next phase

### Step 3: Interests (Placeholder)
- Interest selection
- Will be implemented in next phase

## Firebase Integration

The registration data is saved to the `users` collection in Firestore with the following structure:

```json
{
  "fullName": "string",
  "dateOfBirth": "ISO8601 string",
  "gender": "M|F|Other",
  "street": "string",
  "city": "string",
  "latitude": "number",
  "longitude": "number",
  "college": "string",
  "course": "string", 
  "yearOfStudy": "number",
  "interests": ["string"],
  "phoneNumber": "string",
  "isProfileComplete": "boolean",
  "createdAt": "ISO8601 string",
  "updatedAt": "ISO8601 string"
}
```

## Location Services

- **GPS Detection**: Automatically detects user's current location
- **Permission Handling**: Requests location permissions appropriately
- **Geocoding**: Converts coordinates to readable addresses
- **Fallback**: Manual entry option if GPS fails

## Navigation Flow

1. User completes OTP verification
2. If new user → Redirected to `/registration`
3. Step 1: Personal Information
4. Step 2: Academic Information (future)
5. Step 3: Interests (future)
6. Complete registration → Redirected to home

## Usage

```dart
// Navigate to registration
Navigator.pushNamed(
  context, 
  '/registration',
  arguments: {'phoneNumber': phoneNumber}
);

// Import registration components
import 'package:yuva/registration/registration.dart';
```

## Dependencies Added

- `geolocator: ^10.1.0` - GPS location services
- `geocoding: ^2.1.1` - Address geocoding
- `permission_handler: ^11.0.1` - Permission management
- `cloud_firestore: ^4.13.0` - Firebase database

## Next Steps

1. Implement Step 2 (Academic Information)
2. Implement Step 3 (Interests)
3. Add form validation and error handling
4. Implement data persistence between steps
5. Add profile completion status tracking 