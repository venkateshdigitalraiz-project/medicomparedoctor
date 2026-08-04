import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/logout_bloc.dart';
import '../bloc/logout_event.dart';

class LogoutHandler {
  static void logout(BuildContext context) {
    context.read<LogoutBloc>().add(const LogoutButtonPressed());
  }
}
