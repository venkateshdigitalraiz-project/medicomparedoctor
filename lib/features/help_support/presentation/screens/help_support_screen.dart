import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/help_support/presentation/bloc/faq_cubit.dart';
import 'package:medicompare/features/help_support/data/models/faq_item.dart';
import 'package:medicompare/features/help_support/presentation/widgets/section_card.dart';
import 'package:medicompare/features/help_support/presentation/widgets/faq_tile.dart';
import 'package:medicompare/features/help_support/presentation/widgets/contact_option.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FaqCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7FB),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Text(
                    "We're here to help! Find answers or get in touch with our "
                    'support team.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: Colors.black87,
                      //height: 1.4,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildFaqSection(),
                      _buildContactSection(),
                      _buildSupportHoursSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
              const SizedBox(width: 16),
              const Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- FAQ ----------
  Widget _buildFaqSection() {
    return SectionCard(
      icon: Icons.help_outline,
      title: 'Frequently Asked Questions',
      child: BlocBuilder<FaqCubit, List<FaqItem>>(
        builder: (context, faqs) {
          return Column(
            children: List.generate(faqs.length, (index) {
              return FaqTile(
                item: faqs[index],
                showDivider: index != faqs.length - 1,
                onTap: () => context.read<FaqCubit>().toggleExpand(index),
              );
            }),
          );
        },
      ),
    );
  }

  // ---------- Contact Support ----------
  Widget _buildContactSection() {
    return SectionCard(
      icon: Icons.headset_mic_outlined,
      title: 'Contact Support',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose a way to reach our team',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ContactOption(
                icon: Icons.chat_bubble_outline,
                label: 'Live Chat',
                subtitle: 'Chat with us',
                onTap: () {},
              ),
              const SizedBox(width: 10),
              ContactOption(
                icon: Icons.mail_outline,
                label: 'Email Us',
                subtitle: 'support@cli...',
                onTap: () {},
              ),
              const SizedBox(width: 10),
              ContactOption(
                icon: Icons.call_outlined,
                label: 'Call Us',
                subtitle: '+91 987654',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Support Hours ----------
  Widget _buildSupportHoursSection() {
    return SectionCard(
      icon: Icons.access_time,
      title: 'Support Hours',
      child: Row(
        children: [
          Expanded(
            child: _hourBlock(
              icon: Icons.calendar_today_outlined,
              label: 'Mon – Sat',
              time: '9:00 AM – 8:00 PM',
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFF0F0F0)),
          Expanded(
            child: _hourBlock(
              icon: Icons.settings_outlined,
              label: 'Sunday',
              time: '10:00 AM – 4:00PM',
            ),
          ),
        ],
      ),
    );
  }

  Widget _hourBlock({
    required IconData icon,
    required String label,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: const Color(0xFF601CA3)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
