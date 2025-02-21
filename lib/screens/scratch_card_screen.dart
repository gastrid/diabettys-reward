    import 'package:flutter/material.dart';

    class ScratchCardScreen extends StatelessWidget {
      const ScratchCardScreen({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Scratch Card'),
          ),
          body: Center(
            child: const Text('Scratch Card Screen'),
          ),
        );
      }
    }