import 'package:flutter/material.dart';
import 'app/app.dart';
import 'providers/app_provider.dart';
import 'repositories/demo_energy_repository.dart';

void main() { WidgetsFlutterBinding.ensureInitialized(); final repository = DemoEnergyRepository(); runApp(SmartFluxApp(provider: AppProvider(repository))); }
