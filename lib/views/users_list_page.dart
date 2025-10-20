import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tafeel_task/repositories/user_repository.dart';
import 'package:tafeel_task/views/widgets/custom_footer_style.dart';
import 'package:tafeel_task/views/widgets/no_more_users.dart';
import 'package:tafeel_task/views/widgets/user_card.dart';

import '../blocs/user/user_bloc.dart';
import '../blocs/user/user_event.dart';
import '../blocs/user/user_state.dart';
import '../blocs/viewtype/view_type_bloc.dart';
import '../blocs/viewtype/view_type_event.dart';
import '../blocs/viewtype/view_type_state.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserBloc(UserRepository())..add(FetchUsers()),
        ),
        BlocProvider(create: (_) => ViewTypeBloc()),
      ],
      child: const _UserListPageContent(),
    );
  }
}

class _UserListPageContent extends StatefulWidget {
  const _UserListPageContent();

  @override
  State<_UserListPageContent> createState() => _UserListPageContentState();
}

class _UserListPageContentState extends State<_UserListPageContent> {
  bool _showFooter = true;
  Timer? _hideTimer;

  void _restartHideTimer() {
    _hideTimer?.cancel();
    setState(() => _showFooter = true);

    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showFooter = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _restartHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          BlocBuilder<ViewTypeBloc, ViewTypeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isGrid ? Icons.view_list : Icons.grid_view_rounded,
                ),
                tooltip: state.isGrid
                    ? 'Switch to List View'
                    : 'Switch to Grid View',
                onPressed: () {
                  context.read<ViewTypeBloc>().add(ToggleViewType());
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState.isLoading && userState.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userState.error != null) {
            return Center(child: Text('Error: ${userState.error}'));
          }

          if (userState.users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  context.read<UserBloc>().add(RefreshUsers());
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      _restartHideTimer();
                      if (!userState.isLoading && userState.hasMore) {
                        context.read<UserBloc>().add(FetchUsers());
                      }
                    }
                    return false;
                  },
                  child: BlocBuilder<ViewTypeBloc, ViewTypeState>(
                    builder: (context, viewState) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: viewState.isGrid
                            ? _buildGridView(userState)
                            : _buildListView(userState),
                      );
                    },
                  ),
                ),
              ),

              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _showFooter ? 1.0 : 0.0,
                  curve: Curves.easeInOut,
                  child: _buildFloatingFooter(userState),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListView(UserState state) {
    return ListView.builder(
      key: const ValueKey('list_view'),
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: state.users.length,
      itemBuilder: (context, index) {
        return UserCardWidget(user: state.users[index], isGrid: false);
      },
    );
  }

  Widget _buildGridView(UserState state) {
    return GridView.builder(
      key: const ValueKey('grid_view'),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      itemCount: state.users.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return UserCardWidget(user: state.users[index], isGrid: true);
      },
    );
  }

  Widget _buildFloatingFooter(UserState state) {
    if (state.isLoading) {
      return CustomFooter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.8),
            ),
            SizedBox(width: 10),
            Text(
              'Loading more users...',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    } else if (!state.hasMore) {
      return const CustomFooter(child: NoMoreUsersMessage());
    } else {
      return const SizedBox.shrink();
    }
  }
}
