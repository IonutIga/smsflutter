import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smsflutter/models/user.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference budgets = Firestore.instance.collection('budgets');
  // Shared object, used to have a reference to the current logged in user
  static User localUser;
// return any change of the user's status by returning either null or a firebaseUser object
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_mapUser);
  }

  // Get the current logged in user's ID
  String get userID {
    return localUser.uid ?? '';
  }

  // Method used to convert the firebase obj into a local user
  User _mapUser(FirebaseUser user) {
    if (user != null)
      localUser =
          User(uid: user.uid, email: user.email, name: user.displayName);
    return localUser ?? null;
  }

  // Method used to sign the user out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  // Method used to register the user by email and password
  Future<User> registerAsync(String email, String password, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // Add name to the user's profile
      UserUpdateInfo updateName = UserUpdateInfo();
      updateName.displayName = name;
      await user.updateProfile(updateName);
      // Set initial budget
      await budgets.add({'budget': 100000, 'userid': localUser.uid});
      return _mapUser(user);
    } catch (e) {
      print(e.toString());
      // Split the error message to display only the info
      throw Exception(e.toString().split(',')[1]);
    }
  }

  // Method used to login the user by email and password
  Future<User> loginAsync(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _mapUser(user);
    } catch (e) {
      print(e.toString());
      // Split the error message to display only the info
      throw Exception(e.toString().split(',')[1]);
    }
  }
}
