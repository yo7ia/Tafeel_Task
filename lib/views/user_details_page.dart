import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tafeel_task/repositories/user_repository.dart';

import '../blocs/user_details/user_details_bloc.dart';
import '../blocs/user_details/user_details_event.dart';
import '../blocs/user_details/user_details_state.dart';

class UserDetailsPage extends StatelessWidget {
  final int userId;

  const UserDetailsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UserDetailBloc(UserRepository())..add(FetchUserDetail(userId)),
      child: const _UserDetailView(),
    );
  }
}

class _UserDetailView extends StatelessWidget {
  const _UserDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('User Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<UserDetailBloc, UserDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Text(
                'Failed to load user\n${state.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          if (state.user == null) {
            return const Center(
              child: Text(
                'User not found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final user = state.user!;
          return _buildUserDetail(context, user);
        },
      ),
    );
  }

  Widget _buildUserDetail(BuildContext context, dynamic user) {
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
                tag: 'user_${user.id}',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar),
                  radius: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                user.email,
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
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            icon: Icons.person_outline,
                            label: 'Full Name',
                            value: '${user.firstName} ${user.lastName}',
                          ),
                          const Divider(color: Colors.white30),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: user.email,
                          ),
                          const Divider(color: Colors.white30),
                          _buildInfoRow(
                            icon: Icons.badge_outlined,
                            label: 'User ID',
                            value: user.id.toString(),
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

  Widget _buildInfoRow({
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
