// import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
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

import 'package:flutter/services.dart';
import 'package:medicompare/features/call/presentation/bloc/call_bloc.dart';
import 'package:medicompare/features/call/presentation/bloc/call_event.dart';
import 'package:medicompare/features/call/presentation/bloc/call_state.dart';
import 'package:medicompare/features/call/presentation/widgets/call_session_manager.dart';

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
          create:
              (_) =>
                  PatientsBloc(repository: patientsRepository)
                    ..add(const PatientsLoadRequested()),
        ),

        BlocProvider(
          create: (_) => UserProfileBloc()..add(const UserProfileStarted()),
        ),

        BlocProvider(
          create:
              (_) => LogoutBloc(
                logoutUseCase: LogoutUseCase(
                  LogoutRepositoryImpl(
                    apiService: LogoutApiServiceImpl(client: AppHttpClient.dio),
                  ),
                ),
              ),
        ),
      ],
      child: const _MainScreenBody(),
    );
  }
}

class _MainScreenBody extends StatefulWidget {
  const _MainScreenBody();

  @override
  State<_MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<_MainScreenBody> {
  Future<void> _handleBackPress(BuildContext context) async {
    final callBloc = context.read<CallBloc>();
    final callState = callBloc.state;
    final hasCall = callState is CallConnectedState ||
        callState is CallOutgoingState ||
        callState is CallIncomingState ||
        CallSessionManager.isMinimized;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              hasCall ? Icons.phone_in_talk : Icons.exit_to_app_rounded,
              color: const Color(0xFF6D28D9),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              hasCall ? 'Call in Progress' : 'Exit App',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          hasCall
              ? 'You have an ongoing call. Closing the app will end the call. Are you sure you want to end the call and exit?'
              : 'Are you sure you want to exit the app?',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              hasCall ? 'Stay in Call' : 'Cancel',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D28D9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              hasCall ? 'End Call & Exit' : 'Exit',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      if (hasCall) {
        callBloc.add(const EndCallEvent());
        CallSessionManager.dismiss();
      }
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => Center(
                  child: AppLoader(color: const Color(0xFF6D28D9), size: 40),
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
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              if (state.currentIndex != 0) {
                context.read<BottomNavBloc>().add(ChangeTab(0));
                return;
              }

              _handleBackPress(context);
            },
            child: Scaffold(
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
            ),
          );
        },
      ),
    );
  }
}
