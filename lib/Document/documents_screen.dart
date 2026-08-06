import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/Document/documents_bloc.dart';

const _green = Color(0xFF12A150);
const _greenLight = Color(0xFFE7F8EF);
const _headerBlue = Color(0xFFEAF2FF);
const _textDark = Color(0xFF171A1F);
const _textGrey = Color(0xFF6B7280);

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentsBloc()..add(LoadDocuments()),
      child: const _DocumentsView(),
    );
  }
}

class _DocumentsView extends StatelessWidget {
  const _DocumentsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<DocumentsBloc, DocumentsState>(
        builder: (context, state) {
          if (state.isLoading || state.documents.isEmpty) {
            return Center(
              child: AppLoader(
                color: const Color(0xFF6D28D9),
                size: 40,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DocumentsBloc>().add(RefreshDocuments());
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _Header()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: _StatusCard(state: state),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: _SectionHeader(state: state),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  sliver: SliverList.separated(
                    itemCount: state.documents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _DocumentCard(item: state.documents[index]),
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

/// ---------- Header with back button and title ----------
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        color: _headerBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: _textDark),
          ),
          const SizedBox(width: 4),
          const Text(
            'Documents',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- Verification status card with circular percent ----------
class _StatusCard extends StatelessWidget {
  final DocumentsState state;
  const _StatusCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(state.lastUpdated);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _green.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _greenLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: _green, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verification Status',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  state.allVerified
                      ? 'All documents are verified'
                      : '${state.verifiedCount}/${state.totalCount} documents verified',
                  style: const TextStyle(fontSize: 12.5, color: _textGrey),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: 46,
                height: 46,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 46,
                      height: 46,
                      child: AppLoader(
                        color: _green,
                        size: 46,
                      ),
                    ),
                    Text(
                      '${(state.verificationPercent * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Last Updated',
                style: TextStyle(fontSize: 10.5, color: _textGrey),
              ),
              Text(
                dateText,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }
}

/// ---------- Section header: title + "x/y Verified" pill ----------
class _SectionHeader extends StatelessWidget {
  final DocumentsState state;
  const _SectionHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification Certificates',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Your professional credentials',
                style: TextStyle(fontSize: 12.5, color: _textGrey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _greenLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${state.verifiedCount}/${state.totalCount} Verified',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _green,
            ),
          ),
        ),
      ],
    );
  }
}

/// ---------- Single document card ----------
class _DocumentCard extends StatelessWidget {
  final DocumentItem item;
  const _DocumentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(fontSize: 12, color: _textGrey),
                ),
                const SizedBox(height: 4),
                _StatusBadge(status: item.status),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showOptions(context, item),
            icon: const Icon(Icons.more_vert, color: _textGrey),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context, DocumentItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text('View document'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.upload_outlined),
              title: const Text('Re-upload'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final DocStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isVerified = status == DocStatus.verified;
    final color = isVerified ? _green : const Color(0xFFE8871E);
    final label = isVerified ? 'Verified' : 'Pending';
    final icon = isVerified ? Icons.check_circle : Icons.hourglass_bottom;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
