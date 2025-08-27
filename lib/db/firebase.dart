import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? currentUserId;

  // User Id
  String? getCurrentUserId() {
    currentUserId = _auth.currentUser?.uid;
    return currentUserId;
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> newData) async {
    final userId = getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    try {
      await _firestore.collection('users').doc(userId).update(newData);
    } catch (e, stack) {
      debugPrint('Error updating user data for $userId: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  // Signup
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final firebaseUser = userCredential.user!;

      final appUser = AppUser(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: name,
        favorites: [],
        orders: [],
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set(appUser.toJson());

      return appUser;
    } catch (e) {
      rethrow;
    }
  }
  // Google Sign In
  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  // Apple Sign In
  Future<User?> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCredential = await _auth.signInWithCredential(oauthCredential);
    return userCredential.user;
  }

   // Login
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final firebaseUser = userCredential.user!;
    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    return AppUser.fromJson(doc.data()!);
  }

  // Add product to favorites
  Future<void> addFavorite({
    required String userId,
    required Product product,
  }) async {
    if (userId.isEmpty) throw ArgumentError('User ID cannot be empty');

    try {
      final userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'favourite': FieldValue.arrayUnion([product.toJson()]),
      });
    } catch (e, stack) {
      debugPrint('Error adding favorite for user $userId: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  // Remove product from favorites
  Future<void> removeFavorite({
    required String userId,
    required Product product,
  }) async {
    if (userId.isEmpty) throw ArgumentError('User ID cannot be empty');

    try {
      final userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'favourite': FieldValue.arrayRemove([product.toJson()]),
      });
    } catch (e, stack) {
      debugPrint('Error removing favorite for user $userId: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  // Get all favorites as Product list
  Future<List<Product>> getFavorites({
    required String userId,
  }) async {
    if (userId.isEmpty) throw ArgumentError('User ID cannot be empty');

    try {
      final userRef = _firestore.collection('users').doc(userId);
      final snapshot = await userRef.get();

      if (!snapshot.exists) return [];

      final data = snapshot.data();
      if (data == null || !data.containsKey('favourites')) {
        return [];
      }

      final favorites = List<Map<String, dynamic>>.from(data['favorite']);
      return favorites.map((map) => Product.fromJson(map)).toList();
    } catch (e, stack) {
      debugPrint('Error getting favorites for user $userId: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  // Load User data
  Future<AppUser?> getCurrentUserData() async {
    final userId = getCurrentUserId();
    if (userId == null) return null;

    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;

    return AppUser.fromJson(doc.data()!);
  }

  // Reset Password using email link
  Future<void> sendPasswordResetEmail(String email) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-email',
        message: 'Enter email please',
      );
    }

    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: cleanEmail)
        .get();

    if (query.docs.isEmpty) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found with this email',
      );
    }

    // Email exists → Send password reset link
    await _auth.sendPasswordResetEmail(email: cleanEmail);
  }

  // Change password after login
  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently logged in.");
    }

    try {
      await user.updatePassword(newPassword);
      debugPrint("Password updated successfully!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw FirebaseAuthException(
          code: e.code,
          message: "Please re-login to change your password.",
        );
      } else {
        throw e;
      }
    }
  }

  // Get Password
  // Verify current password
  Future<void> verifyCurrentPassword({
    required String email,
    required String currentPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently logged in");

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      debugPrint("Current password verified successfully!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
          code: e.code,
          message: "The current password is incorrect",
        );
      } else {
        throw e;
      }
    }
  }

  // Save new order for current user
  Future<void> saveOrder({
    required List<Product> products,
    required Map<int, int> productQuantities,
  }) async {
    final userId = getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    final now = DateTime.now();
    double totalOrderPrice = 0;

    final productsList = products.map((product) {
      final qty = productQuantities[product.id] ?? 1;
      final totalPrice = product.price * qty;
      totalOrderPrice += totalPrice;

      return {
        "id": product.id,
        "title": product.title,
        "price": product.price,
        "quantity": qty,
        "totalPrice": totalPrice,
      };
    }).toList();

    final orderData = {
      "orderId": DateTime.now().millisecondsSinceEpoch.toString(), // unique ID
      "products": productsList,
      "totalOrderPrice": totalOrderPrice,
      "orderedAt": now.toIso8601String(),
    };

    await _firestore.collection("users").doc(userId).update({
      "orders": FieldValue.arrayUnion([orderData])
    });
  }

  // Get orders
  Future<List<Orders>> getOrders() async {
    final userId = getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    final docSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();

    final data = docSnapshot.data();
    if (data == null || data['orders'] == null) return [];
    final ordersArray = data['orders'] as List<dynamic>;
    final orders = ordersArray.map((orderJson) => Orders.fromJson(orderJson)).toList();
    return orders;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

}
