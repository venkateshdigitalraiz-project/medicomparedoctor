import 'package:flutter/material.dart';
import 'package:medicompare/features/appointment_notes/data/datasources/appointment_notes_remote_data_source.dart';

Future<bool?> showAppointmentNotesBottomSheet(
  BuildContext context, {
  required String appointmentId,
  required String patientName,
  String? existingNotes,
  String? subtitle,
  VoidCallback? onNotesSaved,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (ctx) => AppointmentNotesBottomSheet(
          appointmentId: appointmentId,
          patientName: patientName,
          initialNotes: existingNotes,
          subtitle: subtitle,
          onNotesSaved: onNotesSaved,
        ),
  );
}

class AppointmentNotesBottomSheet extends StatefulWidget {
  final String appointmentId;
  final String patientName;
  final String? initialNotes;
  final String? subtitle;
  final VoidCallback? onNotesSaved;

  const AppointmentNotesBottomSheet({
    super.key,
    required this.appointmentId,
    required this.patientName,
    this.initialNotes,
    this.subtitle,
    this.onNotesSaved,
  });

  @override
  State<AppointmentNotesBottomSheet> createState() =>
      _AppointmentNotesBottomSheetState();
}

class _AppointmentNotesBottomSheetState
    extends State<AppointmentNotesBottomSheet> {
  late final TextEditingController _controller;
  final AppointmentNotesRemoteDataSource _dataSource =
      AppointmentNotesRemoteDataSourceImpl();

  bool _isSaving = false;
  String? _errorMessage;

  final List<String> _quickTemplates = [
    'Prescription provided',
    'Follow-up in 1 week',
    'Routine checkup normal',
    'Patient recovering well',
    'Advised rest & diet',
    'Lab tests recommended',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _appendTemplate(String text) {
    setState(() {
      final current = _controller.text.trim();
      if (current.isEmpty) {
        _controller.text = text;
      } else if (!current.contains(text)) {
        _controller.text = '$current. $text';
      }
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }

  Future<void> _handleSave() async {
    final notes = _controller.text.trim();
    if (notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter notes before saving'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (widget.appointmentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid appointment or patient ID'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await _dataSource.saveNotes(
        appointmentId: widget.appointmentId,
        notes: notes,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                'Notes saved successfully!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      widget.onNotesSaved?.call();
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage ?? 'Failed to save notes'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomInset),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: Color(0xFF6C4CF1),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Doctor Notes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: Color(0xFF1F2333),
                            ),
                          ),
                          if (widget.initialNotes != null &&
                              widget.initialNotes!.trim().isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Saved Note',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.patientName}${widget.subtitle != null && widget.subtitle!.isNotEmpty ? " • ${widget.subtitle}" : ""}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: Color(0xFF8A8A9C),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick templates
            const Text(
              'Quick Suggestions',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    _quickTemplates.map((template) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => _appendTemplate(template),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F6FB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add_rounded,
                                  size: 14,
                                  color: Color(0xFF6C4CF1),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  template,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Text Input Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE3E6F5), width: 1.2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 5,
                    minLines: 3,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1F2333),
                      height: 1.4,
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'Write clinical notes, diagnosis, observations, prescriptions, or follow-up instructions...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        color: Color(0xFF9CA3AF),
                        height: 1.4,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_controller.text.length} characters',
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      if (_controller.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _controller.clear();
                            setState(() {});
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Colors.red,
                ),
              ),
            ],

            const SizedBox(height: 18),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(
                    0xFF6C4CF1,
                  ).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child:
                    _isSaving
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.save_rounded, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              (widget.initialNotes != null &&
                                      widget.initialNotes!.trim().isNotEmpty)
                                  ? 'Update Notes'
                                  : 'Save Notes',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
