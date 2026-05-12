import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // format tanggal
import 'package:fl_chart/fl_chart.dart';
import '../database/database_helper.dart';
import 'add_task_screen.dart';
import 'task_list_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _completedCount = 0;
  int _incompleteCount = 0;
  Map<String, int> _chartData = {};

  @override
  void initState() {
    super.initState();
    _loadData(); // ambil data
  }

  Future<void> _loadData() async {
    final completed = await DatabaseHelper.instance.countCompleted();
    final incomplete = await DatabaseHelper.instance.countIncomplete();
    final chartData = await DatabaseHelper.instance.getCompletedPerDay();
    setState(() {
      _completedCount = completed;
      _incompleteCount = incomplete;
      _chartData = chartData;
    });
  }

  String _getTodayString() { // tgl today
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    return formatter.format(now);
  }

  List<BarChartGroupData> _buildChartGroups() {
    final now = DateTime.now();
    List<BarChartGroupData> groups = [];
    for (int i = 6; i >= 0; i--) { // 7 iterasi untuk 7 hari
      final day = now.subtract(Duration(days: i)); // mundur i hari dari hari ini
      final key = day.toIso8601String().substring(0, 10);
      final count = _chartData[key] ?? 0;
      groups.add(
        BarChartGroupData(
          x: 6 - i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: const Color(0xFF4A7C6F),
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }
    return groups;
  }

  List<String> _getDayLabels() {
    final now = DateTime.now();
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    List<String> labels = [];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      labels.add(days[day.weekday - 1]);
    }
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    final dayLabels = _getDayLabels();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: const Color(0xFF4A7C6F),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                'Halo, User! 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              Text(
                _getTodayString(),
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'TUGAS SELESAI',
                      value: '$_completedCount',
                      valueColor: const Color(0xFF4A7C6F),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'BELUM SELESAI',
                      value: '$_incompleteCount',
                      valueColor: Colors.red[700]!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Chart
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TUGAS SELESAI / HARI [BONUS]',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 140,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (_chartData.values.isEmpty
                                  ? 5
                                  : (_chartData.values.reduce(
                                              (a, b) => a > b ? a : b) +
                                          2))
                              .toDouble(),
                          barGroups: _buildChartGroups(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx >= 0 && idx < dayLabels.length) {
                                    return Text(
                                      dayLabels[idx],
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 24,
                                getTitlesWidget: (value, meta) {
                                  if (value == value.roundToDouble()) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey[200]!,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4 Navigation Buttons
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _NavButton(
                    label: 'Tambah Tugas\nPenting',
                    icon: Icons.add,
                    color: const Color(0xFFD32F2F),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AddTaskScreen(category: 'penting'),
                        ),
                      );
                      _loadData();
                    },
                  ),
                  _NavButton(
                    label: 'Tambah Tugas\nBiasa',
                    icon: Icons.add,
                    color: const Color(0xFF4A7C6F),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AddTaskScreen(category: 'biasa'),
                        ),
                      );
                      _loadData();
                    },
                  ),
                  _NavButton(
                    label: 'Daftar Tugas',
                    icon: Icons.list_alt,
                    color: const Color(0xFF1565C0),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TaskListScreen(),
                        ),
                      );
                      _loadData();
                    },
                  ),
                  _NavButton(
                    label: 'Pengaturan',
                    icon: Icons.settings,
                    color: const Color(0xFF424242),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget { // tombol navigasi
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D2D2D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
