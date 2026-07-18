import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pin_bloc.dart';
import '../bloc/pin_event.dart';
import '../bloc/pin_state.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinBloc, PinState>(
      builder: (context, state) {
        bool enable = false;

        if (!state.isConfirmStep) {
          enable = state.createPin.length == 4;
        } else {
          enable = state.confirmPin.length == 4;
        }

        return SizedBox(
          width: double.infinity,
          height: 62,
          child: ElevatedButton(
            onPressed: enable
                ? () {
                    if (!state.isConfirmStep) {
                      context.read<PinBloc>().add(ContinuePressed());
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6C2BD9),
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 8,
            ),
            child: state.loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 15),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 28),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
