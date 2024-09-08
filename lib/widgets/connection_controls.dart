import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:p2p_chat/providers/chat_provider.dart';

class ConnectionControls extends StatelessWidget {
  const ConnectionControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => chatProvider.createOffer(),
              icon: const Icon(Icons.add),
              label: const Text('Create'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary, // Updated from 'primary' to 'backgroundColor'
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Implement join connection functionality
              },
              icon: const Icon(Icons.link),
              label: const Text('Join'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .secondary, // Updated from 'primary' to 'backgroundColor'
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: chatProvider.isConnected ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                chatProvider.isConnected ? 'Connected' : 'Disconnected',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
