import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:p2p_chat/providers/chat_provider.dart';
import 'package:p2p_chat/providers/user_provider.dart';

class ChatArea extends StatelessWidget {
  const ChatArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final TextEditingController _messageController = TextEditingController();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: chatProvider.messages.length,
            itemBuilder: (context, index) {
              final message = chatProvider.messages[index];
              final isCurrentUser = message['sender'] == userProvider.userId;

              return Align(
                alignment: isCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                message['profilePicture'].isNotEmpty
                                    ? FileImage(File(message['profilePicture']))
                                    : null,
                            child: message['profilePicture'].isEmpty
                                ? const Icon(Icons.person, size: 16)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            message['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(message['content']),
                      const SizedBox(height: 4),
                      Text(
                        _formatTimestamp(message['timestamp']),
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).textTheme.caption?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    chatProvider.sendMessage(
                      userProvider.userId,
                      userProvider.username,
                      _messageController.text,
                      userProvider.profilePicture,
                    );
                    _messageController.clear();
                  }
                },
                child: const Icon(Icons.send),
                mini: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
