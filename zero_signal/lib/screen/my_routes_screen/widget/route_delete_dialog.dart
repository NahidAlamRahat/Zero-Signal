import 'package:flutter/material.dart';

import '../model/route_model.dart';

class RouteDeleteDialog extends StatelessWidget {
  final RouteData route;
  final VoidCallback onConfirm;

  const RouteDeleteDialog({
    Key? key,
    required this.route,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Route'),
      content: Text('Are you sure you want to delete "${route.title}"?'),
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
