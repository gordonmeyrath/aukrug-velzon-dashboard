import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Demo-Simulation der neuen Community-Zugriffslogik
class DemoCommunityAccess extends ConsumerWidget {
  const DemoCommunityAccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Access Demo'),
        backgroundColor: Colors.green,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✅ Community Access für ALLE Benutzer aktiviert!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),

            _AccessDemo(
              userType: 'Nicht-eingeloggt',
              canAccess: true,
              canWrite: false,
              description: 'Kann Community ansehen, aber nicht schreiben',
            ),

            SizedBox(height: 10),

            _AccessDemo(
              userType: 'Eingeloggt',
              canAccess: true,
              canWrite: true,
              description: 'Kann Community ansehen und Inhalte erstellen',
            ),

            SizedBox(height: 30),

            Text(
              'Implementierte Änderungen:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text(
              '• canAccessCommunityProvider: Prüft nur noch Feature-Flag, keine Authentifizierung',
            ),
            Text(
              '• canWriteInCommunityProvider: Neue Provider für Schreibzugriff (nur für eingeloggte Benutzer)',
            ),
            Text(
              '• Community UI: Zeigt Login-Aufforderung für nicht-authentifizierte Benutzer bei Schreibaktionen',
            ),
            Text(
              '• Berechtigung: Lesen = öffentlich, Schreiben = nur eingeloggte Benutzer',
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessDemo extends StatelessWidget {
  final String userType;
  final bool canAccess;
  final bool canWrite;
  final String description;

  const _AccessDemo({
    required this.userType,
    required this.canAccess,
    required this.canWrite,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Benutzer: $userType',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                canAccess ? Icons.check_circle : Icons.cancel,
                color: canAccess ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text('Community ansehen: ${canAccess ? "✓" : "✗"}'),
            ],
          ),
          Row(
            children: [
              Icon(
                canWrite ? Icons.check_circle : Icons.cancel,
                color: canWrite ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text('Inhalte erstellen: ${canWrite ? "✓" : "✗"}'),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Community Access Demo',
        home: const DemoCommunityAccess(),
      ),
    ),
  );
}
