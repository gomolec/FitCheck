import 'package:material_ui/material_ui.dart';

/// Placeholder "Wymiary" screen opened from Settings.
class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wymiary')),
      body: const Center(child: Text('Twoje wymiary — wkrótce')),
    );
  }
}
