import 'package:flutter/material.dart';
import 'package:medicompare/features/onboarding/presentation/widgets/nextscreen.dart';

class Intro1Screen extends StatelessWidget {
  const Intro1Screen({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  /// Called when the user taps the circular arrow button to go to Intro2.
  final VoidCallback onNext;

  /// Called when the user taps "Skip" to exit the intro flow entirely.
  final VoidCallback onSkip;

  /// Called when the device back button is pressed on the intro screen.
  final VoidCallback? onBack;

  static const Color purple = Color(0xFF6A1FB2);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        onBack?.call();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/shapeimage1.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 30,
              right: 40,
              child: GestureDetector(
                onTap: onSkip,
                child: Text(
                  "Skip",
                  style: TextStyle(
                    color: Color(0xFF601CA3),
                    fontSize: size.width * .05,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * .07,
                  ).copyWith(bottom: size.height * .03),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Your Practice, Simplified",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),

                      SizedBox(height: size.height * .015),

                      Text(
                        'Manage appointments, patient visits, and daily '
                        'schedules effortlessly from a single App.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: size.height * .03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),

                          GestureDetector(
                            onTap: onNext,
                            child: const NextMoveButton(
                              color: Color(0xFF6A1FB2),
                              sweep: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
