import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShadowBox extends StatefulWidget {
  final Widget? child;
  const ShadowBox({super.key, required this.child});

  @override
  State<ShadowBox> createState() => _ShadowBoxState();
}

class _ShadowBoxState extends State<ShadowBox> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal:5,vertical:5),
      // padding: EdgeInsets.all(8.r),
      child: widget.child,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade500,
                offset: Offset(5.w, 5.h),
                blurRadius: 5.r),
            BoxShadow(
                color: Color.fromARGB(190, 255, 255, 255),
                offset: Offset(-5.w, -5.h),
                blurRadius: 5.r),
          ]),
    );
  }
}
