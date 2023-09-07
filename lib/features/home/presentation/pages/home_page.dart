import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envelope Budget"),
        actions: [
          IconButton(
            icon: const Icon(Icons.email_outlined),
            onPressed: () {
              context.go('/envelope/add');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => context.go("/envelope"),
                child: const Text("Got to envelopes"))
          ],
        ),
      ),
    );
  }
}
