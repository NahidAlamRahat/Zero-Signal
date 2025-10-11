import 'package:flutter/material.dart';

import '../../favorite_sites_screen/favorite_sites_screen.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final SpotItem spot;
  final VoidCallback onConfirm;

  const DeleteConfirmDialog({
    Key? key,
    required this.spot,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Spot'),
      content: Text('Are you sure you want to delete "${spot.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}