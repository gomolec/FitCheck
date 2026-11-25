import 'package:material_ui/material_ui.dart';

/// Placeholder "Ubrania" tab for saved garments.
class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubrania')),
      body: const Center(child: Text('Lista Twoich ubrań — wkrótce')),
    );
  }
}
