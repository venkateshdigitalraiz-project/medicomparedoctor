import 'package:flutter/material.dart';
import 'package:medicompare/features/onboarding/presentation/widgets/backscreen.dart';
import 'package:medicompare/features/onboarding/presentation/widgets/nextscreen.dart';

class Intro3Screen extends StatelessWidget {
  const Intro3Screen({
    super.key,
    required this.onFinish,
    required this.onSkip,
    this.onBack,
  });

  /// Called when the user taps the circular arrow button on the LAST intro
  /// page — saves the completion flag and navigates to Calendar.
  final VoidCallback onFinish;

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
                "assets/images/shapeimage3.png",
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
                        "Measure, Analyze, Improve",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                        ),
                      ),

                      SizedBox(height: size.height * .015),

                      Text(
                        "Access real time insights on \nappointments,patients engagement \n and clinic performance anytime",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
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
                            onTap: onFinish,
                            child: const NextMoveButton(
                              color: Color(0xFF6A1FB2),
                              sweep: 5.5,
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
