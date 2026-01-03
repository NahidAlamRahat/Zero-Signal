import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/glass_effact.dart';

class GlassDatePickerData {
  final DateTime? selectedDate;
  GlassDatePickerData(this.selectedDate);
}

enum _DatePickerView { calendar, yearList, monthList }

class GlassDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const GlassDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<GlassDatePicker> createState() => _GlassDatePickerState();
}

class _GlassDatePickerState extends State<GlassDatePicker> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  _DatePickerView _currentView = _DatePickerView.calendar;
  ScrollController? _yearScrollController;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate;
    _selectedDay = widget.initialDate;
  }

  void _onLeftChevronTap() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
    });
  }

  void _onRightChevronTap() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
    });
  }

  void _showYearPicker() {
    setState(() {
      _currentView = _DatePickerView.yearList;
      final yearIndex = _focusedDay.year - widget.firstDate.year;
      // Approximate height per year item is ~48
      _yearScrollController = ScrollController(
        initialScrollOffset: (yearIndex * 48.0).h,
      );
    });
  }

  void _showMonthPicker() {
    setState(() {
      _currentView = _DatePickerView.monthList;
    });
  }

  void _showCalendar() {
    setState(() {
      _currentView = _DatePickerView.calendar;
      _yearScrollController?.dispose();
      _yearScrollController = null;
    });
  }

  @override
  void dispose() {
    _yearScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: GlassEffact(
          height: 400.h,
          width: 335.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                SizedBox(height: 10.h),
                // Content Area
                Expanded(child: _buildContent()),
                SizedBox(height: 10.h),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        backgroundColor: Colors.transparent,
                        borderColor: AppColor.white500,
                        label: 'Cancel',
                        textColor: AppColor.white500,
                        buttonHeight: 40.h,
                        onPressed: () => Get.back(),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ButtonWidget(
                        backgroundColor: AppColor.backgroundColor,
                        label: 'Confirm',
                        textColor: AppColor.white500,
                        buttonHeight: 40.h,
                        onPressed: () {
                          Get.back(result: _selectedDay);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentView) {
      case _DatePickerView.calendar:
        return TableCalendar(
          rowHeight: 38.h,
          firstDay: widget.firstDate,
          lastDay: widget.lastDate,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          headerVisible: false, // Hide default header
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.white500.withOpacity(0.7),
            ),
            weekendStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.white500.withOpacity(0.7),
            ),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(color: AppColor.white500),
            weekendTextStyle: TextStyle(color: AppColor.white500),
            outsideTextStyle:
                TextStyle(color: AppColor.white500.withOpacity(0.3)),
            selectedDecoration: BoxDecoration(
              color: AppColor.backgroundColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppColor.backgroundColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(color: AppColor.white500),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
        );
      case _DatePickerView.yearList:
        return _buildYearPicker();
      case _DatePickerView.monthList:
        return _buildMonthPicker();
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentView == _DatePickerView.calendar)
          IconButton(
            onPressed: _onLeftChevronTap,
            icon: Icon(Icons.chevron_left, color: AppColor.white500),
          )
        else
          SizedBox(width: 48), // Placeholder for alignment

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _showMonthPicker,
              child: Text(
                DateFormat('MMMM').format(_focusedDay),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.white500,
                  decoration: _currentView == _DatePickerView.monthList
                      ? TextDecoration.underline
                      : null,
                  decorationColor: AppColor.backgroundColor,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: _showYearPicker,
              child: Text(
                DateFormat('yyyy').format(_focusedDay),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.white500,
                  decoration: _currentView == _DatePickerView.yearList
                      ? TextDecoration.underline
                      : null,
                  decorationColor: AppColor.backgroundColor,
                ),
              ),
            ),
          ],
        ),

        if (_currentView == _DatePickerView.calendar)
          IconButton(
            onPressed: _onRightChevronTap,
            icon: Icon(Icons.chevron_right, color: AppColor.white500),
          )
        else
          SizedBox(width: 48), // Placeholder for alignment
      ],
    );
  }

  Widget _buildYearPicker() {
    final years = List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (index) => widget.firstDate.year + index,
    );
    // Scroll to the selected year
    return Scrollbar(
      thumbVisibility: true,
      controller: _yearScrollController,
      child: ListView.builder(
        controller: _yearScrollController,
        padding: EdgeInsets.zero,
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          final isSelected = year == _focusedDay.year;
          return InkWell(
            onTap: () {
              setState(() {
                _focusedDay =
                    DateTime(year, _focusedDay.month, _focusedDay.day);
                _showCalendar();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              alignment: Alignment.center,
              child: Text(
                year.toString(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected ? AppColor.backgroundColor : AppColor.white500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthPicker() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final monthDate = DateTime(_focusedDay.year, index + 1);
        final isSelected = index + 1 == _focusedDay.month;
        return InkWell(
          onTap: () {
            setState(() {
              _focusedDay =
                  DateTime(_focusedDay.year, index + 1, _focusedDay.day);
              _showCalendar();
            });
          },
          child: Center(
            child: Text(
              DateFormat('MMM').format(monthDate),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? AppColor.backgroundColor : AppColor.white500,
              ),
            ),
          ),
        );
      },
    );
  }
}
