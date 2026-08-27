import 'package:flutter/material.dart';
import '../bloc/call_state.dart';

class CallMinimizedBubble extends StatefulWidget {
  final CallConnectedState state;
  final VoidCallback onExpand;
  final VoidCallback onHangUp;

  const CallMinimizedBubble({
    super.key,
    required this.state,
    required this.onExpand,
    required this.onHangUp,
  });

  @override
  State<CallMinimizedBubble> createState() => _CallMinimizedBubbleState();
}

class _CallMinimizedBubbleState extends State<CallMinimizedBubble>
    with SingleTickerProviderStateMixin {
  Offset _position = const Offset(20, 120);
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Transparent pass-through layer
        Positioned.fill(
          child: IgnorePointer(child: Container(color: Colors.transparent)),
        ),

        // Draggable Floating Bubble
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onPanUpdate: (d) {
              setState(() {
                _position = Offset(
                  (_position.dx + d.delta.dx).clamp(0.0, size.width - 150),
                  (_position.dy + d.delta.dy).clamp(0.0, size.height - 180),
                );
              });
            },
            onTap: widget.onExpand,
            child: ScaleTransition(
              scale: _pulse,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 145,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8059CA), Color(0xFF5A3E99)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8059CA).withValues(alpha: 0.45),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag indicator
                      Container(
                        width: 28,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Avatar
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white24,
                        backgroundImage:
                            widget.state.peerAvatar != null
                                ? NetworkImage(widget.state.peerAvatar!)
                                : null,
                        child:
                            widget.state.peerAvatar == null
                                ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 24,
                                )
                                : null,
                      ),
                      const SizedBox(height: 6),

                      // Peer Name
                      Text(
                        widget.state.peerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Call Status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF34C759),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Tap to expand',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Hang up mini button
                      GestureDetector(
                        onTap: widget.onHangUp,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.call_end_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'End',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
