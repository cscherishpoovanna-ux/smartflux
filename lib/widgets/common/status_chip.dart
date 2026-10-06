import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/enums/app_enums.dart';

class StatusChip extends StatelessWidget { final SystemStatus status; const StatusChip({super.key, required this.status});
  @override Widget build(BuildContext context) { final (text, color) = switch (status) { SystemStatus.normal => ('System normal', AppColors.success), SystemStatus.highDemand => ('High demand', AppColors.warning), SystemStatus.overload => ('Overload', AppColors.critical), SystemStatus.offline => ('Offline', AppColors.disabled) }; return Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 7), Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12))])); }
}
