import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/Document/documents_bloc.dart';
import 'package:medicompare/Document/documents_screen.dart';
import 'package:medicompare/features/home/presentation/bloc/home_bloc.dart';
import 'package:medicompare/features/home/presentation/screens/home_screen.dart';
import 'package:medicompare/add_available/add_availability_screen.dart';
import 'package:medicompare/add_available/bloc/availability_bloc.dart';
import 'package:medicompare/features/appointment_details/presentation/screens/appointment_details_screen.dart';

import 'package:medicompare/bottomNavigate/screen/dashboard_navigation.dart';
import 'package:medicompare/calendar/bloc/calendar_bloc.dart';
import 'package:medicompare/calendar/screens/calendar_screen.dart';
import 'package:medicompare/chartbox/bolc/chat_bloc.dart';
import 'package:medicompare/chartbox/bolc/chat_event.dart';
import 'package:medicompare/chartbox/chat_screen.dart';
import 'package:medicompare/chartbox/repository/chat_repository.dart';
import 'package:medicompare/clinic_info/cubit/clinic_cubit.dart';
import 'package:medicompare/clinic_info/screens/clinic_info_screen.dart';
import 'package:medicompare/consultation/bloc/consultation_bloc.dart';
import 'package:medicompare/consultation/screen/consultation_history_screen.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/features/auth/pin/presentation/bloc/pin_bloc.dart';
import 'package:medicompare/features/auth/pin/presentation/pages/create_pin_screen.dart';
import 'package:medicompare/features/auth/document_verification/presentation/pages/doctor_verification_screen.dart';
import 'package:medicompare/features/auth/document_verification/presentation/bloc/document_verification_bloc.dart';
import 'package:medicompare/profile/bloc/user_profile_bloc.dart';
import 'package:medicompare/profile/screen/user_profile_screen.dart';
import 'package:medicompare/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:medicompare/edit_profile/edit_profile_screen.dart';
import 'package:medicompare/help_support/bloc/faq_cubit.dart';
import 'package:medicompare/help_support/screens/help_support_screen.dart';
import 'package:medicompare/holidays/bloc/holiday_bloc.dart';
import 'package:medicompare/holidays/screens/holidays_screen.dart';
import 'package:medicompare/language/bloc/language_bloc.dart';
import 'package:medicompare/language/language_screen.dart';
import 'package:medicompare/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:medicompare/features/auth/login/presentation/pages/login_screen.dart';
import 'package:medicompare/menubar/bloc/profile_bloc.dart';
import 'package:medicompare/menubar/screens/profile_screen.dart';
import 'package:medicompare/notification/bloc/notification_bloc.dart';
import 'package:medicompare/notification/notifications_screen.dart';
import 'package:medicompare/features/auth/otp/presentation/pages/verify_otp_screen.dart';
import 'package:medicompare/privacy_policy/cubit/privacy_policy_cubit.dart';
import 'package:medicompare/privacy_policy/screens/privacy_policy_screen.dart';
import 'package:medicompare/features/auth/register/presentation/bloc/doctor_registration_bloc.dart';
import 'package:medicompare/features/auth/register/presentation/pages/register_screen.dart';
import 'package:medicompare/report_analytic/cubit/analytics_cubit.dart';
import 'package:medicompare/report_analytic/screens/reports_analytics_screen.dart';
import 'package:medicompare/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:medicompare/features/schedule/presentation/screens/schedule_screen.dart';
import 'package:medicompare/schedule_setting/bloc/schedule_bloc.dart';
import 'package:medicompare/schedule_setting/schedule_settings_screen.dart';
import 'package:medicompare/search/bloc/search_bloc.dart';
import 'package:medicompare/search/screen/search_screen.dart';
import 'package:medicompare/searchAppointment/bloc/appointment_today_search_bloc.dart';
import 'package:medicompare/searchAppointment/model/appointment_today_search_screen.dart';
import 'package:medicompare/searchId/search_bloc.dart';
import 'package:medicompare/searchId/search_screen.dart';
import 'package:medicompare/setting/bloc/settings_bloc.dart';
import 'package:medicompare/setting/screen/settings_screen.dart';
import 'package:medicompare/today_aptmnt/bloc/appointment_bloc.dart';
import 'package:medicompare/today_aptmnt/screen/appointments_screen.dart';
import 'package:medicompare/videocall/bloc/video_call_bloc.dart';
import 'package:medicompare/videocall/video_call_screen.dart';

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

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route Not Found"))),
        );
    }
  }
}
