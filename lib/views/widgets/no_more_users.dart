import 'package:flutter/material.dart';

class NoMoreUsersMessage extends StatefulWidget {
  const NoMoreUsersMessage();

  @override
  State<NoMoreUsersMessage> createState() => _NoMoreUsersMessageState();
}

class _NoMoreUsersMessageState extends State<NoMoreUsersMessage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(24),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        child: Text(
          '🎉 No more users',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
