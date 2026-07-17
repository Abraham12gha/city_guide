import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ============================================================
// COLORS
// ============================================================
class AppColors {
  AppColors._();

  static const Color background = Colors.white;
  static const Color primary = Color(0xFF14B8A6); // teal
  static const Color primaryLight = Color(0xFFCCFBF1);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final _firestore = FirebaseFirestore.instance;

  late Future<_DashboardStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _loadStats();
  }

  Future<int> _countOf(String collection) async {
    final snapshot = await _firestore.collection(collection).count().get();
    return snapshot.count ?? 0;
  }

  Future<List<int>> _last7DaysSignups() async {
    final now = DateTime.now();
    final startOfRange = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));

    final snapshot = await _firestore
        .collection('users')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfRange))
        .get();

    final counts = List<int>.filled(7, 0);
    for (final doc in snapshot.docs) {
      final ts = doc.data()['createdAt'];
      if (ts is Timestamp) {
        final date = ts.toDate();
        final dayIndex = DateTime(date.year, date.month, date.day)
            .difference(startOfRange)
            .inDays;
        if (dayIndex >= 0 && dayIndex < 7) counts[dayIndex]++;
      }
    }
    return counts;
  }

  Future<_DashboardStats> _loadStats() async {
    final results = await Future.wait([
      _countOf('users'),
      _countOf('attractions'),
      _countOf('categories'),
      _countOf('notifications'),
      _last7DaysSignups(),
    ]);

    return _DashboardStats(
      totalUsers: results[0] as int,
      totalAttractions: results[1] as int,
      totalCategories: results[2] as int,
      totalNotifications: results[3] as int,
      weeklySignups: results[4] as List<int>,
    );
  }

  Future<void> _refresh() async {
    final future = _loadStats();
    setState(() {
      _statsFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<_DashboardStats>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stats = snapshot.data!;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.1,
                  children: [
                    _StatCard(
                      label: 'Total Users',
                      value: stats.totalUsers,
                      icon: Icons.people_alt_outlined,
                    ),
                    _StatCard(
                      label: 'Total Attractions',
                      value: stats.totalAttractions,
                      icon: Icons.location_on_outlined,
                    ),
                    _StatCard(
                      label: 'Total Categories',
                      value: stats.totalCategories,
                      icon: Icons.category_outlined,
                    ),
                    _StatCard(
                      label: 'Notifications',
                      value: stats.totalNotifications,
                      icon: Icons.notifications_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Signups — last 7 days',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _TrafficChart(dailyCounts: stats.weeklySignups),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DashboardStats {
  final int totalUsers;
  final int totalAttractions;
  final int totalCategories;
  final int totalNotifications;
  final List<int> weeklySignups;

  _DashboardStats({
    required this.totalUsers,
    required this.totalAttractions,
    required this.totalCategories,
    required this.totalNotifications,
    required this.weeklySignups,
  });
}
class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TRAFFIC / SIGNUPS CHART
// ============================================================
class _TrafficChart extends StatelessWidget {
  final List<int> dailyCounts; // 7 values, oldest -> newest

  const _TrafficChart({required this.dailyCounts});

  @override
  Widget build(BuildContext context) {
    final maxValue = dailyCounts.isEmpty
        ? 1
        : (dailyCounts.reduce((a, b) => a > b ? a : b)).clamp(1, 999999);

    final now = DateTime.now();
    final labels = List.generate(7, (i) {
      final date = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[date.weekday - 1];
    });

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: BarChart(
        BarChartData(
          maxY: (maxValue + 1).toDouble(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[index],
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(dailyCounts.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: dailyCounts[i].toDouble(),
                  color: AppColors.primary,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}