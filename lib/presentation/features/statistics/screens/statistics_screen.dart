import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/domain/entities/typing_record.dart';
import 'package:typing_talk/presentation/features/statistics/viewmodels/statistics_view_model.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends BaseScreen {
  const StatisticsScreen({super.key});

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statisticsViewModelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 전체 통계
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: '평균 속도',
                  value: '${state.averageSpeed.toStringAsFixed(1)}',
                  unit: 'WPM',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: '평균 정확도',
                  value: '${state.averageAccuracy.toStringAsFixed(1)}',
                  unit: '%',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 기간 선택
          Row(
            children: [
              _PeriodButton(
                label: '주간',
                isSelected: state.selectedPeriod == 'week',
                onTap: () => ref.read(statisticsViewModelProvider.notifier).updatePeriod('week'),
              ),
              const SizedBox(width: 8),
              _PeriodButton(
                label: '월간',
                isSelected: state.selectedPeriod == 'month',
                onTap: () => ref.read(statisticsViewModelProvider.notifier).updatePeriod('month'),
              ),
              const SizedBox(width: 8),
              _PeriodButton(
                label: '연간',
                isSelected: state.selectedPeriod == 'year',
                onTap: () => ref.read(statisticsViewModelProvider.notifier).updatePeriod('year'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 그래프
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: state.records.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.typingSpeed,
                      );
                    }).toList(),
                    isCurved: true,
                    color: AppColors.primaryBlue,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 최근 기록
          Text(
            '최근 기록',
            style: AppTypography.h3_6,
          ),
          const SizedBox(height: 12),
          ...state.records.take(5).map((record) => _RecordCard(record: record)),
        ],
      ),
    );
  }

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(
        '타이핑 통계',
        style: AppTypography.h3_6,
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.b3_4.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.h2_7.copyWith(
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: AppTypography.b3_4.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTypography.b3_5.copyWith(
            color: isSelected ? Colors.white : AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final TypingRecord record;

  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${record.typingSpeed.toStringAsFixed(1)} WPM',
                style: AppTypography.b2_6,
              ),
              Text(
                record.createdAt.toString(),
                style: AppTypography.b3_4.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${record.accuracy.toStringAsFixed(1)}%',
            style: AppTypography.b2_6.copyWith(
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
