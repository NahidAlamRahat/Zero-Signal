import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/space_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../report_button_sheet/report_button_sheet.dart';
import '../../routes/app_routes.dart';
import '../../widget/showCustomDialog.dart';

class SpotDetailsScreen extends StatefulWidget {
  const SpotDetailsScreen({super.key});

  @override
  State<SpotDetailsScreen> createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  bool showAllComments = false;

  // Sample comments data
  List<Map<String, dynamic>> allComments = [
    {
      'name': 'Charolette Hanlin',
      'date': 'Feb 3, 2025',
      'comment':
          'Chill atmosphere, friendly crowd. Exactly the relaxed spot we were looking for on a Friday night. Loved it. 😍😍',
      'avatar': Colors.blue[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.blue,
    },
    {
      'name': 'Olivia Gabriella Hernandez',
      'date': 'Apr 21, 2025',
      'comment':
          'Good music, but the service was slow. Maybe an off night? The overall vibe was still positive though. 😊😊',
      'avatar': Colors.green[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.green,
    },
    {
      'name': 'Emma Victoria Lewis',
      'date': 'Mar 13, 2025',
      'comment':
          'Incredible vibes and even better cocktails. A bit crowded but that just adds to the fun. Highly recommend! 😍😍',
      'avatar': Colors.orange[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.orange,
    },

    {
      'name': 'Emma Victoria Lewis',
      'date': 'Mar 13, 2025',
      'comment':
          'Incredible vibes and even better cocktails. A bit crowded but that just adds to the fun. Highly recommend! 😍😍',
      'avatar': Colors.orange[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> commentsToShow = showAllComments
        ? allComments
        : [allComments.first];

    int remainingComments = allComments.length - 1;

    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
        textWidget: TextWidget(
          text: 'Spot Details',
          fontColor: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        action: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.ios_share),
        ),
      ),
      backgroundColor: AppColor.creamBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  AppImagePath.viewImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title and location
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lakeside Campsite',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Espat, Catalonia',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Rating and user info
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {

                                    showDialog(

                                      context: context,
                                      builder: (context) => ShowCustomDialog(
                                        backgroundColor:
                                            AppColor.creamBackgroundColor,
                                        title: '@naturanauta',
                                        titleStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        description:
                                            'I’m a nature lover and outdoor enthusiast',
                                        descriptionStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        image: Image.asset(
                                          AppImagePath.profileImage,
                                        ),
                                        actionsLayout: ActionsLayout.column,
                                        actions: [
                                          Icon(
                                            Icons.thumb_up_outlined,
                                            size: 32,
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 20,
                                              left: 20,
                                            ),
                                            child: ButtonWidget(
                                              onPressed: (){
                                                Get.back();
                                                Get.toNamed(AppRoutes.viewProfileScreen);
                                              },
                                              backgroundColor:
                                                  AppColor.backgroundColor,
                                              label: 'View Profile',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              buttonHeight: 40,
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 20,
                                              left: 20,
                                            ),
                                            child: ButtonWidget(
                                              onPressed: () {
                                                Get.back();
                                                showReport(context);
                                              },
                                              backgroundColor:
                                                  Colors.transparent,
                                              textColor: Colors.red,
                                              label: 'Report user',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              buttonHeight: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );


                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.brown,
                                        child: const Icon(
                                          Icons.person,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('@naturanauta'),
                                    ],
                                  ),
                                ),
                              ),
                              Icon(Icons.star, color: AppColor.yello),
                              TextWidget(
                                text: '(17 lugares / 6 plane)',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  backgroundColor: AppColor.backgroundColor,
                                  label: 'How To Arrive',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  buttonHeight: 48,
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ButtonWidget(
                                  backgroundColor: Color.fromRGBO(
                                    245,
                                    233,
                                    223,
                                    1,
                                  ),
                                  label: 'Add Favorites',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  textColor: Colors.black,
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ButtonWidget(
                                  backgroundColor: Color.fromRGBO(
                                    245,
                                    233,
                                    223,
                                    1,
                                  ),
                                  label: 'Assist',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  textColor: Colors.black,
                                  onPressed: () {

                                    showDatePickerSheet(context);
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Visitor info
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.lightGrayishOrange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '5 user will visit this place on Sunday',
                              style: TextStyle(
                                color: Color(0xFF2C2C2C),
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Description section
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Escape the heat at the Azure Oasis. This stunning, crystal-clear pool is a tranquil paradise, surrounded by lush greenery. Its the perfect spot to relax, refresh, and immerse yourself in serene beauty.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Comments section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Comments',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D2D2D),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAllComments = !showAllComments;
                                  });
                                },
                                child: TextWidget(
                                  text: showAllComments
                                      ? 'Show less'
                                      : 'See more ($remainingComments)',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  fontColor: AppColor.backgroundColor,
                                  underline: true,
                                ),
                              ),
                            ],
                          ),
                          SpaceWidget(spaceHeight: 16,),
                          // Comments List
                          ...commentsToShow.map((comment) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColor.creamBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: comment['avatar'],
                                        child: Icon(
                                          comment['avatarIcon'],
                                          color: comment['avatarIconColor'],
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            comment['date'],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  TextWidget(
                                    text: comment['comment'],
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    textAlignment: TextAlign.start,
                                  ),
                                ],
                              ),
                            );
                          }),

                          // Add comment section (only show when not showing all comments or at the end)
                          if (!showAllComments || showAllComments) ...[
                            TextFieldWidget(
                              borderColor: AppColor.lightGrayishOrange,
                              backgroundColor: AppColor.lightGrayishOrange,
                              borderRadius: 8,
                              hintText: 'Add a comment here....',
                            ),
                            const SizedBox(height: 16),

                            // Comment Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: ButtonWidget(
                                backgroundColor: AppColor.backgroundColor,
                                label: 'Comment',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                buttonHeight: 40,
                                buttonWidth: 100,
                                onPressed: () {
                                  // Handle comment submission
                                },
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Update Status
                            Center(
                              child: TextWidget(
                                text: 'Update Status',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontColor: AppColor.backgroundColor,
                                underline: true,
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showReport(context) {
    showDialog(
      context: context,
      builder: (context) => ReportActivityBottomSheet(),
    );
  }



Future<void> showDatePickerSheet(BuildContext context) async {
final selectedDate = await CalendarBottomSheet.show(context);

}




}








class CalendarBottomSheet extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;

  const CalendarBottomSheet({
    Key? key,
    this.initialDate,
    this.onDateSelected,
  }) : super(key: key);

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();

  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControllerEnabled: true,
      builder: (context) => CalendarBottomSheet(initialDate: initialDate),
    );
  }
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime currentMonth;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    currentMonth = widget.initialDate ?? DateTime.now();
    selectedDate = widget.initialDate;
  }

