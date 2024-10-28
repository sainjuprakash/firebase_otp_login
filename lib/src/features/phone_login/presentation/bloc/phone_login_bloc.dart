import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_login/src/features/phone_login/presentation/bloc/phone_login_event.dart';
import 'package:otp_login/src/features/phone_login/presentation/bloc/phone_login_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoadingState());
      print("Sending OTP to ${event.phoneNumber}");
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            print("OTP Verified Automatically");
            emit(OtpVerifiedState());
          },
          verificationFailed: (FirebaseAuthException e) {
            print("Verification failed: ${e.message}");
            emit(AuthErrorState(e.message!));
          },
          codeSent: (String verificationId, int? resendToken) {
            print("OTP Sent, Verification ID: $verificationId");
            emit(OtpSentState(verificationId));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("Auto-retrieval timeout for $verificationId");
          },
        );
      } catch (e) {
        print("Error sending OTP: $e");
        emit(AuthErrorState(e.toString()));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoadingState());
      print("Verifying OTP...");
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.otpCode,
        );
        await _auth.signInWithCredential(credential);
        emit(OtpVerifiedState());
        print("OTP Verified Successfully");
      } catch (e) {
        print("Error verifying OTP: $e");
        emit(AuthErrorState("Invalid OTP"));
      }
    });
  }
}
