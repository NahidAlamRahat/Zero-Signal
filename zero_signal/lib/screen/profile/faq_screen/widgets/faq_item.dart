import 'package:flutter/material.dart';
import '../../../../constant/app_colors.dart';
import '../../../../widget/text_widget/text_widgets.dart';

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.overLayBoxColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleExpanded,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextWidget(
                            text: widget.question,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontColor: AppColor.blackColor,
                            textAlignment: TextAlign.start,
                          ),
                        ),
                        const SizedBox(width: 12),
                        RotationTransition(
                          turns: _iconRotation,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor.backgroundColor,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedSize(

                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _isExpanded
                    ? Container(

                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        decoration: BoxDecoration(

                          color: AppColor.overLayBoxColor,
                          border: Border(
                            top: BorderSide(
                              color: AppColor.soilColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: TextWidget(
                          text: widget.answer,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontColor: AppColor.blackColor,
                          textAlignment: TextAlign.start,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
