import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/create_pin/screens/continue_button.dart';
import 'package:medicompare/create_pin/screens/keypad.dart';
import 'package:medicompare/create_pin/screens/pin_box.dart';

import '../bloc/pin_bloc.dart';
import '../bloc/pin_event.dart';
import '../bloc/pin_state.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PinBloc, PinState>(
      listener: (context, state) {
        if (state.isConfirmStep) {
          _scrollToBottom();
        }

        if (state.error.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
        }

        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("PIN Created Successfully")),
          );

          // Navigator.pushReplacement(...)
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocBuilder<PinBloc, PinState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //------------------------------------------------
                          // Back Button
                          //------------------------------------------------
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.arrow_back_ios_new, size: 24),
                            ),
                          ),

                          const SizedBox(height: 20),

                          //------------------------------------------------
                          // Title
                          //------------------------------------------------
                          const Center(
                            child: Text(
                              "Create New PIN",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff063B4C),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          //------------------------------------------------
                          // Subtitle
                          //------------------------------------------------
                          const Center(
                            child: Text(
                              "Add a PIN number to make\nyour account more secure",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          const SizedBox(height: 60),

                          //------------------------------------------------
                          // Create PIN
                          //------------------------------------------------
                          const Text(
                            "Create PIN",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 20),

                          //------------------------------------------------
                          // PIN BOX
                          //------------------------------------------------
                          GestureDetector(
                            onTap: () {
                              context.read<PinBloc>().add(ShowKeypad());
                            },
                            child: PinBox(pin: state.createPin),
                          ),

                          const SizedBox(height: 35),

                          //------------------------------------------------
                          // PART 2 STARTS HERE
                          //------------------------------------------------
                          //------------------------------------------------
                          // Confirm PIN
                          //------------------------------------------------
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: state.isConfirmStep
                                ? Column(
                                    key: const ValueKey("confirmPin"),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),

                                      const Text(
                                        "Confirm PIN",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      GestureDetector(
                                        onTap: () {
                                          context.read<PinBloc>().add(
                                            ShowKeypad(),
                                          );
                                        },
                                        child: PinBox(pin: state.confirmPin),
                                      ),

                                      const SizedBox(height: 15),

                                      AnimatedOpacity(
                                        opacity: state.error.isEmpty ? 0 : 1,
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        child: SizedBox(
                                          height: 22,
                                          child: Text(
                                            state.error,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 40),

                          //------------------------------------------------
                          // Continue Button
                          //------------------------------------------------
                          const ContinueButton(),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  //------------------------------------------------
                  // Bottom Keypad
                  //------------------------------------------------
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    offset: state.showKeypad ? Offset.zero : const Offset(0, 1),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: state.showKeypad ? 1 : 0,
                      child: state.showKeypad
                          ? const Keypad()
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
