import 'package:flutter/material.dart';

Widget customInviteCard({
  required int index,
  required String groupName,
  required int inviteId,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 3.0 : 10.0,
                horizontal: isSmallScreen ? 3.0 : 10.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      ' invitation to $groupName.',
                      style: TextStyle(fontSize: 12)
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          debugPrint('$inviteId');
                          //! handle accept invitation
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          debugPrint('$inviteId');
                          //! handle decline invitation
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
