import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:p2p_chat/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({Key? key}) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'profile_picture.png';
      final savedImage =
          await File(pickedFile.path).copy('${directory.path}/$fileName');

      Provider.of<UserProvider>(context, listen: false)
          .setProfilePicture(savedImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _pickImage(context),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: userProvider.profilePicture.isNotEmpty
                      ? FileImage(File(userProvider.profilePicture))
                      : null,
                  child: userProvider.profilePicture.isEmpty
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
            onChanged: (value) => userProvider.setUsername(value),
            controller: TextEditingController(text: userProvider.username),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('User ID'),
              subtitle: Text(userProvider.userId),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  // Implement copy to clipboard functionality
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save Changes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primary, // Updated 'primary' to 'backgroundColor'
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
