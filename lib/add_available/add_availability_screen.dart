import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/add_available/bloc/add_avai_event.dart';
import 'package:medicompare/add_available/bloc/add_avai_state.dart';
import 'package:medicompare/add_available/model/break_time_model.dart';
import 'package:medicompare/add_available/widget/availability_preview.dart';
import 'package:medicompare/add_available/widget/availability_switch_card.dart';
import 'package:medicompare/add_available/widget/break_time_card.dart';
import 'package:medicompare/add_available/widget/consultation_fee_card.dart';
import 'package:medicompare/add_available/widget/consultation_hours_card.dart';
import 'package:medicompare/add_available/widget/consultation_mode_card.dart';
import 'package:medicompare/add_available/widget/headerappbar.dart';
import 'package:medicompare/add_available/widget/primary_button.dart';
import 'package:medicompare/add_available/widget/slot_duration_selector.dart';
import 'package:medicompare/add_available/widget/vacation_mode_card.dart';
import 'package:medicompare/add_available/widget/working_days_selector.dart';

import 'bloc/availability_bloc.dart';

class AddAvailabilityScreen extends StatelessWidget {
  const AddAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailabilityBloc(),
      child: const _AddAvailabilityView(),
    );
  }
}

class _AddAvailabilityView extends StatefulWidget {
  const _AddAvailabilityView();

  @override
  State<_AddAvailabilityView> createState() => _AddAvailabilityViewState();
}

class _AddAvailabilityViewState extends State<_AddAvailabilityView> {
  late TextEditingController feeController;

  @override
  void initState() {
    super.initState();

    feeController = TextEditingController();
  }

  @override
  void dispose() {
    feeController.dispose();
    super.dispose();
  }

  Future<void> _pickStartTime() async {
    final bloc = context.read<AvailabilityBloc>();

    final picked = await showTimePicker(
      context: context,
      initialTime: bloc.state.startTime,
    );

    if (picked != null) {
      bloc.add(ChangeStartTime(picked));
    }
  }

  Future<void> _pickEndTime() async {
    final bloc = context.read<AvailabilityBloc>();

    final picked = await showTimePicker(
      context: context,
      initialTime: bloc.state.endTime,
    );

    if (picked != null) {
      bloc.add(ChangeEndTime(picked));
    }
  }

  Future<void> _pickBreakStart() async {
    final bloc = context.read<AvailabilityBloc>();

    final picked = await showTimePicker(
      context: context,
      initialTime: bloc.state.breakTime.start,
    );

    if (picked != null) {
      bloc.add(
        ChangeBreakTime(
          BreakTimeModel(start: picked, end: bloc.state.breakTime.end),
        ),
      );
    }
  }

  Future<void> _pickBreakEnd() async {
    final bloc = context.read<AvailabilityBloc>();

    final picked = await showTimePicker(
      context: context,
      initialTime: bloc.state.breakTime.end,
    );

    if (picked != null) {
      bloc.add(
        ChangeBreakTime(
          BreakTimeModel(start: bloc.state.breakTime.start, end: picked),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AvailabilityBloc, AvailabilityState>(
      listener: (context, state) {
        feeController.value = TextEditingValue(
          text: state.consultationFee,
          selection: TextSelection.collapsed(
            offset: state.consultationFee.length,
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffF6F7FB),

          // appBar: PreferredSize(
          //   preferredSize: const Size.fromHeight(100),
          //   child: AppBar(
          //     elevation: 0,
          //     backgroundColor: Colors.transparent,
          //     automaticallyImplyLeading: false,
          //     flexibleSpace: Container(
          //       decoration: const BoxDecoration(
          //         color: Color(0xFFEFF6FF),
          //         borderRadius: BorderRadius.only(
          //           bottomLeft: Radius.circular(32),
          //           bottomRight: Radius.circular(32),
          //         ),
          //       ),
          //     ),
          //     titleSpacing: 0,
          //     title: SafeArea(
          //       child: Row(
          //         children: [
          //           IconButton(
          //             icon: const Icon(Icons.arrow_back, color: Colors.black),
          //             onPressed: () => Navigator.pop(context),
          //           ),
          //           const SizedBox(width: 30),
          //           SizedBox(height: 16),
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: const [
          //               Text(
          //                 "Add Availability",
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                   fontFamily: "Poppins",
          //                   fontWeight: FontWeight.w500,
          //                   fontSize: 20,
          //                 ),
          //               ),
          //               Text(
          //                 "Manage consultation schedule",
          //                 style: TextStyle(
          //                   color: Colors.black54,
          //                   fontFamily: "Poppins",
          //                   fontWeight: FontWeight.w400,
          //                   fontSize: 12,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  HeaderAPpbar(),
                  SizedBox(height: 16),
                  AvailabilitySwitchCard(
                    isAvailable: state.availableToday,
                    timing:
                        "${state.startTime.format(context)} - ${state.endTime.format(context)}",
                    onChanged: (_) {
                      context.read<AvailabilityBloc>().add(
                        ToggleAvailability(),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  WorkingDaysSelector(
                    selectedDays: state.selectedDays,
                    onDayTap: (day) {
                      context.read<AvailabilityBloc>().add(
                        ToggleWorkingDay(day),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  ConsultationHoursCard(
                    startTime: state.startTime,
                    endTime: state.endTime,
                    onStartTap: _pickStartTime,
                    onEndTap: _pickEndTime,
                  ),

                  const SizedBox(height: 16),

                  SlotDurationSelector(
                    selectedDuration: state.slotDuration,
                    onSelected: (duration) {
                      context.read<AvailabilityBloc>().add(
                        ChangeSlotDuration(duration),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  ConsultationModeCard(
                    selectedMode: state.consultationMode,
                    onChanged: (mode) {
                      context.read<AvailabilityBloc>().add(
                        ToggleConsultationMode(mode),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  VacationModeCard(
                    enabled: state.vacationMode,
                    onChanged: (_) {
                      context.read<AvailabilityBloc>().add(
                        ToggleVacationMode(),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  BreakTimeCard(
                    startBreak: state.breakTime.start,
                    endBreak: state.breakTime.end,
                    onStartTap: _pickBreakStart,
                    onEndTap: _pickBreakEnd,
                    onAddBreak: () {},
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: AvailabilityPreview(slots: state.previewSlots),
                  ),

                  const SizedBox(height: 16),

                  ConsultationFeeCard(
                    controller: feeController,
                    onChanged: (value) {
                      context.read<AvailabilityBloc>().add(
                        ChangeConsultationFee(value),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  PrimaryButton(
                    text: "Save Availability",
                    onPressed: () {
                      _saveAvailability();
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveAvailability() {
    final bloc = context.read<AvailabilityBloc>();

    final state = bloc.state;

    if (state.selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select working days")),
      );
      return;
    }

    if (state.consultationFee.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter consultation fee")),
      );
      return;
    }

    bloc.add(SaveAvailability());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Availability Saved Successfully")),
    );
  }
}