  void _changeMonth(int delta) {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + delta);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 514,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF4E9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFDBDBDB),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Select Date',
            style: TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 0.5,
            color: const Color(0xFFBEC8C3),
          ),
          const SizedBox(height: 16),
          _buildCalendar(),
          const Spacer(),
          _buildButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0x99484949)),
          const SizedBox(height: 16),
          _buildWeekDays(),
          const SizedBox(height: 15),
          _buildDaysGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getMonthYear(),
          style: const TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 22),
              onPressed: () => _changeMonth(-1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 22),
              onPressed: () => _changeMonth(1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekDays() {
    const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((day) => SizedBox(
        width: 40,
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildDaysGrid() {
    final daysInMonth = _getDaysInMonth();
    return Column(
      children: _buildWeeks(daysInMonth),
    );
  }

  List<Widget> _buildWeeks(List<DateTime?> days) {
    List<Widget> weeks = [];
    for (int i = 0; i < days.length; i += 7) {
      weeks.add(_buildWeek(days.sublist(i, i + 7)));
      if (i + 7 < days.length) weeks.add(const SizedBox(height: 12));
    }
    return weeks;
  }

  Widget _buildWeek(List<DateTime?> days) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) => _buildDayCell(day)).toList(),
    );
  }

  Widget _buildDayCell(DateTime? day) {
    if (day == null) {
      return const SizedBox(width: 36, height: 28);
    }

    final isCurrentMonth = day.month == currentMonth.month;
    final isSelected = selectedDate != null && 
        day.year == selectedDate!.year &&
        day.month == selectedDate!.month &&
        day.day == selectedDate!.day;
    final isToday = _isToday(day);

    return GestureDetector(
      onTap: () => isCurrentMonth ? _selectDate(day) : null,
      child: Container(
        width: 36,
        height: 28,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E4F3E) : Colors.transparent,
          border: isToday && !isSelected
              ? Border.all(color: const Color(0xFF2E4F3E), width: 1)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: isSelected
                ? const Color(0xFFFBFBFB)
                : isCurrentMonth
                    ? const Color(0xFF2C2C2C)
                    : const Color(0xFFDBDBDB),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDED3C0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF565656),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (selectedDate != null) {
                  widget.onDateSelected?.call(selectedDate!);
                  Navigator.pop(context, selectedDate);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E4F3E),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Color(0xFFF1F1F1),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthYear() {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[currentMonth.month - 1]} ${currentMonth.year}';
  }

  List<DateTime?> _getDaysInMonth() {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final prevMonthDays = DateTime(currentMonth.year, currentMonth.month, 0).day;
    
    List<DateTime?> days = [];
    
    // Previous month days
    for (int i = firstDay.weekday % 7; i > 0; i--) {
      days.add(DateTime(currentMonth.year, currentMonth.month - 1, prevMonthDays - i + 1));
    }
    
    // Current month days
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, i));
    }
    
    // Next month days
    while (days.length % 7 != 0) {
      final nextDay = days.length - firstDay.weekday % 7 - lastDay.day + 1;
      days.add(DateTime(currentMonth.year, currentMonth.month + 1, nextDay));
    }
    
    return days;
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }
}