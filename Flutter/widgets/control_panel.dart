import 'dart:ffi';

import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final bool? videoEnabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;

  const ControlPanel({
    Key? key,
    this.videoEnabled,
    this.audioEnabled,
    this.isConnectionFailed,
    this.onVideoToggle,
    this.onAudioToggle,
    this.onReconnect,
    this.onMeetingEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildControlPanel(),
      ),
    );
  }

  List<Widget> _buildControlPanel() {
    if (!isConnectionFailed!) {
      return [
        IconButton(
          onPressed: onVideoToggle,
          icon: Icon(
            videoEnabled! ? Icons.videocam : Icons.videocam_off,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: onAudioToggle,
          icon: Icon(
            audioEnabled! ? Icons.mic : Icons.mic_off,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: onMeetingEnd,
          icon: const Icon(
            Icons.call_end,
            color: Colors.white,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: onReconnect,
          icon: const Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
      ];
    }
  }
}
