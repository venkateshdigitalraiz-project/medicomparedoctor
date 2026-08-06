// import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:medicompare/Home/bloc/home_bloc.dart';
// import 'package:medicompare/Home/screens/home_screen.dart';
// import 'package:medicompare/bottomNavigate/bloc/bottom_nav_bloc.dart';
// import 'package:medicompare/bottomNavigate/bloc/bottom_nav_event.dart';
// import 'package:medicompare/bottomNavigate/bloc/bottom_nav_state.dart';
// import 'package:medicompare/bottomNavigate/screen/BottomNav.dart';
// import 'package:medicompare/dup_profile/bloc/user_profile_bloc.dart';
// import 'package:medicompare/dup_profile/bloc/user_profile_event.dart';
// import 'package:medicompare/dup_profile/screen/user_profile_screen.dart';

// import 'package:medicompare/schedule/bloc/schedule_bloc.dart';
// import 'package:medicompare/schedule/bloc/schedule_event.dart';
// import 'package:medicompare/schedule/screens/schedule_screen.dart';

// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final patientsRepository = PatientsRepository();

//     final pages = [
//       BlocProvider(
//         create: (_) => HomeBloc()..add(const HomeStarted()),
//         child: const HomeScreen(),
//       ),

//       BlocProvider(
//         create: (_) => ScheduleBloc()..add(const LoadSchedule()),
//         child: const ScheduleScreen(),
//       ),

//       BlocProvider(
//         create: (_) =>
//             PatientsBloc(repository: patientsRepository)
//               ..add(const PatientsLoadRequested()),
//         child: const PatientsScreen(),
//       ),

//       BlocProvider(
//         create: (_) => UserProfileBloc()..add(const UserProfileStarted()),
//         child: const UserProfileScreen(),
//       ),
//     ];

//     return BlocProvider(
//       create: (_) => BottomNavBloc(),
//       child: BlocBuilder<BottomNavBloc, BottomNavState>(
//         builder: (context, state) {
//           return Scaffold(
//             body: IndexedStack(index: state.currentIndex, children: pages),
//             bottomNavigationBar: BottomNav(
//               currentIndex: state.currentIndex,
//               onTap: (index) {
//                 context.read<BottomNavBloc>().add(ChangeTab(index));
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/home/presentation/bloc/home_bloc.dart';
import 'package:medicompare/features/home/presentation/screens/home_screen.dart';
import 'package:medicompare/features/dashboard/presentation/bloc/bottom_nav_bloc.dart';
import 'package:medicompare/features/dashboard/presentation/bloc/bottom_nav_event.dart';
import 'package:medicompare/features/dashboard/presentation/bloc/bottom_nav_state.dart';
import 'package:medicompare/features/dashboard/presentation/screens/BottomNav.dart';
import 'package:medicompare/features/profile/presentation/bloc/user_profile_bloc.dart';
import 'package:medicompare/features/profile/presentation/bloc/user_profile_event.dart';
import 'package:medicompare/features/profile/presentation/screens/user_profile_screen.dart';
import 'package:medicompare/features/patients/presentation/bloc/patients_bloc.dart';
import 'package:medicompare/features/patients/presentation/bloc/patients_event.dart';
import 'package:medicompare/features/patients/data/repositories/patients_repository_impl.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/features/auth/logout/data/datasources/logout_api_service.dart';
import 'package:medicompare/features/auth/logout/data/repositories/logout_repository_impl.dart';
import 'package:medicompare/features/auth/logout/domain/usecases/logout_usecase.dart';
import 'package:medicompare/features/auth/logout/presentation/bloc/logout_bloc.dart';
import 'package:medicompare/features/auth/logout/presentation/bloc/logout_state.dart';
import 'package:medicompare/features/patients/presentation/screens/patients_screen.dart';
import 'package:medicompare/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:medicompare/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:medicompare/features/schedule/presentation/screens/schedule_screen.dart';
import 'package:medicompare/core/network/global_client.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientsRepository = PatientsRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavBloc()),

        BlocProvider(create: (_) => HomeBloc()..add(const HomeStarted())),

        BlocProvider(create: (_) => ScheduleBloc()..add(const LoadSchedule())),

        BlocProvider(
          create: (_) =>
              PatientsBloc(repository: patientsRepository)
                ..add(const PatientsLoadRequested()),
        ),

        BlocProvider(
          create: (_) => UserProfileBloc()..add(const UserProfileStarted()),
        ),

        BlocProvider(
          create: (_) => LogoutBloc(
            logoutUseCase: LogoutUseCase(
              repository: LogoutRepositoryImpl(
                apiService: LogoutApiServiceImpl(client: AppHttpClient.client),
              ),
            ),
          ),
        ),
      ],
      child: const _MainScreenBody(),
    );
  }
}

class _MainScreenBody extends StatelessWidget {
  const _MainScreenBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(
              child: AppLoader(
                color: const Color(0xFF6D28D9),
                size: 40,
              ),
            ),
          );
        } else if (state is LogoutSuccess) {
          // Dismiss the loading dialog
          Navigator.of(context, rootNavigator: true).pop();
          // Navigate to Login screen and remove all previous routes
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.login,
            (route) => false,
          );
        } else if (state is LogoutFailure) {
          // Dismiss the loading dialog
          Navigator.of(context, rootNavigator: true).pop();
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentIndex,
              children: const [
                HomeScreen(),
                ScheduleScreen(),
                PatientsScreen(),
                UserProfileScreen(),
              ],
            ),
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
