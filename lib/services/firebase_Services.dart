import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create a new booking request
  Future<void> createBookingRequest({
    required String service,
    required String date,
    required String time,
    required String address,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    await _firestore.collection('requests').add({
      'userId': user.uid,
      'service': service,
      'date': date,
      'time': time,
      'address': address,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Get all available services (e.g., plumbing, handyman, etc.)
  Future<List<Map<String, dynamic>>> getAllServices() async {
    final snapshot = await _firestore.collection('services').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get all bookings for the current user
  Future<List<Map<String, dynamic>>> getMyBookings() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final snapshot = await _firestore
        .collection('requests')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get the current user ID (if logged in)
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Sign out user (optional utility)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
