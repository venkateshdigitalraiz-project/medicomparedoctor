import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/Home/bloc/home_bloc.dart';
import 'package:medicompare/Home/screens/home_screen.dart';
import 'package:medicompare/bottomNavigate/bloc/bottom_nav_bloc.dart';
import 'package:medicompare/bottomNavigate/bloc/bottom_nav_event.dart';
import 'package:medicompare/bottomNavigate/bloc/bottom_nav_state.dart';
import 'package:medicompare/bottomNavigate/screen/BottomNav.dart';
import 'package:medicompare/patients/bloc/patients_bloc.dart';
import 'package:medicompare/patients/bloc/patients_event.dart';
import 'package:medicompare/patients/bloc/patients_repository.dart';
import 'package:medicompare/patients/screens/patients_screen.dart';
import 'package:medicompare/dup_profile/bloc/user_profile_bloc.dart';
import 'package:medicompare/dup_profile/bloc/user_profile_event.dart';
import 'package:medicompare/dup_profile/screen/user_profile_screen.dart';

import 'package:medicompare/schedule/bloc/schedule_bloc.dart';
import 'package:medicompare/schedule/bloc/schedule_event.dart';
import 'package:medicompare/schedule/screens/schedule_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientsRepository = PatientsRepository();

    final pages = [
      BlocProvider(
        create: (_) => HomeBloc()..add(const HomeStarted()),
        child: const HomeScreen(),
      ),

      BlocProvider(
        create: (_) => ScheduleBloc()..add(const LoadSchedule()),
        child: const ScheduleScreen(),
      ),

      BlocProvider(
        create: (_) =>
            PatientsBloc(repository: patientsRepository)
              ..add(const PatientsLoadRequested()),
        child: const PatientsScreen(),
      ),

      BlocProvider(
        create: (_) => UserProfileBloc()..add(const UserProfileStarted()),
        child: const UserProfileScreen(),
      ),
    ];

    return BlocProvider(
      create: (_) => BottomNavBloc(),
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(index: state.currentIndex, children: pages),
            bottomNavigationBar: BottomNav(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<BottomNavBloc>().add(ChangeTab(index));
              },
            ),
          );
        },
      ),
    );
  }
}
