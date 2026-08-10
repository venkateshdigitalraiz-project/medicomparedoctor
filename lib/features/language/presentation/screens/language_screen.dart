import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/language/presentation/bloc/language_bloc.dart';

const Color _kPrimaryPurple = Color(0xFF4B0F8A);
const Color _kDarkPurple = Color(0xFF601CA3);
const Color _kHeaderBlue = Color(0xFFE8F1FE);
const Color _kSelectedRowBg = Color(0xFFF2ECFB);
const Color _kBorderGrey = Color(0xFFE3E3E8);

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});
  //LanguageScreen,LanguageBloc
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LanguageBloc(),
      child: const _LanguageView(),
    );
  }
}

class _LanguageView extends StatefulWidget {
  const _LanguageView();

  @override
  State<_LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<_LanguageView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<LanguageBloc, LanguageState>(
          listener: (context, state) {
            if (state.isApplied) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Language set to ${state.selectedLanguage.name}',
                  ),
                  backgroundColor: _kPrimaryPurple,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _Header(onBack: () => Navigator.of(context).maybePop()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'You Selected',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _SelectedLanguageCard(
                          language: state.selectedLanguage.name,
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'All Languages',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _SearchField(
                          controller: _searchController,
                          onChanged: (value) => context
                              .read<LanguageBloc>()
                              .add(LanguageSearchChanged(value)),
                        ),
                        const SizedBox(height: 14),
                        _LanguageList(state: state),
                      ],
                    ),
                  ),
                ),
                _ApplyButton(
                  onTap: () =>
                      context.read<LanguageBloc>().add(const LanguageApplied()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Top blue header with back button, title and subtitle.
class _Header extends StatelessWidget {
  final VoidCallback onBack;
  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: const BoxDecoration(
        color: _kHeaderBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onBack,
            child: const Padding(
              padding: EdgeInsets.only(top: 4, right: 12),
              child: Icon(Icons.arrow_back, size: 22, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select your preferred language for the app. '
                  'You can change it anytime.',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
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

/// Card showing the currently selected language with a filled checkmark.
class _SelectedLanguageCard extends StatelessWidget {
  final String language;
  const _SelectedLanguageCard({required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorderGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            language,
            style: const TextStyle(
              fontSize: 17,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const _CheckBadge(),
        ],
      ),
    );
  }
}

/// Small filled purple circle with a white checkmark.
class _CheckBadge extends StatelessWidget {
  const _CheckBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: _kPrimaryPurple,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 15, color: Colors.white),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _kBorderGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w300,
        ),
        decoration: const InputDecoration(
          hintText: 'Search  for Language',
          hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.black45, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

/// Bordered list containing every language row.
class _LanguageList extends StatelessWidget {
  final LanguageState state;
  const _LanguageList({required this.state});

  @override
  Widget build(BuildContext context) {
    final languages = state.filteredLanguages;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _kBorderGrey),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < languages.length; i++)
            _LanguageRow(
              language: languages[i],
              isSelected: languages[i].code == state.selectedLanguage.code,
              showDivider: i != languages.length - 1,
            ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final LanguageModel language;
  final bool isSelected;
  final bool showDivider;

  const _LanguageRow({
    required this.language,
    required this.isSelected,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<LanguageBloc>().add(LanguageSelected(language)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? _kSelectedRowBg : Colors.transparent,
          border: showDivider
              ? const Border(bottom: BorderSide(color: _kBorderGrey))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language.name,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            isSelected
                ? const _CheckBadge()
                : Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _kBorderGrey, width: 1.4),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

/// Bottom gradient "Apply Language" button.
class _ApplyButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ApplyButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [_kPrimaryPurple, _kDarkPurple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Apply Language',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
