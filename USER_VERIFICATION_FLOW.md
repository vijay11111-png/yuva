# User Verification Flow Implementation

## Overview
This implementation provides a phone number verification system that checks if a user is new or existing, and routes them to the appropriate screen after OTP verification.

## Flow Description

### 1. Phone Number Input Screen
- User enters their phone number
- **Optimization**: Before sending OTP, the system checks if the user exists in Firestore
- This pre-check is fast and helps determine the next screen after verification

### 2. OTP Verification Screen
- User enters the 6-digit OTP
- **Fast Routing**: Uses the pre-checked user existence to route immediately after verification
- **Fallback**: If pre-check was not available, performs a database check

### 3. Routing Logic
- **Existing User**: Navigate to Home Screen
- **New User**: Navigate to Registration Screen

## Key Features

### Performance Optimization
- **Pre-check**: User existence is checked before sending OTP
- **Fast Routing**: No additional database calls needed after OTP verification
- **Fallback Mechanism**: Ensures reliability even if pre-check fails

### User Experience
- **Minimal Time**: Fast routing after OTP verification
- **Seamless Flow**: Users are automatically directed to the right screen
- **Error Handling**: Graceful fallback if database checks fail

## Implementation Details

### Files Modified/Created
1. **`lib/services/user_service.dart`** - New service for user database operations
2. **`lib/screens/registration_screen.dart`** - New registration screen for new users
3. **`lib/initial_pages/screens/phone_input_screen.dart`** - Added user existence pre-check
4. **`lib/initial_pages/screens/otp_screen.dart`** - Added fast routing logic
5. **`lib/config/app_routes.dart`** - Added registration route

### Database Structure
```javascript
// Firestore Collection: users
{
  phoneNumber: "+91XXXXXXXXXX",
  name: "User Name",
  email: "user@example.com",
  profileImageUrl: "optional_url",
  createdAt: timestamp,
  updatedAt: timestamp
}
```

## Usage

### For New Users
1. Enter phone number → Pre-check shows user doesn't exist
2. Enter OTP → Fast routing to registration screen
3. Complete registration → Navigate to home screen

### For Existing Users
1. Enter phone number → Pre-check shows user exists
2. Enter OTP → Fast routing to home screen

## Dependencies Added
- `cloud_firestore: ^4.13.0` - For Firestore database operations

## Error Handling
- Network failures during pre-check default to allowing registration
- Database errors are logged and handled gracefully
- Fallback mechanisms ensure the app doesn't break

## Future Enhancements
- Add user profile completion percentage
- Implement profile picture upload
- Add additional user fields as needed
- Cache user data for offline functionality 