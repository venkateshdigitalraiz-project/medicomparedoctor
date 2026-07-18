import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/dup_profile/model/user_profile_model.dart';
import 'package:medicompare/dup_profile/bloc/user_profile_state.dart';
import 'package:medicompare/dup_profile/screen/user_section_tile.dart';
import 'package:medicompare/dup_profile/screen/user_stat_card.dart';

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
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserProfileError) {
            return Center(child: Text(state.message));
          }

          final loaded = state as UserProfileLoaded;
          final profile = loaded.profile;
          final bloc = context.read<UserProfileBloc>();

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    //  padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            _buildTopGradientHeader(context, profile),

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
                                    UserProfileSection.professionalInformation,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    'Cardiology Department • 10 years experience',
                                    style: TextStyle(
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
                ),
              ],
            ),
          );
        },
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
          .map<Widget>((s) => UserStatCard(stat: s))
          .toList(),
    );
  }

  Widget _buildTopGradientHeader(BuildContext context, profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, bottom: 60),
      decoration: BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 40),
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.editProfile);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
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
                  child: Image.network(
                    profile.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.person, size: 60),
                  ),
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
