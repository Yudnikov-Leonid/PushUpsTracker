abstract class LoginState {}

class LoginSuccess extends LoginState {}

class LoginInitial extends LoginState {}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed(this.message);
}