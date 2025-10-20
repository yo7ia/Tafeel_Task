import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserDetailPage extends StatefulWidget {
  final int userId;
  const UserDetailPage({super.key, required this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final UserRepository _repository = UserRepository();
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final fetchedUser = await _repository.fetchUserDetails(widget.userId);
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching user details: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('User Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : user == null
            ? const Center(
                child: Text(
                  'Failed to load user',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : _buildUserDetail(context),
      ),
    );
  }

  Widget _buildUserDetail(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        SingleChildScrollView(
          padding: const EdgeInsets.only(top: 120, bottom: 40),
          child: Column(
            children: [
              Hero(
                tag: 'user_${user!.id}',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user!.avatar),
                  radius: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${user!.firstName} ${user!.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                user!.email,
                style: const TextStyle(fontSize: 15, color: Colors.white70),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoTile(
                            icon: Icons.person_outline,
                            label: 'Full Name',
                            value: '${user!.firstName} ${user!.lastName}',
                          ),
                          const Divider(color: Colors.white30),
                          _buildInfoTile(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: user!.email,
                          ),
                          const Divider(color: Colors.white30),
                          _buildInfoTile(
                            icon: Icons.badge_outlined,
                            label: 'User ID',
                            value: user!.id.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
