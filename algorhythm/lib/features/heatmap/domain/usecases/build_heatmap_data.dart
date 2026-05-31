class HeatmapData {
  final Map<DateTime, int> counts; // date (midnight) → solve count
  final int totalActiveDays;

  const HeatmapData({required this.counts, required this.totalActiveDays});

  /// Intensity bucket: 0 = none, 1 = 1–2, 2 = 3–5, 3 = 6+
  static int intensity(int count) {
    if (count == 0) return 0;
    if (count <= 2) return 1;
    if (count <= 5) return 2;
    return 3;
  }
}

class BuildHeatmapData {
  BuildHeatmapData();

  HeatmapData call(Map<DateTime, int> rawCounts) {
    final activeDays = rawCounts.values.where((c) => c > 0).length;
    return HeatmapData(counts: rawCounts, totalActiveDays: activeDays);
  }
}
