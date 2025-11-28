
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/pot_reading.dart';
import '../services/supabase_service.dart';
import 'widgets/led_control_card.dart';
import 'widgets/pot_gauge.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SupabaseService _service = SupabaseService.instance;

  bool _ledOn = false;
  bool _loadingLed = true;
  bool _togglingLed = false;

  @override
  void initState() {
    super.initState();
    _loadInitialLedState();
  }

  Future<void> _loadInitialLedState() async {
    try {
      final state = await _service.getLedState();
      setState(() {
        _ledOn = state;
        _loadingLed = false;
      });
    } catch (e) {
      setState(() => _loadingLed = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando estado del LED: $e')),
      );
    }
  }

  Future<void> _toggleLed(bool value) async {
    setState(() => _togglingLed = true);
    try {
      final newState = await _service.setLedState(value);
      setState(() => _ledOn = newState);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error actualizando LED: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _togglingLed = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final potStream = _service.potStream();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Monitor Potenciómetro – ESP32',
          style: GoogleFonts.comfortaa(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<PotReading>(
                stream: potStream,
                builder: (context, snapshot) {
                  log('Connection State: ${snapshot.connectionState}');
                  if (snapshot.hasData) {
                    log('Data: ${snapshot.data}');
                  }
                  if (snapshot.hasError) {
                    log('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error en realtime:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final reading = snapshot.data;

                  if (reading == null) {
                    return const Center(
                      child: Text(
                        'Aún no hay lecturas del potenciómetro.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return PotGauge(
                    percent: reading.percent,
                    rawValue: reading.rawValue,
                    timestamp: reading.createdAt,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            LedControlCard(
              ledOn: _ledOn,
              loading: _loadingLed,
              busy: _togglingLed,
              onChanged: (_loadingLed || _togglingLed) ? null : _toggleLed,
            ),
          ],
        ),
      ),
    );
  }
}
