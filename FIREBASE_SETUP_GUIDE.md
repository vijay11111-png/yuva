# Firebase Setup Guide for YUVA App

## 🔥 Firebase Project Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `yuva-app`
4. Enable Google Analytics (optional)
5. Choose analytics account or create new one
6. Click "Create project"

### 2. Add Android App
1. In Firebase Console, click "Android" icon
2. Enter Android package name: `com.example.yuva`
3. Enter app nickname: `YUVA`
4. Click "Register app"
5. Download `google-services.json` and place it in `android/app/`
6. Follow the setup instructions

### 3. Add iOS App (if needed)
1. In Firebase Console, click "iOS" icon
2. Enter iOS bundle ID: `com.example.yuva`
3. Enter app nickname: `YUVA`
4. Click "Register app"
5. Download `GoogleService-Info.plist` and add to iOS project

## 📱 Enable Authentication

### 1. Phone Authentication
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Phone" provider
5. Add test phone numbers if needed
6. Save changes

## 🗄️ Firestore Database Setup

### 1. Create Database
1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (we'll add security rules later)
4. Choose location closest to your users
5. Click "Done"

### 2. Deploy Security Rules
1. Copy the contents of `firestore.rules`
2. In Firebase Console, go to "Firestore Database" → "Rules"
3. Replace the default rules with our custom rules
4. Click "Publish"

### 3. Create Collections
The following collections will be created automatically when users register:

#### `users` Collection
- Document ID: User's Firebase Auth UID
- Fields:
  - `phoneNumber` (string)
  - `fullName` (string)
  - `dateOfBirth` (timestamp)
  - `gender` (string)
  - `location` (string)
  - `college` (string)
  - `course` (string, optional)
  - `currentYear` (string)
  - `interests` (array of strings)
  - `profilePictureUrl` (string, optional)
  - `idCardUrl` (string, optional)
  - `isProfileComplete` (boolean)
  - `createdAt` (timestamp)
  - `updatedAt` (timestamp)

#### `pending_colleges` Collection
- Document ID: Auto-generated
- Fields:
  - `name` (string)
  - `location` (string)
  - `status` (string) - "pending"
  - `createdAt` (timestamp)
  - `createdBy` (string) - User UID

#### `pending_interests` Collection
- Document ID: Auto-generated
- Fields:
  - `name` (string)
  - `category` (string)
  - `status` (string) - "pending"
  - `createdAt` (timestamp)
  - `createdBy` (string) - User UID

## 📁 Firebase Storage Setup

### 1. Create Storage Bucket
1. In Firebase Console, go to "Storage"
2. Click "Get started"
3. Choose "Start in test mode" (we'll add security rules later)
4. Choose location closest to your users
5. Click "Done"

### 2. Deploy Storage Rules
1. Copy the contents of `storage.rules`
2. In Firebase Console, go to "Storage" → "Rules"
3. Replace the default rules with our custom rules
4. Click "Publish"

### 3. Storage Structure
The following folders will be created automatically:

#### `profile_pictures/`
- Files: `{userId}_{timestamp}.jpg`
- Access: User can only access their own profile pictures

#### `id_cards/`
- Files: `{userId}_{timestamp}.{extension}`
- Access: User can only access their own ID cards

## 🔧 Admin Functions

### 1. Approve Pending Colleges
1. In Firebase Console, go to "Firestore Database"
2. Navigate to `pending_colleges` collection
3. Review pending submissions
4. To approve:
   - Copy the college data
   - Create new document in `colleges` collection
   - Delete from `pending_colleges`

### 2. Approve Pending Interests
1. In Firebase Console, go to "Firestore Database"
2. Navigate to `pending_interests` collection
3. Review pending submissions
4. To approve:
   - Copy the interest data
   - Create new document in `interests` collection
   - Delete from `pending_interests`

## 🚀 Deployment Commands

### Using Firebase CLI
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage

# Deploy everything
firebase deploy
```

## 🔒 Security Notes

1. **Test Mode**: Initially use test mode for development
2. **Production**: Switch to production mode with proper rules before launch
3. **Admin Access**: Only you (the developer) should have admin access to approve colleges/interests
4. **User Data**: Users can only access their own data
5. **File Uploads**: Users can only upload to their own folders

## 📊 Monitoring

### 1. Analytics
- Monitor user registration flow
- Track completion rates
- Identify drop-off points

### 2. Performance
- Monitor Firestore read/write operations
- Check Storage usage
- Monitor authentication success rates

### 3. Security
- Review authentication logs
- Monitor failed access attempts
- Check for unusual activity

## 🆘 Troubleshooting

### Common Issues:
1. **Authentication fails**: Check phone number format and Firebase Auth settings
2. **Upload fails**: Verify Storage rules and file size limits
3. **Database errors**: Check Firestore rules and collection structure
4. **App crashes**: Verify `google-services.json` is in correct location

### Support:
- Firebase Documentation: https://firebase.google.com/docs
- FlutterFire Documentation: https://firebase.flutter.dev/
- Firebase Console: https://console.firebase.google.com/ 