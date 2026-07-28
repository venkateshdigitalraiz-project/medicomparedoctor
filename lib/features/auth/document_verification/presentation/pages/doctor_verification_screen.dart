import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/widget/spraytype.dart';
import 'package:medicompare/features/auth/document_verification/presentation/bloc/document_verification_bloc.dart';
import 'package:medicompare/features/auth/document_verification/presentation/widgets/document_card.dart';
import 'package:medicompare/features/auth/document_verification/presentation/bloc/document_verification_state.dart';
import 'package:medicompare/features/auth/document_verification/presentation/bloc/document_verification_event.dart';

const _purple = Color(0xFF601CA3);
const _darkTeal = Color(0xFF17252A);

class DoctorVerificationScreen extends StatelessWidget {
  const DoctorVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentVerificationBloc()..add(const LoadDocuments()),
      child: const _DoctorVerificationView(),
    );
  }
}

class _DoctorVerificationView extends StatelessWidget {
  const _DoctorVerificationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: BlocListener<DocumentVerificationBloc, DocumentVerificationState>(
        listenWhen: (prev, curr) =>
            prev.submissionStatus != curr.submissionStatus ||
            prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.submissionStatus == SubmissionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Documents submitted for verification!'),
                backgroundColor: Color(0xFF2FAE6A),
              ),
            );
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: const Color(0xFFD64545),
              ),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child:
                    BlocBuilder<
                      DocumentVerificationBloc,
                      DocumentVerificationState
                    >(
                      builder: (context, state) {
                        if (state.documents.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          children: [
                            _buildRequiredDocumentsRow(state),
                            const SizedBox(height: 16),
                            for (final doc in state.documents)
                              DocumentCard(document: doc),
                          ],
                        );
                      },
                    ),
              ),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: IgnorePointer(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CustomPaint(
                painter: CornerGradientPainter(color: Color(0xFF601CA3)),
              ),
            ),
          ),
        ),
        Column(
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
                  textAlign: TextAlign.center,
                  'Doctor Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1F24),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 56, top: 4, right: 8),
              child: Text(
                'Verify your professional credentials to start practicing on the platform.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _darkTeal,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequiredDocumentsRow(DocumentVerificationState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Required Documents',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
            color: _darkTeal,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFDFF6E8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${state.completedCount}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
                TextSpan(
                  text: '/${state.totalCount}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: _darkTeal,
                  ),
                ),
                const TextSpan(
                  text: ' Completed',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: BlocBuilder<DocumentVerificationBloc, DocumentVerificationState>(
        builder: (context, state) {
          final isSubmitting =
              state.submissionStatus == SubmissionStatus.submitting;

          return SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: state.canSubmit
                  ? () => context.read<DocumentVerificationBloc>().add(
                      const SubmitVerification(),
                    )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                disabledBackgroundColor: _purple.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
