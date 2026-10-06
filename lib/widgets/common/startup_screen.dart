import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StartupScreen extends StatefulWidget {
  final VoidCallback onFinished;
  const StartupScreen({super.key, required this.onFinished});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  VideoPlayerController? _video;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final v = VideoPlayerController.asset('assets/video/smartflux_reveal.mp4');
      await v.initialize();
      if (!mounted) return;
      _video = v..setLooping(false)..play();
      setState(() {});
      bool finished = false;
      v.addListener(() {
        if (!finished &&
            v.value.isInitialized &&
            v.value.position >= v.value.duration) {
          finished = true;
          widget.onFinished();
        }
      });
    } catch (_) {
      _timer = Timer(const Duration(milliseconds: 500), widget.onFinished);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _video?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D080A),
      body: Center(
        child: _video?.value.isInitialized == true
            ? AspectRatio(
                aspectRatio: _video!.value.aspectRatio,
                child: VideoPlayer(_video!),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
