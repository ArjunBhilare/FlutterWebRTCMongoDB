import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';

class RemoteConnection extends StatefulWidget {
  final RTCVideoRenderer renderer;
  final Connection connection;

  RemoteConnection({
    required this.renderer,
    required this.connection,
  });

  @override
  State<RemoteConnection> createState() => _RemoteConnection();
}

class _RemoteConnection extends State<RemoteConnection> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RTCVideoView(
          widget.renderer,
          mirror: false,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
        ),
        Container(
          color: widget.connection.videoEnabled ?? false
              ? Colors.transparent
              : Colors.blueGrey,
          child: Center(
            child: Text(
              widget.connection.videoEnabled ?? false
                  ? ''
                  : widget.connection.name ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black,
            child: Row(
              children: [
                Text(
                  widget.connection.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Icon(
                  widget.connection.audioEnabled ?? false
                      ? Icons.mic
                      : Icons.mic_off,
                  color: widget.connection.audioEnabled ?? false
                      ? Colors.white
                      : Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
