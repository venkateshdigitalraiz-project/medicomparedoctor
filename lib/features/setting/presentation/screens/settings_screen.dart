import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/features/setting/presentation/bloc/settings_bloc.dart';
import 'package:medicompare/features/setting/presentation/bloc/settings_event.dart';
import 'package:medicompare/features/setting/presentation/bloc/settings_state.dart';
import 'package:medicompare/features/setting/data/models/settings_tile.dart';
import 'package:medicompare/features/setting/presentation/widgets/settings_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == SettingsStatus.navigating) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening "${state.activeItemKey}"...'),
                duration: const Duration(milliseconds: 900),
              ),
            );
            context.read<SettingsBloc>().add(const SettingsStatusReset());
          } else if (state.status == SettingsStatus.loggedOut) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logged out successfully'),
                duration: Duration(seconds: 1),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.login,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final isLoggingOut = state.status == SettingsStatus.loggingOut;

          return SafeArea(
            top: false,
            child: Column(
              children: [
                SettingsHeader(onBack: () => Navigator.maybePop(context)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SettingsTile(
                          icon: Icons.shield_outlined,
                          title: 'Privacy Policy',
                          subtitle:
                              'Manage your privacy preferences and\ndata protection settings',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.privacyPolicy,
                            );
                            // context.read<SettingsBloc>().add(
                            // const SettingsItemTapped('Privacy Policy'),
                            // );
                          },
                        ),
                        SettingsTile(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle:
                              'Choose your preferred language for the app',
                          onTap: () {
                            //   context.read<SettingsBloc>().add(
                            //   const SettingsItemTapped('Language'),
                            // );
                            Navigator.pushNamed(context, RouteNames.language);
                          },
                        ),
                        SettingsTile(
                          icon: Icons.headset_mic_outlined,
                          title: 'Help & Support',
                          subtitle:
                              'Get assistance and answers to your questions',
                          showDivider: false,
                          onTap: () {
                            //   context.read<SettingsBloc>().add(
                            //   const SettingsItemTapped('Help & Support'),
                            // );
                            Navigator.pushNamed(
                              context,
                              RouteNames.helpSupport,
                            );
                          },
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF4444),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(
                                  color: Color(0xFFDB1717),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            onPressed: isLoggingOut
                                ? null
                                : () => context.read<SettingsBloc>().add(
                                    const LogoutRequested(),
                                  ),
                            child: isLoggingOut
                                ? SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        AppLoader(
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                  )
                                : const Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'App Version 2.4.0',
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
