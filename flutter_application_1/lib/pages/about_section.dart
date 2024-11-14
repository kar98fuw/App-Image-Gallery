import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String photoUrl;
  final String firstName;
  final String lastName;
  final String badgeNumber;
  final String reflection;

  const AboutSection({
    super.key,
    required this.photoUrl,
    required this.firstName,
    required this.lastName,
    required this.badgeNumber,
    required this.reflection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acerca de"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photoUrl),
            ),
            const SizedBox(height: 16),
            Text(
              "$firstName $lastName",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Matrícula: $badgeNumber",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                reflection,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
