import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PotGauge extends StatelessWidget {
  final double percent;
  final int rawValue;
  final DateTime timestamp;

  const PotGauge({
    super.key,
    required this.percent,
    required this.rawValue,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final displayPercent = percent.clamp(0.0, 100.0);
    final tsString = timestamp.toLocal().toString().split('.').first;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Valor del potenciómetro',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: SleekCircularSlider(
            min: 0,
            max: 100,
            initialValue: displayPercent,
            appearance: CircularSliderAppearance(
              customWidths: CustomSliderWidths(
                progressBarWidth: 16,
                trackWidth: 8,
              ),
              customColors: CustomSliderColors(
                trackColor: Colors.grey.shade300,
                progressBarColor: Colors.teal,
                dotColor: Colors.tealAccent,
              ),
              startAngle: 150,
              angleRange: 240,
              size: 250,
            ),
            innerWidget: (value) {
              final v = value.clamp(0, 100).toDouble();
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${v.toStringAsFixed(0)}%',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '($rawValue / 4095)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Última actualización: $tsString',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }
}