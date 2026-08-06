import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/widget/circle_login_button.dart';
import 'package:medicompare/core/widget/common_state_widgets.dart';
import 'package:medicompare/core/widget/app_refresh_indicator.dart';
import 'package:medicompare/features/auth/logout/presentation/utils/logout_handler.dart';
import 'package:medicompare/features/profile/data/models/user_profile_model.dart';
import '../bloc/user_profile_state.dart';
import 'user_section_tile.dart';
import 'user_stat_card.dart';

import '../bloc/user_profile_bloc.dart';
import '../bloc/user_profile_event.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _UserProfileView();
  }
}

class _UserProfileView extends StatelessWidget {
  const _UserProfileView();

  // static const _purple = Color(0xFF6C4FE0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Always visible header/app bar
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.editProfile,
                              );
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFF6FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleIconButton(
                            icon: Icons.logout,
                            onTap: () {
                              LogoutHandler.logout(context);
                            },
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocConsumer<UserProfileBloc, UserProfileState>(
                listener: (context, state) {
                  if (state is UserProfileLoaded &&
                      state.refreshError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.refreshError!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UserProfileLoading) {
                    return const CommonLoadingWidget();
                  }
                  if (state is UserProfileError) {
                    return CommonErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<UserProfileBloc>().add(
                          const UserProfileStarted(),
                        );
                      },
                    );
                  }

                  final loaded = state as UserProfileLoaded;
                  final profile = loaded.profile;
                  final bloc = context.read<UserProfileBloc>();

                  return AppRefreshIndicator(
                    topposition: 0,
                    onRefresh: () async {
                      if (bloc.state is UserProfileLoading) return;
                      final completer = Completer<void>();
                      bloc.add(UserProfileStarted(completer: completer));
                      await completer.future;
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              _buildTopGradientHeaderBody(context, profile),

                              Positioned(
                                bottom: -90,
                                left: 20,
                                right: 20,
                                child: _buildStatsRow(profile),
                              ),
                            ],
                          ),

                          const SizedBox(height: 80),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 24),

                                UserSectionTile(
                                  leadingIcon: Icons.person_outline_rounded,
                                  title: 'Presonal Information',
                                  isExpanded: loaded.isExpanded(
                                    UserProfileSection.personalInformation,
                                  ),
                                  onTap: () => bloc.add(
                                    const UserProfileSectionToggled(
                                      UserProfileSection.personalInformation,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Column(
                                      children: [
                                        UserInfoRow(
                                          icon: Icons.school_outlined,
                                          label: 'Mail ID',
                                          value: profile.email,
                                        ),
                                        UserInfoRow(
                                          icon: Icons.badge_outlined,
                                          label: 'Phone Number',
                                          value: profile.phoneNumber,
                                        ),
                                        UserInfoRow(
                                          icon: Icons.wc_rounded,
                                          label: 'Gender',
                                          value: profile.gender,
                                        ),
                                        UserInfoRow(
                                          icon: Icons.location_on_outlined,
                                          label: 'Address',
                                          value: profile.address,
                                          maxLines: 2,
                                        ),
                                        UserInfoRow(
                                          icon: Icons.info_outline,
                                          label: 'Status',
                                          value: profile.status,
                                        ),
                                        // UserInfoRow(
                                        //   icon: Icons.calendar_today_outlined,
                                        //   label: 'Created Date',
                                        //   value: profile.createdAt,
                                        // ),
                                        // UserInfoRow(
                                        //   icon: Icons.edit_calendar_outlined,
                                        //   label: 'Updated Date',
                                        //   value: profile.updatedAt,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                // // ---- Professional Information ----
                                UserSectionTile(
                                  leadingIcon: Icons.medical_services_outlined,
                                  title: 'Professional Information',
                                  isExpanded: loaded.isExpanded(
                                    UserProfileSection.professionalInformation,
                                  ),
                                  onTap: () => bloc.add(
                                    const UserProfileSectionToggled(
                                      UserProfileSection
                                          .professionalInformation,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      '${profile.specialty} - ${profile.experience} Years Experience',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),

                                // Working Hours
                                UserSectionTile(
                                  leadingIcon: Icons.access_time_rounded,
                                  title: 'Working Hours',
                                  isExpanded: loaded.isExpanded(
                                    UserProfileSection.workingHours,
                                  ),
                                  onTap: () => bloc.add(
                                    const UserProfileSectionToggled(
                                      UserProfileSection.workingHours,
                                    ),
                                  ),
                                  trailingChip: profile.isAvailableNow
                                      ? _buildAvailableChip()
                                      : null,
                                  child: const Padding(
                                    padding: EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      'Mon - Fri: 9:00 AM - 5:00 PM',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),

                                // // ---- Clinical Information (peek, matches cropped design) ----
                                UserSectionTile(
                                  leadingIcon: Icons.local_hospital_outlined,
                                  title: 'Clinical Information',
                                  isExpanded: loaded.isExpanded(
                                    UserProfileSection.clinicalInformation,
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.clinicInfo,
                                  ),
                                  // bloc.add(
                                  //   const UserProfileSectionToggled(
                                  //     UserProfileSection.clinicalInformation,
                                  //   ),
                                  // ),
                                  showDivider: false,
                                  child: const Padding(
                                    padding: EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      'City Heart Hospital, Room 204',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                                // // ---- Clinical Information (peek, matches cropped design) ----
                                UserSectionTile(
                                  leadingIcon: Icons.edit_document,
                                  title: 'Documents',
                                  isExpanded: loaded.isExpanded(
                                    UserProfileSection.document,
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.document,
                                  ),
                                  showDivider: false,
                                  child: const Padding(
                                    padding: EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      'Set All Documents',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F7EC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.circle, color: Color(0xFF27AE60), size: 8),
          SizedBox(width: 6),
          Text(
            'Available Now',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF27AE60),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ignore: strict_top_level_inference
  Widget _buildStatsRow(profile) {
    return Row(
      children: profile.stats
          .map<Widget>((s) => Expanded(child: UserStatCard(stat: s)))
          .toList(),
    );
  }

  Widget _buildTopGradientHeaderBody(BuildContext context, profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 60),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipOval(
                  child:
                      (profile.avatarUrl.startsWith('http://') ||
                          profile.avatarUrl.startsWith('https://'))
                      ? Image.network(
                          profile.avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.person, size: 60),
                        )
                      : const Icon(Icons.person, size: 60),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              if (profile.isVerified) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF27AE60),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: profile.specialty,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '  •  ID: ${profile.id}',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
