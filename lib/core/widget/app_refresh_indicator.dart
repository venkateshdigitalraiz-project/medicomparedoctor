import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart'; // 👈 import your loader

/// A thin wrapper around Flutter's [RefreshIndicator] that hides the
/// default spinner and shows [AppLoader] instead while refreshing.
/// Drop-in replacement — same API as before, just pass [onRefresh] and [child].
class AppRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color color;
  final double loaderSize;
  final double topposition;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color = const Color(0xFF6D28D9),
    this.loaderSize = 30,
    this.topposition = 0,
  });

  @override
  State<AppRefreshIndicator> createState() => _AppRefreshIndicatorState();
}

class _AppRefreshIndicatorState extends State<AppRefreshIndicator> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _handleRefresh,
          // Make the built-in spinner invisible — we render AppLoader instead.
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          strokeWidth: 0.01,
          child: widget.child,
        ),
        if (_isRefreshing)
          Positioned(
            top: widget.topposition,
            left: 0,
            right: 0,
            child: Center(
              child: AppLoader(color: widget.color, size: widget.loaderSize),
            ),
          ),
      ],
    );
  }
}
