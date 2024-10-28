abstract class AuthState {}

class AuthInitial extends AuthState {}

class OtpSentState extends AuthState {
  final String verificationId;

  OtpSentState(this.verificationId);
}

class OtpVerifiedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState(this.message);
}

class AuthLoadingState extends AuthState {}
