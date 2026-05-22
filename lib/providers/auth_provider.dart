import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

enum AuthStatus { authenticated, guest, admin, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final AppUser? user;

  AuthState({required this.status, this.user});

  factory AuthState.initial() => AuthState(status: AuthStatus.loading);
}

final authServiceProvider = Provider((ref) => AuthService());

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

class AuthNotifier extends Notifier<AuthState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  AuthState build() {
    _init();
    return AuthState.initial();
  }

  void _init() {
    ref.listen(authStateChangesProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user == null) {
            state = AuthState(status: AuthStatus.unauthenticated);
          } else {
            _fetchUserData(user);
          }
        },
        loading: () => state = AuthState(status: AuthStatus.loading),
        error: (_, __) => state = AuthState(status: AuthStatus.unauthenticated),
      );
    });
  }

  Future<void> _fetchUserData(User user) async {
    state = AuthState(status: AuthStatus.loading);
    final uid = user.uid;
    final email = user.email;

    try {
      // 1. Check if the user exists in the 'admins' collection by EMAIL
      bool isAdmin = false;
      if (email != null) {
        final adminQuery = await _firestore
            .collection('admins')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        isAdmin = adminQuery.docs.isNotEmpty;
      }

      // 2. Fetch profile data from 'users' collection
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        final appUser = AppUser(
          id: uid,
          firstName: data['firstName'] ?? '',
          secondName: data['secondName'] ?? '',
          phone: data['phone'] ?? '',
          email: data['email'] ?? '',
          role: isAdmin ? 'admin' : (data['role'] ?? 'user'),
        );
        state = AuthState(
          status: isAdmin ? AuthStatus.admin : AuthStatus.authenticated,
          user: appUser,
        );
      } else {
        // User has auth but no document in 'users'
        if (isAdmin) {
          state = AuthState(
            status: AuthStatus.admin, 
            user: AppUser(
              id: uid, 
              firstName: 'Admin', 
              secondName: '', 
              phone: '', 
              email: email ?? '', 
              role: 'admin'
            )
          );
        } else {
          state = AuthState(status: AuthStatus.unauthenticated);
        }
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  void logout() {
    ref.read(authServiceProvider).logout();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);


