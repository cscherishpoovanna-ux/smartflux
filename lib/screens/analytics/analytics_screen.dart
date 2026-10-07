import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/constants/app_colors.dart';
import '../../core/enums/app_enums.dart';
import '../../models/energy_models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/charts/line_chart.dart';
import '../../widgets/common/app_header.dart';

/// Selectable visualization modes for the analytics view.
enum VisualizationType { line, bar, donut }

extension VisualizationTypeLabel on VisualizationType {
  String get label => switch (this) {
        VisualizationType.line => 'Line',
        VisualizationType.bar => 'Bar',
        VisualizationType.donut => 'Donut',
      };
}

class AnalyticsScreen extends StatefulWidget {
  final AppProvider provider;

  const AnalyticsScreen({
    super.key,
    required this.provider,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // Only the three requested time filters are exposed to the user.
  static const List<TimeRange> _allowedRanges = [
    TimeRange.today,
    TimeRange.days7,
    TimeRange.days30,
  ];

  TimeRange _selectedRange = TimeRange.today;
  VisualizationType _visualization = VisualizationType.line;
  String? _selectedRoomId;

  @override
  Widget build(BuildContext context) {
    final rooms = widget.provider.rooms;
    final loads = widget.provider.loads;
    final events = widget.provider.optimizationEvents;

    return ListView(
      padding: const EdgeInsets.only(bottom: 30),
      children: [
        const AppHeader(
          title: 'Analytics',
          subtitle: 'Trends derived from the same monitoring data',
        ),
        _TimeRangeFilter(
          ranges: _allowedRanges,
          selected: _selectedRange,
          onSelected: (r) => setState(() => _selectedRange = r),
        ),
        _VisualizationSelector(
          type: _visualization,
          onSelected: (t) => setState(() => _visualization = t),
        ),
        if (_visualization == VisualizationType.bar ||
            _visualization == VisualizationType.donut)
          _RoomFilter(
            rooms: rooms,
            selectedId: _selectedRoomId,
            onSelected: (v) => setState(() => _selectedRoomId = v),
          ),
        _ChartSection(
          visualization: _visualization,
          range: _selectedRange,
          provider: widget.provider,
          rooms: rooms,
          loads: loads,
          selectedRoomId: _selectedRoomId,
        ),
        const _Spacer(),
        _IndicatorsSection(
          range: _selectedRange,
          provider: widget.provider,
          events: events,
        ),
      ],
    );
  }
}

class _TimeRangeFilter extends StatelessWidget {
  final List<TimeRange> ranges;
  final TimeRange selected;
  final ValueChanged<TimeRange> onSelected;

  const _TimeRangeFilter({
    required this.ranges,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: ranges.map(
          (r) {
            final isSelected = selected == r;
            return ChoiceChip(
              label: Text(_label(r)),
              selected: isSelected,
              onSelected: (_) => onSelected(r),
              selectedColor: AppColors.primary.withValues(alpha: .16),
              backgroundColor: theme.cardColor,
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : theme.dividerColor.withValues(alpha: .35),
              ),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : onSurface,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  String _label(TimeRange r) {
    return switch (r) {
      TimeRange.today => 'Today',
      TimeRange.days7 => '7 Days',
      TimeRange.days30 => '30 Days',
      _ => r.name,
    };
  }
}

class _VisualizationSelector extends StatelessWidget {
  final VisualizationType type;
  final ValueChanged<VisualizationType> onSelected;

  const _VisualizationSelector({
    required this.type,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          Text(
            'Visualization',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...VisualizationType.values.map(
                    (t) {
                      final isSelected = type == t;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(t.label),
                          selected: isSelected,
                          onSelected: (_) => onSelected(t),
                          selectedColor: AppColors.primary.withValues(alpha: .16),
                          backgroundColor: theme.cardColor,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : theme.dividerColor.withValues(alpha: .35),
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomFilter extends StatelessWidget {
  final List<RoomModel> rooms;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  const _RoomFilter({
    required this.rooms,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: DropdownButtonFormField<String?>(
        initialValue: selectedId,
        dropdownColor: theme.cardColor,
        iconEnabledColor: onSurface,
        style: TextStyle(color: onSurface, fontSize: 14),
        decoration: InputDecoration(
          labelText: 'Room / zone',
          labelStyle: TextStyle(color: onSurface.withValues(alpha: 0.7)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: .4)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('All rooms'),
          ),
          ...rooms.where((r) => r.connected).map(
            (r) => DropdownMenuItem<String?>(
              value: r.id,
              child: Text(r.name),
            ),
          ),
        ],
        onChanged: (v) => onSelected(v),
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final VisualizationType visualization;
  final TimeRange range;
  final AppProvider provider;
  final List<RoomModel> rooms;
  final List<LoadModel> loads;
  final String? selectedRoomId;

  const _ChartSection({
    required this.visualization,
    required this.range,
    required this.provider,
    required this.rooms,
    required this.loads,
    required this.selectedRoomId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: switch (visualization) {
        VisualizationType.line => _LineChartCard(range: range, provider: provider),
        VisualizationType.bar => _RoomLoadBarChart(
            rooms: rooms,
            loads: loads,
            selectedRoomId: selectedRoomId,
            range: range,
          ),
        VisualizationType.donut => _RoomLoadDonutChart(
            rooms: rooms,
            loads: loads,
            selectedRoomId: selectedRoomId,
            range: range,
          ),
      },
    );
  }
}

/// Line chart: energy consumption over time (same underlying demo data, time series).
class _LineChartCard extends StatelessWidget {
  final TimeRange range;
  final AppProvider provider;

  const _LineChartCard({required this.range, required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<List<ReadingPoint>>(
      future: provider.repository.history(metric: 'energy', range: range),
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return Container(
            height: 240,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (s.hasError) {
          return Container(
            height: 240,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Unable to load analytics.',
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SmartLineChart(
            points: s.data ?? const [],
            color: AppColors.primary,
            unit: 'kWh',
          ),
        );
      },
    );
  }
}

/// Bar chart: compare energy consumption between rooms/loads (snapshot & demo data).
class _RoomLoadBarChart extends StatelessWidget {
  final List<RoomModel> rooms;
  final List<LoadModel> loads;
  final String? selectedRoomId;
  final TimeRange range;

  const _RoomLoadBarChart({
    required this.rooms,
    required this.loads,
    required this.selectedRoomId,
    required this.range,
  });

  List<({String name, double value})> _getDataItems() {
    final double rangeFactor = switch (range) {
      TimeRange.today => 1.0,
      TimeRange.days7 => 6.8,
      TimeRange.days30 => 29.5,
      _ => 1.0,
    };

    if (selectedRoomId == null) {
      final connectedRooms = rooms.where((r) => r.connected).toList();
      return connectedRooms.map((r) {
        final roomLoads = loads.where((l) => l.roomId == r.id && l.state == LoadState.on);
        final power = r.powerW > 0
            ? r.powerW
            : roomLoads.fold(0.0, (sum, l) => sum + l.powerW);
        final baseEnergy = (power / 1000.0) * 4.2;
        final val = max(0.15, baseEnergy * rangeFactor);
        return (name: r.name, value: double.parse(val.toStringAsFixed(2)));
      }).toList();
    } else {
      final roomLoads = loads.where((l) => l.roomId == selectedRoomId).toList();
      final target = roomLoads.isNotEmpty ? roomLoads : loads;
      return target.map((l) {
        final power = l.state == LoadState.on
            ? (l.powerW > 0 ? l.powerW : 120.0)
            : 0.0;
        final baseEnergy = (power / 1000.0) * 4.2;
        final val = max(power > 0 ? 0.1 : 0.0, baseEnergy * rangeFactor);
        return (name: l.name, value: double.parse(val.toStringAsFixed(2)));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dividerColor = theme.dividerColor;
    final items = _getDataItems();
    final titles = items.map((e) => e.name).toList();

    final maxY = items.fold<double>(0, (maxVal, item) => item.value > maxVal ? item.value : maxVal);

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'No room data available.',
            style: TextStyle(color: onSurface.withValues(alpha: 0.7)),
          ),
        ),
      );
    }

    final adjustedMaxY = maxY > 0 ? maxY * 1.2 : 1.0;
    final interval = max(0.5, adjustedMaxY / 4);

    final groups = items.asMap().entries.map((e) {
      final idx = e.key;
      final item = e.value;
      return BarChartGroupData(
        x: idx,
        barRods: [
          BarChartRodData(
            toY: item.value,
            color: AppColors.primary,
            width: 24,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 8),
            child: Text(
              'Energy Consumption (kWh)',
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.65),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 210,
            child: BarChart(
              BarChartData(
                maxY: adjustedMaxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBorderRadius: BorderRadius.circular(8),
                    getTooltipColor: (_) => theme.cardColor,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      if (groupIndex < 0 || groupIndex >= titles.length) return null;
                      return BarTooltipItem(
                        '${titles[groupIndex]}\n${rod.toY.toStringAsFixed(2)} kWh',
                        const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= titles.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            titles[idx],
                            style: TextStyle(
                              color: onSurface,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.min || value == meta.max) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            value.toStringAsFixed(value < 10 ? 1 : 0),
                            style: TextStyle(
                              color: onSurface.withValues(alpha: 0.55),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: dividerColor.withValues(alpha: 0.12),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: groups,
                groupsSpace: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Donut chart: percentage distribution of energy consumption between rooms/loads.
class _RoomLoadDonutChart extends StatelessWidget {
  final List<RoomModel> rooms;
  final List<LoadModel> loads;
  final String? selectedRoomId;
  final TimeRange range;

  const _RoomLoadDonutChart({
    required this.rooms,
    required this.loads,
    required this.selectedRoomId,
    required this.range,
  });

  static const _sectionColors = [
    AppColors.primary,
    AppColors.info,
    AppColors.warning,
    AppColors.success,
    Color(0xFF9C27B0),
    Color(0xFFFF6D00),
  ];

  List<({String name, double value})> _getDataItems() {
    if (selectedRoomId == null) {
      final connectedRooms = rooms.where((r) => r.connected).toList();
      return connectedRooms.map((r) {
        final roomLoads = loads.where((l) => l.roomId == r.id && l.state == LoadState.on);
        final power = r.powerW > 0
            ? r.powerW
            : roomLoads.fold(0.0, (sum, l) => sum + l.powerW);
        return (name: r.name, value: max(10.0, power));
      }).toList();
    } else {
      final roomLoads = loads.where((l) => l.roomId == selectedRoomId).toList();
      final target = roomLoads.isNotEmpty ? roomLoads : loads;
      return target.map((l) {
        final power = l.state == LoadState.on
            ? (l.powerW > 0 ? l.powerW : 110.0)
            : 5.0;
        return (name: l.name, value: power);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final items = _getDataItems();
    final total = items.fold<double>(0, (sum, e) => sum + e.value);

    if (items.isEmpty || total <= 0) {
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'No room data available.',
            style: TextStyle(color: onSurface.withValues(alpha: 0.7)),
          ),
        ),
      );
    }

    final sections = items.asMap().entries.map((e) {
      final idx = e.key;
      final item = e.value;
      final color = _sectionColors[idx % _sectionColors.length];
      final pct = (item.value / total) * 100;
      return (
        section: PieChartSectionData(
          value: item.value,
          title: '${pct.toStringAsFixed(1)}%',
          color: color,
          radius: 65,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        name: item.name,
        value: item.value,
        pct: pct,
        color: color,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 55,
                sections: sections.map((s) => s.section).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...sections.map(
            (s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: s.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s.name,
                      style: TextStyle(
                        color: onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '${s.value.toStringAsFixed(0)} W (${s.pct.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      color: onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorsSection extends StatelessWidget {
  final TimeRange range;
  final AppProvider provider;
  final List<OptimizationEvent> events;

  const _IndicatorsSection({
    required this.range,
    required this.provider,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return FutureBuilder<List<List<ReadingPoint>>>(
      future: Future.wait([
        provider.repository.history(metric: 'power', range: range),
        provider.repository.history(metric: 'energy', range: range),
      ]),
      builder: (context, snapshot) {
        final hasData = snapshot.hasData && snapshot.data != null;
        final powerPoints = hasData ? snapshot.data![0] : const <ReadingPoint>[];
        final energyPoints = hasData ? snapshot.data![1] : const <ReadingPoint>[];

        final double peakDemand = powerPoints.isEmpty
            ? 0.0
            : powerPoints.map((p) => p.value).reduce(max);

        final double avgDemand = powerPoints.isEmpty
            ? 0.0
            : powerPoints.map((p) => p.value).reduce((a, b) => a + b) / powerPoints.length;

        final double totalEnergy = energyPoints.fold<double>(
            0.0, (sum, p) => sum + p.value);

        final duration = switch (range) {
          TimeRange.today => const Duration(hours: 24),
          TimeRange.days7 => const Duration(days: 7),
          TimeRange.days30 => const Duration(days: 30),
          _ => const Duration(hours: 24),
        };
        final cutoff = DateTime.now().subtract(duration);
        final periodEvents = events.where((e) => e.timestamp.isAfter(cutoff)).toList();
        final eventSavings = periodEvents.fold<double>(
          0.0,
          (sum, e) => sum + max(0.0, (e.demandBeforeW - e.demandAfterW) / 1000.0 * 2.0),
        );
        final double energySaved = (totalEnergy * 0.085) + eventSavings;

        final stats = <_Stat>[
          _Stat(
            title: 'Peak Demand',
            value: hasData
                ? (peakDemand >= 1000
                    ? '${(peakDemand / 1000).toStringAsFixed(2)} kW'
                    : '${peakDemand.toStringAsFixed(0)} W')
                : '--',
          ),
          _Stat(
            title: 'Average Demand',
            value: hasData
                ? (avgDemand >= 1000
                    ? '${(avgDemand / 1000).toStringAsFixed(2)} kW'
                    : '${avgDemand.toStringAsFixed(0)} W')
                : '--',
          ),
          _Stat(
            title: 'Total Energy',
            value: hasData ? '${totalEnergy.toStringAsFixed(2)} kWh' : '--',
          ),
          _Stat(
            title: 'Energy Saved',
            value: hasData ? '${energySaved.toStringAsFixed(2)} kWh' : '--',
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Text(
                'Key indicators',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: onSurface,
                ),
              ),
            ),
            _IndicatorRow(stats: stats),
          ],
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String title;
  final String value;

  const _Stat({required this.title, required this.value});

  @override
  Widget build(BuildContext c) {
    final theme = Theme.of(c);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: .35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: onSurface.withValues(alpha: 0.65),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  final List<_Stat> stats;

  const _IndicatorRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = width > 600 ? 4 : 2;
          final itemWidth = (width - (columns - 1) * 12) / columns;

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: stats
                .map((stat) => SizedBox(width: itemWidth, child: stat))
                .toList(),
          );
        },
      ),
    );
  }
}

class _Spacer extends StatelessWidget {
  const _Spacer();
  @override
  Widget build(BuildContext context) => const SizedBox(height: 12);
}
