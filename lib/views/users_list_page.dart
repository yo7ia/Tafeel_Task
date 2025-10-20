import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tafeel_task/viewmodels/user_list_type_state.dart';
import 'package:tafeel_task/views/widgets/user_card.dart';

import '../viewmodels/user_view_model.dart';
import 'widgets/custom_footer_style.dart';
import 'widgets/no_more_users.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()..fetchUsers()),
        ChangeNotifierProvider(create: (_) => UserListTypeState()),
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
    final userVM = context.watch<UserViewModel>();
    final viewState = context.watch<UserListTypeState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: Icon(
              viewState.isGrid ? Icons.view_list : Icons.grid_view_rounded,
            ),
            tooltip: viewState.isGrid
                ? 'Switch to List View'
                : 'Switch to Grid View',
            onPressed: viewState.toggleViewType,
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await userVM.refreshUsers();
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  _restartHideTimer();
                  if (!userVM.isLoading && userVM.hasMore) userVM.fetchUsers();
                }
                return false;
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: viewState.isGrid
                    ? _buildGridView(context, userVM)
                    : _buildListView(context, userVM),
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
              child: _buildFloatingFooter(userVM),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, UserViewModel userVM) {
    return ListView.builder(
      key: const ValueKey('lv'),
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: userVM.users.length,
      itemBuilder: (context, index) {
        return UserCardWidget(user: userVM.users[index], isGrid: false);
      },
    );
  }

  Widget _buildGridView(BuildContext context, UserViewModel userVM) {
    return GridView.builder(
      key: const ValueKey('gv'),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      itemCount: userVM.users.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return UserCardWidget(user: userVM.users[index], isGrid: true);
      },
    );
  }

  Widget _buildFloatingFooter(UserViewModel userVM) {
    if (userVM.isLoading) {
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
    } else if (!userVM.hasMore) {
      return const CustomFooter(child: NoMoreUsersMessage());
    } else {
      return const SizedBox.shrink();
    }
  }
}
