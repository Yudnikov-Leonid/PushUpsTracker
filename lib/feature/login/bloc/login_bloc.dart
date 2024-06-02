import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:push_ups/feature/login/bloc/login_event.dart';
import 'package:push_ups/feature/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(FirebaseAuth.instance.currentUser == null
            ? LoginInitial()
            : LoginSuccess()) {
    on<LoginLoginEvent>(_onLoginLoginEvent);
    on<LogOutEvent>(_onLogOutEvent);
  }

  void _onLogOutEvent(LogOutEvent event, Emitter<LoginState> emit) async {
    await FirebaseAuth.instance.signOut();
    emit(LoginInitial());
  }

  void _onLoginLoginEvent(
      LoginLoginEvent event, Emitter<LoginState> emit) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailed(e.toString()));
    }
  }
}
