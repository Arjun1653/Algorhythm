import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/usecases/build_heatmap_data.dart';

class HeatmapWidget extends StatelessWidget {
  final Map<DateTime, int> data;

  const HeatmapWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _HeatmapGrid(data: data, isDark: isDark),
          ),
          const SizedBox(height: 8),
          _Legend(isDark: isDark),
        ],
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  final Map<DateTime, int> data;
  final bool isDark;

  const _HeatmapGrid({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;

    // Build 53 weeks × 7 days grid ending today
    final today = DateTime.now();
    final todayNorm =
        DateTime(today.year, today.month, today.day);
    // Start on the Sunday 52 weeks ago
    final startOffset = (todayNorm.weekday % 7); // days since last Sunday
    final gridStart =
        todayNorm.subtract(Duration(days: startOffset + 52 * 7));

    const cellSize = 11.0;
    const cellGap = 2.0;
    const monthLabelHeight = 16.0;

    // Pre-compute month labels
    final monthLabels = <int, String>{}; // column index → month abbrev
    for (var col = 0; col < 53; col++) {
      final date = gridStart.add(Duration(days: col * 7));
      if (date.day <= 7) {
        monthLabels[col] = _monthAbbrev(date.month);
      }
    }

    return SizedBox(
      width: 53 * (cellSize + cellGap) + 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month labels row
          SizedBox(
            height: monthLabelHeight,
            child: Stack(
              children: monthLabels.entries.map((e) {
                return Positioned(
                  left: e.key * (cellSize + cellGap),
                  child: Text(
                    e.value,
                    style: AppTextStyles.mono11.copyWith(
                        color: text3, fontSize: 9),
                  ),
                );
              }).toList(),
            ),
          ),
          // Grid
          CustomPaint(
            size: Size(
              53 * (cellSize + cellGap),
              7 * (cellSize + cellGap),
            ),
            painter: _HeatmapPainter(
              data: data,
              gridStart: gridStart,
              isDark: isDark,
              cellSize: cellSize,
              cellGap: cellGap,
            ),
          ),
        ],
      ),
    );
  }

  String _monthAbbrev(int month) {
    const abbrevs = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return abbrevs[month];
  }
}

class _HeatmapPainter extends CustomPainter {
  final Map<DateTime, int> data;
  final DateTime gridStart;
  final bool isDark;
  final double cellSize;
  final double cellGap;

  // Cache paints for the 4 intensity levels
  late final List<Paint> _paints;

  _HeatmapPainter({
    required this.data,
    required this.gridStart,
    required this.isDark,
    required this.cellSize,
    required this.cellGap,
  }) {
    final colors = isDark
        ? [AppColors.darkHeat0, AppColors.darkHeat1, AppColors.darkHeat2, AppColors.darkHeat3]
        : [AppColors.lightHeat0, AppColors.lightHeat1, AppColors.lightHeat2, AppColors.lightHeat3];

    _paints = colors.map((c) => Paint()..color = c).toList();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    for (var col = 0; col < 53; col++) {
      for (var row = 0; row < 7; row++) {
        final date = gridStart.add(Duration(days: col * 7 + row));
        if (date.isAfter(todayNorm)) continue;

        final count = data[date] ?? 0;
        final level = HeatmapData.intensity(count);

        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            col * (cellSize + cellGap),
            row * (cellSize + cellGap),
            cellSize,
            cellSize,
          ),
          const Radius.circular(2),
        );

        canvas.drawRRect(rect, _paints[level]);
      }
    }
  }

  @override
  bool shouldRepaint(_HeatmapPainter old) =>
      old.data != data || old.isDark != isDark;
}

class _Legend extends StatelessWidget {
  final bool isDark;

  const _Legend({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final text3 = isDark ? AppColors.darkText3 : AppColors.lightText3;
    final heatColors = isDark
        ? [AppColors.darkHeat0, AppColors.darkHeat1, AppColors.darkHeat2, AppColors.darkHeat3]
        : [AppColors.lightHeat0, AppColors.lightHeat1, AppColors.lightHeat2, AppColors.lightHeat3];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Less', style: AppTextStyles.mono11.copyWith(color: text3, fontSize: 9)),
        const SizedBox(width: 4),
        ...heatColors.map((c) => Container(
              width: 11,
              height: 11,
              margin: const EdgeInsets.only(left: 2),
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(2),
              ),
            )),
        const SizedBox(width: 4),
        Text('More', style: AppTextStyles.mono11.copyWith(color: text3, fontSize: 9)),
      ],
    );
  }
}
