import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../user_details_page.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;
  final bool isGrid;

  const UserCardWidget({super.key, required this.user, required this.isGrid});

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return _buildGridItem(context);
    } else {
      return _buildListItem(context);
    }
  }

  Widget _buildGridItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UserDetailPage(userId: user.id)),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'user_${user.id}',
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
                radius: 40,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${user.firstName} ${user.lastName}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: Hero(
          tag: 'user_${user.id}',
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.avatar),
            radius: 26,
          ),
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(user.email),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserDetailPage(userId: user.id)),
          );
        },
      ),
    );
  }
}
