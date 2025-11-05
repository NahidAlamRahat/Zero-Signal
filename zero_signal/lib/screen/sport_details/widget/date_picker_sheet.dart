import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constant/app_colors.dart';
import '../../../widget/button_widget/button_widget.dart';
import '../../../widget/space_widget.dart';

class DatePickerSheet extends StatefulWidget {
  const DatePickerSheet({Key? key}) : super(key: key);

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  DateTime _focusedDay = DateTime(2025, 8, 1);
  DateTime? _selectedDay = DateTime(2025, 8, 21);

  @override
  Widget build(BuildContext context) {
    return Container(

    //  margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.creamBackgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                const Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 24),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: Color(0xFFBEC8C3),
          ),
          SpaceWidget(spaceHeight: 10),

          // Calendar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xffF5E9DF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TableCalendar(
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: false,
                leftChevronVisible: true,
                rightChevronVisible: true,
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Colors.black87,
                  size: 24,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Colors.black87,
                  size: 24,
                ),
                headerMargin: const EdgeInsets.only(bottom: 12),
                headerPadding: const EdgeInsets.only(bottom: 0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0x99484949),
                      width: 1,
                    ),
                  ),
                ),
              ),

              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
                weekendStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),

              ),
              calendarStyle: CalendarStyle(
                cellMargin: const EdgeInsets.all(4),
                defaultTextStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                weekendTextStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                outsideTextStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColor.backgroundColor,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                todayDecoration: BoxDecoration(
                  border: Border.all(color: AppColor.backgroundColor, width: 1.5),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

              ButtonWidget(
                backgroundColor: AppColor.secondary400,
                buttonWidth: 144,
                label: 'Cancel',
                textColor: AppColor.subTitleColor,
                onPressed: () => Navigator.pop(context),
              ),
              ButtonWidget(
                backgroundColor: AppColor.backgroundColor,
                buttonWidth: 144,

                label: 'Confirm',
                onPressed: () {
                  // Return selected date
                  Navigator.pop(context, _selectedDay);
                },
              ),
            ],),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}