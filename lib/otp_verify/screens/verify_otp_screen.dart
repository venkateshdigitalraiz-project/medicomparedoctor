import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/widget/spraytype.dart';

import '../bloc/otp_bloc.dart';
import '../widgets/otp_digit_box.dart';

const _primaryPurple = Color(0xFF601CA3);
// const _lightPurpleBg = Color(0xFFF3E9FB);
const _darkTeal = Color(0xFF1B2E3C);

class VerifyOtpScreen extends StatelessWidget {
  final String phoneNumber;

  const VerifyOtpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpBloc()..add(OtpStarted(phoneNumber)),
      child: const _VerifyOtpView(),
    );
  }
}

class _VerifyOtpView extends StatefulWidget {
  const _VerifyOtpView();

  @override
  State<_VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<_VerifyOtpView> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state.status == OtpSubmissionStatus.success) {
              log("Successfully Verify otp then go to dashBoard");
              Navigator.pushReplacementNamed(context, RouteNames.homeBottomNav);
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Verified successfully!')),
              // );
            } else if (state.status == OtpSubmissionStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            final hasError = state.status == OtpSubmissionStatus.failure;
            final isSubmitting = state.status == OtpSubmissionStatus.submitting;

            return SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: CustomPaint(
                          painter: CornerGradientPainter(
                            color: Color(0xFF601CA3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back, color: _darkTeal),
                        ),
                        //  const SizedBox(height: 8),
                        Center(child: _buildLogo()),
                        const SizedBox(height: 24),
                        Center(child: _buildIllustration()),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: const Text(
                            'Verify with OTP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              color: _darkTeal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      'Please enter the 4 digit code sent to\n',
                                  style: TextStyle(
                                    fontSize: 14,
                                    //color: Colors.black87,
                                    // height: 1.4,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                TextSpan(
                                  text: '+91 ${state.phoneNumber}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    //color: Colors.black87,
                                    // height: 1.4,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                const WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Icon(Icons.edit_outlined, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (i) {
                            return OtpDigitBox(
                              controller: _controllers[i],
                              focusNode: _focusNodes[i],
                              nextFocusNode: i < 3 ? _focusNodes[i + 1] : null,
                              previousFocusNode: i > 0
                                  ? _focusNodes[i - 1]
                                  : null,
                              hasError: hasError,
                              onChanged: (value) {
                                context.read<OtpBloc>().add(
                                  OtpDigitChanged(index: i, value: value),
                                );
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Text(
                            state.formattedTimer,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: _darkTeal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontFamily: "Poppins",
                                ),
                              ),
                              GestureDetector(
                                onTap: state.canResend
                                    ? () {
                                        for (final c in _controllers) {
                                          c.clear();
                                        }
                                        _focusNodes[0].requestFocus();
                                        context.read<OtpBloc>().add(
                                          const OtpResendRequested(),
                                        );
                                      }
                                    : null,
                                child: Text(
                                  'Resend',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                    color: state.canResend
                                        ? Colors.red
                                        : Colors.red.withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    log("otp lenght ${_controllers.length}");
                                    if (_controllers.length == 4) {
                                      context.read<OtpBloc>().add(
                                        const OtpVerifySubmitted(),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Invalid OTP!'),
                                        ),
                                      );
                                    }
                                  },
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
                                        'Verify',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Poppins",
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      "assets/images/applogo.png",
      width: 87,
      height: 36,
      fit: BoxFit.contain,
    );
  }

  /// Placeholder illustration area — swap this Container out for the actual
  /// doctor/phone illustration asset (e.g. Image.asset('assets/otp_doctor.png')).
  Widget _buildIllustration() {
    return SizedBox(
      width: 260,
      height: 260,
      child: Center(
        child: Image.asset("assets/images/login.png", fit: BoxFit.contain),
      ),
    );
  }
}
