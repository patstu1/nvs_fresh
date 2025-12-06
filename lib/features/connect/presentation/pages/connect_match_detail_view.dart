import 'package:flutter/material.dart';
import '../../models/connect_match_model.dart';

class ConnectMatchDetailView extends StatelessWidget {
  const ConnectMatchDetailView({required this.match, super.key});
  final ConnectMatchModel match;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text('Compatibility', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            // Split-Face Match Ring
            Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: <Color>[Color(0xFFA7FFE0), Color(0xFFFF69B4)],
                ),
              ),
              child: ClipOval(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.asset(match.avatarImage, fit: BoxFit.cover),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.black,
                      ), // Placeholder for your image
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              '${match.name}, ${match.age}  •  ${match.role}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              match.astroNotes,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Compatibility score ring
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: match.compatibilityScore / 100,
                    strokeWidth: 8,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFA7FFE0)),
                    backgroundColor: Colors.white12,
                  ),
                ),
                Text(
                  '${match.compatibilityScore.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Shared Tags
            Wrap(
              spacing: 8,
              children: match.sharedTags.map((String tag) {
                return Chip(
                  label: Text(tag, style: const TextStyle(color: Colors.black)),
                  backgroundColor: const Color(0xFFB0FF5A),
                );
              }).toList(),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA7FFE0),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Message Now'),
            ),
          ],
        ),
      ),
    );
  }
}
