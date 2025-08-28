import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshop/features/login_signup/cubit/state.dart';
import 'package:email_otp/email_otp.dart';
import '../../../db/firebase.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(InitState());

  final FirebaseService _firebaseService = FirebaseService();

  // Shared
  bool isObscure = true;
  bool isChecked = false;
  String _email = '';
  String _password = '';
  String _name = '';
  String selectedMethod = "phone";

  // Email OTP
  EmailOTP? emailOtp;
  String? _pendingEmail;
  String? _pendingPassword;
  String? _pendingName;


  // Email
  void updateEmail(String email) {
    _email = email;
    emit(EmailState(email));
  }

  // Name
  void updateName(String name) {
    _name = name;
    emit(NameState(name));
  }

  // Password
  void updatePassword(String password) {
    _password = password;
    emit(PasswordState(password));
  }

  // Eye in login screen
  void togglePasswordVisibility() {
    isObscure = !isObscure;
    emit(ToggleState(isObscure));
  }

  // Login
  Future<void> login() async {
    emit(LoadingState());
    try {
      final user = await _firebaseService.login(
        email: _email,
        password: _password,
      );
      emit(SuccessState());
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }

  // Login with google
  Future<void> loginWithGoogle() async {
    emit(LoadingState());
    try {
      final user = await _firebaseService.signInWithGoogle();
      if (user != null) {
        emit(SuccessState());
        emit(NextPageState());
      } else {
        emit(FailureState("Google sign-in canceled"));
      }
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }

  // Login with apple
  Future<void> loginWithApple() async {
    emit(LoadingState());
    try {
      final user = await _firebaseService.signInWithApple();
      if (user != null) {
        emit(SuccessState());
        emit(NextPageState());
      } else {
        emit(FailureState("Apple sign-in canceled"));
      }
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }

  // Signup - Send OTP
  Future<void> sendOtpForSignup({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(LoadingState());
    emailOtp = EmailOTP();
    emailOtp!.setConfig(
      appEmail: "your@email.com",
      appName: "Snapshop App",
      userEmail: email,
      otpLength: 4,
      otpType: OTPType.digitsOnly,
    );
    bool result = await emailOtp!.sendOTP();
    if (result) {
      _pendingEmail = email;
      _pendingPassword = password;
      _pendingName = name;
      emit(NextPageState()); // Navigate to OTP screen
    } else {
      emit(FailureState("Have problem to send code"));
    }
  }

  // Verify OTP and register in Firebase
  Future<void> verifyOtpAndRegister(String otp) async {
    emit(LoadingState());
    if (emailOtp == null || _pendingEmail == null || _pendingPassword == null || _pendingName == null) {
      emit(FailureState("Temporary data error"));
      return;
    }
    bool isValid = await emailOtp!.verifyOTP(otp: otp);
    if (isValid) {
      try {
        final user = await _firebaseService.signUp(
          email: _pendingEmail!,
          password: _pendingPassword!,
          name: _pendingName!,
        );
        emit(SuccessState()); // Navigate to Home
      } catch (e) {
        emit(FailureState(e.toString()));
      }
    } else {
      emit(FailureState("Invalid OTP"));
    }
  }

  // Terms check box
  void checkBox() {
    isChecked = !isChecked;
    emit(CheckboxState(isChecked));
  }

  // Reset password by email
  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoadingState());

    try {
      await _firebaseService.sendPasswordResetEmail(email);
      emit(ResetPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(RedirectToSignupState());
      } else if (e.code == 'invalid-email') {
        emit(ResetPasswordFailureState("Invalid email address"));
      } else if (e.code == 'empty-email') {
        emit(ResetPasswordFailureState("Please enter your email"));
      } else {
        emit(ResetPasswordFailureState("Error: ${e.message}"));
      }
    } catch (e) {
      emit(ResetPasswordFailureState("Unexpected error: $e"));
    }
  }

  // Error
  void errorMessage() {
    emit(ErrorState());
  }

  // Navigation
  void nextPage() {
    emit(NextPageState());
  }

  void returnPage() {
    emit(ReturnPageState());
  }

  void PasswordPage() {
    emit(PasswordPageState());
  }
}