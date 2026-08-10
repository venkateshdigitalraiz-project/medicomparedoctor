import 'package:flutter/material.dart';
import 'package:medicompare/features/onboarding/presentation/widgets/backscreen.dart';
import 'package:medicompare/features/onboarding/presentation/widgets/nextscreen.dart';

class Intro2Screen extends StatelessWidget {
  const Intro2Screen({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  /// Called when the user taps the circular arrow button to go to Intro3.
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
                "assets/images/shapeimage2.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 40,
              right: 30,
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
                        "Smart Scheduling for\nBusy Doctors",
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
                        "Customize availability, block holidays and organize consultations with an intelligent calendar.",
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
                          GestureDetector(
                            onTap: () async {
                              onBack?.call();
                              ;
                            },
                            child: const BackScreenButton(
                              color: Color(0xFF6A1FB2),
                            ),
                          ),

                          GestureDetector(
                            onTap: onNext,
                            child: const NextMoveButton(
                              color: Color(0xFF6A1FB2),
                              sweep: 3.5,
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
