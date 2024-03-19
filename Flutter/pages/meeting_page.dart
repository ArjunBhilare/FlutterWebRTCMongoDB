import 'package:emergencyapp/main.dart';
import 'package:emergencyapp/voip_call/models/meeting_details.dart';
import 'package:emergencyapp/voip_call/widgets/control_panel.dart';
import 'package:emergencyapp/voip_call/widgets/remote_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MeetingPage extends StatefulWidget {
  final String? meetingId;
  final String? name;
  final MeetingDetail meetingDetail;

  const MeetingPage({
    Key? key,
    required this.meetingId,
    required this.name,
    required this.meetingDetail,
  }) : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  late Box Box_Preference;
  String currentUserID = '';

  final _localRenderer = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {
    'audio': true,
    'video': true,
  };
  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;

  @override
  Widget build(BuildContext context) {
    Box_Preference = Hive.box(BOX_PREFERENCES);
    currentUserID = Box_Preference.get("currentUserID", defaultValue: "");
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: handleReconnect,
        onMeetingEnd: onMeetingEnd,
      ),
    );
  }

  void startMeeting() async {
    meetingHelper = WebRTCMeetingHelper(
      url: "http://10.0.0.8:4000",
      meetingId: widget.meetingDetail.id,
      userId: currentUserID,
      name: widget.name,
    );

    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = _localStream;
    meetingHelper!.stream = _localStream;

    meetingHelper!.on(
      "open",
      context,
      ((ev, context) {
        setState(() {
          isConnectionFailed = true;
        });
      }),
    );

    meetingHelper!.on(
      "connection",
      context,
      ((ev, context) {
        setState(() {
          isConnectionFailed = true;
        });
      }),
    );

    meetingHelper!.on(
      "user-left",
      context,
      ((ev, context) {
        setState(() {
          isConnectionFailed = true;
        });
      }),
    );

    meetingHelper!.on(
      "video-toggle",
      context,
      ((ev, context) {
        setState(() {
          isConnectionFailed = true;
        });
      }),
    );

    meetingHelper!.on(
      "audio-toggle",
      context,
      ((ev, context) {
        setState(() {
          isConnectionFailed = true;
        });
      }),
    );

    meetingHelper!.on(
      "meeting-ended",
      context,
      ((ev, context) {
        onMeetingEnd();
      }),
    );

    meetingHelper!.on(
      "connection-setting-changed",
      context,
      ((ev, context) {
        setState(() {
          isConnectionFailed = true;
        });
      }),
    );

    meetingHelper!.on(
      "stream-changed",
      context,
      ((ev, context) {
        setState(() {
          isConnectionFailed = true;
        });
      }),
    );

    setState(() {});
  }

  initRenderer() async {
    await _localRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderer();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRenderer.dispose();
    meetingHelper?.destroy();
  }

  void onMeetingEnd() {
    meetingHelper?.endMeeting();
    Navigator.of(context).pop();
  }

  Widget _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children:
                    List.generate(meetingHelper!.connections.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(1),
                    child: RemoteConnection(
                      renderer: meetingHelper!.connections[index].renderer,
                      connection: meetingHelper!.connections[index],
                    ),
                  );
                }),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),

        // Local video
        Positioned(
          bottom: 10,
          right: 10,
          child: SizedBox(
            width: 150,
            height: 200,
            child: RTCVideoView(
              _localRenderer,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
        ),
      ],
    );
  }

  void onAudioToggle() {
    setState(() {
      meetingHelper?.toggleAudio();
    });
  }

  void onVideoToggle() {
    setState(() {
      meetingHelper?.toggleVideo();
    });
  }

  void handleReconnect() {
    setState(() {
      meetingHelper?.reconnect();
    });
  }

  bool isVideoEnabled() {
    return meetingHelper?.videoEnabled ?? false;
  }

  bool isAudioEnabled() {
    return meetingHelper?.audioEnabled ?? false;
  }
}
