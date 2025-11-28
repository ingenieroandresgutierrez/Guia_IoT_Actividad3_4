import 'package:flutter/material.dart';

class LedControlCard extends StatelessWidget {
  final bool ledOn;
  final bool loading;
  final bool busy;
  final ValueChanged<bool>? onChanged;

  const LedControlCard({
    super.key,
    required this.ledOn,
    required this.loading,
    required this.busy,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Iluminación ESP32',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loading
                        ? 'Cargando estado...'
                        : ledOn
                            ? 'LED encendido'
                            : 'LED apagado',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: ledOn,
              onChanged: (loading || busy) ? null : onChanged,
            ),
          ],
        ),
      ),
    );
  }
}