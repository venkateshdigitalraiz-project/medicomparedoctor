import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/privacy_policy/cubit/privacy_policy_cubit.dart';
import 'package:medicompare/privacy_policy/cubit/privacy_policy_state.dart';
import 'package:medicompare/privacy_policy/widgets/policy_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrivacyPolicyCubit()..loadPolicies(),
      child: const _PrivacyPolicyView(),
    );
  }
}

class _PrivacyPolicyView extends StatelessWidget {
  const _PrivacyPolicyView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with rounded bottom corners, matching the design.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Color(0xFFE7F0FE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Body: reacts to the cubit's state.
            Expanded(
              child: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
                builder: (context, state) {
                  if (state is PrivacyPolicyLoading) {
                    return Center(
                      child: AppLoader(
                        color: const Color(0xFF6D28D9),
                        size: 40,
                      ),
                    );
                  }

                  if (state is PrivacyPolicyError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Something went wrong: ${state.message}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }

                  final items = (state as PrivacyPolicyLoaded).items;

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        PolicyCard(item: items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
