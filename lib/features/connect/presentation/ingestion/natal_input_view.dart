// lib/features/connect/presentation/ingestion/natal_input_view.dart

import 'package:flutter/material.dart';

class NatalInputView extends StatelessWidget {
  const NatalInputView({super.key});

  @override
  Widget build(BuildContext context) {
    // This would be a more sophisticated form with date/time/location pickers
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'DEFINE YOUR COSMIC SIGNATURE',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(letterSpacing: 2),
            ),
            const SizedBox(height: 20),
            Text(
              'The Synaptic Core requires your precise time and location of birth\nto simulate your unique quantum potential.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[400]),
            ),
            const SizedBox(height: 40),
            // ... (Input fields for Date, Time, and Location of Birth) ...
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 1. Get data from form.
                // 2. Call the mutation to the backend to generate the signature.
                // 3. On success, navigate to the Synaptic Radar view.
              },
              child: const Text('CALCULATE & PROCEED'),
            ),
          ],
        ),
      ),
    );
  }
}
