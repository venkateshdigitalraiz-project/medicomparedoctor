import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_list_tile.dart';
import '../widgets/profile_footer.dart';
import '../widgets/profile_header_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(const ProfileStarted()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          // Transient navigation side-effects (menu taps, header icons)
          // are surfaced through `navigationTarget` and handled here,
          // then cleared so they don't re-fire on rebuild.
          listener: (context, state) {
            if (state.navigationTarget != null) {
              final target = state.navigationTarget!;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Tapped: $target'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              context
                  .read<ProfileBloc>()
                  .add(const ProfileNavigationHandled());
            }
          },
          builder: (context, state) {
            if (state.status == ProfileStatus.loading ||
                state.status == ProfileStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ProfileStatus.failure) {
              return _ErrorView(
                message: state.errorMessage ?? 'Something went wrong',
                onRetry: () =>
                    context.read<ProfileBloc>().add(const ProfileStarted()),
              );
            }

            final bloc = context.read<ProfileBloc>();

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                ProfileHeaderCard(
                  profile: state.profile,
                  onBackTap: () => Navigator.of(context).maybePop(),
                  onNotificationsTap: () =>
                      bloc.add(const ProfileNotificationsTapped()),
                  onSettingsTap: () =>
                      bloc.add(const ProfileSettingsTapped()),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: List.generate(state.menuItems.length, (i) {
                      final item = state.menuItems[i];
                      final isLast = i == state.menuItems.length - 1;
                      return MenuListTile(
                        item: item,
                        showDivider: !isLast,
                        onTap: () =>
                            bloc.add(ProfileMenuItemTapped(item.id)),
                      );
                    }),
                  ),
                ),
                const ProfileFooter(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 40, color: AppColors.danger),
          const SizedBox(height: 10),
          Text(message, style: AppTextStyles.body),
          const SizedBox(height: 14),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
