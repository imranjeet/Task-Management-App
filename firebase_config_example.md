# Firebase Configuration Setup

This file contains instructions for setting up Firebase for the Task Management App.

## Required Firebase Services

1. **Authentication** - Email/Password provider
2. **Firestore Database** - For storing tasks and user data

## Setup Instructions

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: "Task Management App"
4. Follow the setup wizard

### 2. Enable Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" provider
5. Save changes

### 3. Create Firestore Database

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location close to your users
5. Click "Done"

### 4. Set Firestore Security Rules

Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can only access their own tasks
    match /tasks/{taskId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

### 5. Download Configuration Files

#### For Android:
1. In Firebase Console, go to "Project settings"
2. Click "Add app" and select Android
3. Enter package name: `com.whatbytes.taskmanagement`
4. Download `google-services.json`
5. Place it in `android/app/google-services.json`

#### For iOS:
1. In Firebase Console, go to "Project settings"
2. Click "Add app" and select iOS
3. Enter bundle ID: `com.whatbytes.taskmanagement`
4. Download `GoogleService-Info.plist`
5. Place it in `ios/Runner/GoogleService-Info.plist`

### 6. File Structure

After setup, your project should have:

```
task_management_app/
├── android/
│   └── app/
│       └── google-services.json          # Android config
├── ios/
│   └── Runner/
│       └── GoogleService-Info.plist      # iOS config
└── lib/
    └── main.dart
```

## Testing the Setup

1. Run the app: `flutter run`
2. Try to register a new user
3. Check Firebase Console to see if the user was created
4. Try to create a task
5. Check Firestore to see if the task was saved

## Troubleshooting

### Common Issues:

1. **"No Firebase App '[DEFAULT]' has been created"**
   - Make sure `google-services.json` is in the correct location
   - Check that Firebase is properly initialized in `main.dart`

2. **"Permission denied" errors**
   - Check Firestore security rules
   - Make sure authentication is working

3. **Build errors**
   - Run `flutter clean` and `flutter pub get`
   - Check that all Firebase dependencies are installed

## Production Deployment

For production:

1. Update Firestore rules to be more restrictive
2. Enable additional authentication providers if needed
3. Set up proper Firebase project settings
4. Configure Firebase Analytics and Crashlytics
5. Set up proper app signing for release builds

## Security Notes

- Never commit `google-services.json` or `GoogleService-Info.plist` to public repositories
- Use environment variables for sensitive configuration
- Regularly review and update security rules
- Monitor Firebase usage and costs
