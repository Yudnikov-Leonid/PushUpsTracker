import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_ups/feature/home/presentation/pages/home_page.dart';
import 'package:push_ups/feature/login/bloc/login_bloc.dart';
import 'package:push_ups/feature/login/bloc/login_event.dart';
import 'package:push_ups/feature/login/bloc/login_state.dart';
import 'package:push_ups/feature/main/main_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = LoginBloc();
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => bloc,
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          if (state is LoginSuccess) {
            return MainPage();
          } else if (state is LoginInitial) {
            return Center(child: GoogleAuthButton(
              onPressed: () {
                bloc.add(LoginLoginEvent());
              },
            ));
          } else if (state is LoginFailed) {
            return Center(
              child: Column(
                children: [
                  Center(child: GoogleAuthButton(
                    onPressed: () {
                      bloc.add(LoginLoginEvent());
                    },
                  )),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  )
                ],
              ),
            );
          } else {
            throw Exception('Unknown state: $state');
          }
        }),
      ),
    );
  }
}
