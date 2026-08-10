import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/document/presentation/bloc/documents_bloc.dart';
import 'package:medicompare/features/document/presentation/screens/documents_screen.dart';
import 'package:medicompare/features/home/presentation/bloc/home_bloc.dart';
import 'package:medicompare/features/home/presentation/screens/home_screen.dart';
import 'package:medicompare/features/add_available/presentation/screens/add_availability_screen.dart';
import 'package:medicompare/features/add_available/presentation/bloc/availability_bloc.dart';
import 'package:medicompare/features/appointment_details/presentation/screens/appointment_details_screen.dart';

import 'package:medicompare/features/dashboard/presentation/screens/dashboard_navigation.dart';
import 'package:medicompare/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:medicompare/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:medicompare/features/chartbox/presentation/bloc/chat_bloc.dart';
import 'package:medicompare/features/chartbox/presentation/bloc/chat_event.dart';
import 'package:medicompare/features/chartbox/presentation/screens/chat_screen.dart';
import 'package:medicompare/features/chartbox/data/repositories/chat_repository.dart';
import 'package:medicompare/features/clinic_info/presentation/bloc/clinic_cubit.dart';
import 'package:medicompare/features/clinic_info/presentation/screens/clinic_info_screen.dart';
import 'package:medicompare/features/consultation/presentation/bloc/consultation_bloc.dart';
import 'package:medicompare/features/consultation/presentation/screens/consultation_history_screen.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/features/auth/pin/presentation/bloc/pin_bloc.dart';
import 'package:medicompare/features/auth/pin/presentation/pages/create_pin_screen.dart';
import 'package:medicompare/features/auth/document_verification/presentation/pages/doctor_verification_screen.dart';
import 'package:medicompare/features/auth/document_verification/presentation/bloc/document_verification_bloc.dart';
import 'package:medicompare/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:medicompare/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:medicompare/features/profile/presentation/bloc/user_profile_bloc.dart';
import 'package:medicompare/features/profile/presentation/screens/user_profile_screen.dart';
import 'package:medicompare/features/edit_profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:medicompare/features/edit_profile/presentation/screens/edit_profile_screen.dart';
import 'package:medicompare/features/splash/presentation/pages/splash_screen.dart';
import 'package:medicompare/features/help_support/presentation/bloc/faq_cubit.dart';
import 'package:medicompare/features/help_support/presentation/screens/help_support_screen.dart';
import 'package:medicompare/features/holidays/presentation/bloc/holiday_bloc.dart';
import 'package:medicompare/features/holidays/presentation/screens/holidays_screen.dart';
import 'package:medicompare/features/language/presentation/bloc/language_bloc.dart';
import 'package:medicompare/features/language/presentation/screens/language_screen.dart';
import 'package:medicompare/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:medicompare/features/auth/login/presentation/pages/login_screen.dart';
import 'package:medicompare/features/menubar/presentation/bloc/profile_bloc.dart';
import 'package:medicompare/features/menubar/presentation/screens/profile_screen.dart';
import 'package:medicompare/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:medicompare/features/notification/presentation/screens/notifications_screen.dart';
import 'package:medicompare/features/auth/otp/presentation/pages/verify_otp_screen.dart';
import 'package:medicompare/features/onboarding/presentation/pages/intro1screen.dart';
import 'package:medicompare/features/onboarding/presentation/pages/intro2screen.dart';
import 'package:medicompare/features/onboarding/presentation/pages/intro3screen.dart';
import 'package:medicompare/features/privacy_policy/presentation/bloc/privacy_policy_cubit.dart';
import 'package:medicompare/features/privacy_policy/presentation/screens/privacy_policy_screen.dart';
import 'package:medicompare/features/auth/register/presentation/bloc/doctor_registration_bloc.dart';
import 'package:medicompare/features/auth/register/presentation/pages/register_screen.dart';
import 'package:medicompare/features/report_analytic/presentation/bloc/analytics_cubit.dart';
import 'package:medicompare/features/report_analytic/presentation/screens/reports_analytics_screen.dart';
import 'package:medicompare/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:medicompare/features/schedule/presentation/screens/schedule_screen.dart';
import 'package:medicompare/features/schedule_setting/presentation/bloc/schedule_bloc.dart';
import 'package:medicompare/features/schedule_setting/presentation/screens/schedule_settings_screen.dart';
import 'package:medicompare/features/search/presentation/bloc/search_bloc.dart';
import 'package:medicompare/features/search/presentation/screens/search_screen.dart';
import 'package:medicompare/features/search_appointment/presentation/bloc/appointment_today_search_bloc.dart';
import 'package:medicompare/features/search_appointment/presentation/screens/appointment_today_search_screen.dart';
import 'package:medicompare/features/search_id/presentation/bloc/search_bloc.dart';
import 'package:medicompare/features/search_id/presentation/screens/search_screen.dart';
import 'package:medicompare/features/setting/presentation/bloc/settings_bloc.dart';
import 'package:medicompare/features/setting/presentation/screens/settings_screen.dart';
import 'package:medicompare/features/today_appointment/presentation/bloc/appointment_bloc.dart';
import 'package:medicompare/features/today_appointment/presentation/screens/appointments_screen.dart';
import 'package:medicompare/features/videocall/presentation/bloc/video_call_bloc.dart';
import 'package:medicompare/features/videocall/presentation/screens/video_call_screen.dart';

class AppRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(
          // builder: (_) => const LoginScreen()
          builder: (_) => BlocProvider(
            create: (_) => LoginBloc(),
            child: const LoginScreen(),
          ),
        );

      case RouteNames.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DoctorRegistrationBloc(),
            child: const RegisterScreen(),
          ),
        );

      case RouteNames.otp:
        String phoneNumber = settings.arguments.toString();
        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(phoneNumber: phoneNumber),
        );

      case RouteNames.document_verify:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DocumentVerificationBloc(),
            child: const DoctorVerificationScreen(),
          ),
        );

      case RouteNames.createpin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PinBloc(),
            child: const SetPinScreen(),
          ),
        );

      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => HomeBloc()..add(const HomeStarted()),
            child: const HomeScreen(),
          ),
        );

      case RouteNames.menubar:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileBloc(),
            child: const ProfileScreen(),
          ),
        );

      case RouteNames.todayApartment:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppointmentBloc(),
            child: const AppointmentsScreen(),
          ),
        );

      case RouteNames.schedule:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ScheduleBloc(),
            child: const ScheduleScreen(),
          ),
        );

      case RouteNames.homeBottomNav:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case RouteNames.searchTodayAppointment:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppointmentTodaySearchBloc(),
            child: AppointmentTodaySearchPage(),
          ),
        );

      case RouteNames.todayApartmentdtls:
        String appointmentId = settings.arguments.toString();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppointmentBloc(),
            child: AppointmentDetailsScreen(appointmentId: appointmentId),
          ),
        );

      case RouteNames.notification:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => NotificationBloc(),
            child: NotificationsScreen(),
          ),
        );

      case RouteNames.consultationHistory:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ConsultationBloc(),
            child: ConsultationHistoryScreen(),
          ),
        );

      case RouteNames.calendar:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CalendarBloc(),
            child: CalendarScreen(),
          ),
        );

      case RouteNames.search:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: SearchBloc(),
            child: const SearchScreen(),
          ),
        );

      case RouteNames.searchid:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: SearchIDBloc(repository: InMemorySearchRepository()),
            child: const SearchIDScreen(),
          ),
        );

      case RouteNames.videocall:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => VideoCallBloc(),
            child: VideoCallScreen(),
          ),
        );

      case RouteNames.chartbox:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                ChatBloc(repository: ChatRepository())..add(const LoadChat()),
            child: ChatScreen(),
          ),
        );

      case RouteNames.addavailable:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AvailabilityBloc(),
            child: AddAvailabilityScreen(),
          ),
        );

      case RouteNames.report:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AnalyticsCubit(),
            child: ReportsAnalyticsScreen(),
          ),
        );

      case RouteNames.sechduleSetting:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ScheduleSettingBloc(),
            child: ScheduleSettingsScreen(),
          ),
        );

      case RouteNames.document:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DocumentsBloc(),
            child: DocumentsScreen(),
          ),
        );
      case RouteNames.holidays:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => HolidayBloc(),
            child: HolidaysScreen(),
          ),
        );

      case RouteNames.clinicInfo:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ClinicCubit(),
            child: ClinicInfoScreen(),
          ),
        );

      case RouteNames.editProfile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => EditProfileBloc(),
            child: EditProfileScreen(),
          ),
        );

      case RouteNames.helpSupport:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => FaqCubit(),
            child: HelpSupportScreen(),
          ),
        );

      case RouteNames.privacyPolicy:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PrivacyPolicyCubit(),
            child: PrivacyPolicyScreen(),
          ),
        );

      case RouteNames.language:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LanguageBloc(),
            child: LanguageScreen(),
          ),
        );

      case RouteNames.setting:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SettingsBloc(),
            child: SettingsScreen(),
          ),
        );

      case RouteNames.patients:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => UserProfileBloc(),
            child: const UserProfileScreen(),
          ),
        );
      case RouteNames.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => SplashScreen(
            onFinished: () {
              context.read<OnboardingBloc>().add(const CheckOnboardingStatus());
            },
          ),
        );

      // ----------------------------------------------------------------
      // Intro 1
      // ----------------------------------------------------------------
      case RouteNames.intro1:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => Intro1Screen(
            onNext: () => Navigator.of(context).pushNamed(RouteNames.intro2),
            onSkip: () => _completeOnboarding(context),
            onBack: () {},
          ),
        );

      // ----------------------------------------------------------------
      // Intro 2
      // ----------------------------------------------------------------
      case RouteNames.intro2:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => Intro2Screen(
            onNext: () => Navigator.of(context).pushNamed(RouteNames.intro3),
            onSkip: () => _completeOnboarding(context),
            onBack: () => Navigator.of(context).pop(),
          ),
        );

      // ----------------------------------------------------------------
      // Intro 3 — finish action is the same as skip: save + go to calendar.
      // ----------------------------------------------------------------
      case RouteNames.intro3:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => Intro3Screen(
            onFinish: () => _completeOnboarding(context),
            onSkip: () => _completeOnboarding(context),
            onBack: () => Navigator.of(context).pop(),
          ),
        );

      // ----------------------------------------------------------------
      // Calendar (Home)
      // ----------------------------------------------------------------

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route Not Found"))),
        );
    }
  }

  static void _completeOnboarding(BuildContext context) {
    context.read<OnboardingBloc>().add(const CompleteOnboarding());
  }
}
