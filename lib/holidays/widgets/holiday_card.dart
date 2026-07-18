import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/holiday_model.dart';

class HolidayCard extends StatelessWidget {
  final Holiday holiday;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HolidayCard({
    super.key,
    required this.holiday,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    print("holiday ${holiday.date}");
    final month = DateFormat('MMM').format(holiday.date).toUpperCase();
    final day = holiday.date.day.toString();

    return IntrinsicHeight(
      // ClipRRect(
      //   borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFEDEDED)),
        ),
        //  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container(
            //   width: 4,
            //   decoration: BoxDecoration(
            //     color: holiday.typeColor,
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(20),
            //       bottomLeft: Radius.circular(20),
            //     ),
            //   ),
            // ),
            Container(
              width: 8,
              //  height: 72,
              decoration: BoxDecoration(
                color: holiday.typeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          month,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: "Poppins",
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          day,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            holiday.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: holiday.typeBgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              holiday.typeLabel,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: holiday.typeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _iconButton(
                      icon: Icons.edit,
                      color: const Color(0xFF7B61FF),
                      bgColor: const Color(0xFFEDE7F6),
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 8),
                    _iconButton(
                      icon: Icons.delete,
                      color: const Color(0xFFE53935),
                      bgColor: const Color(0xFFFFEBEE),
                      onTap: onDelete,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // Stack(
    //   children: [
    //     Container(
    //       margin: const EdgeInsets.only(bottom: 8),
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(20),
    //         border: Border.all(color: Colors.grey.shade300),
    //       ),
    //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    //       child: Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    //           child: Row(
    //             children: [
    //               Column(
    //                 children: [
    //                   Text(
    //                     month,
    //                     style: const TextStyle(
    //                       fontSize: 12,
    //                       fontFamily: "Poppins",
    //                       color: Colors.black87,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                   ),
    //                   Text(
    //                     day,
    //                     style: const TextStyle(
    //                       fontSize: 18,
    //                       fontFamily: "Poppins",
    //                       fontWeight: FontWeight.w800,
    //                       color: Colors.black87,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(width: 14),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       holiday.title,
    //                       style: const TextStyle(
    //                         fontSize: 14,
    //                         fontFamily: "Poppins",
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.black87,
    //                       ),
    //                     ),
    //                     const SizedBox(height: 6),
    //                     Container(
    //                       padding: const EdgeInsets.symmetric(
    //                         horizontal: 8,
    //                         vertical: 3,
    //                       ),
    //                       decoration: BoxDecoration(
    //                         color: holiday.typeBgColor,
    //                         borderRadius: BorderRadius.circular(20),
    //                       ),
    //                       child: Text(
    //                         holiday.typeLabel,
    //                         style: TextStyle(
    //                           fontSize: 10,
    //                           fontFamily: "Poppins",
    //                           color: holiday.typeColor,
    //                           fontWeight: FontWeight.w600,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               _iconButton(
    //                 icon: Icons.edit,
    //                 color: const Color(0xFF7B61FF),
    //                 bgColor: const Color(0xFFEDE7F6),
    //                 onTap: onEdit,
    //               ),
    //               const SizedBox(width: 8),
    //               _iconButton(
    //                 icon: Icons.delete,
    //                 color: const Color(0xFFE53935),
    //                 bgColor: const Color(0xFFFFEBEE),
    //                 onTap: onDelete,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     Positioned.fill(
    //       child: Align(
    //         alignment: Alignment.centerLeft,
    //         child: ClipRRect(
    //           borderRadius: const BorderRadius.only(
    //             topLeft: Radius.circular(20),
    //             bottomLeft: Radius.circular(20),
    //           ),
    //           child: Container(width: 4, color: holiday.typeColor),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget _iconButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
