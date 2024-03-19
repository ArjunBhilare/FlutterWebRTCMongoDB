import 'dart:convert';

import 'package:emergencyapp/main.dart';
import 'package:emergencyapp/voip_call/pages/meeting_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import '../api/meeting_api.dart';
import '../models/meeting_details.dart';

class VOIPHomeScreen extends StatefulWidget {
  const VOIPHomeScreen({super.key});

  @override
  State<VOIPHomeScreen> createState() => _VOIPHomeScreen();
}

class _VOIPHomeScreen extends State<VOIPHomeScreen> {
  // ---------------------------------------------------------------------------

  late Box Box_Preferences;
  String currentUserID = "";
  String meetingId = "";

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //? ------------------------------------------------------------------------

    Box_Preferences = Hive.box(BOX_PREFERENCES);
    currentUserID = Box_Preferences.get("currentUserID", defaultValue: "");

    //? ------------------------------------------------------------------------

    return Scaffold(
      appBar: AppBar(
        title: const Text("VOIP Call"),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // textfield for meetingId
              TextField(
                onChanged: (value) {
                  setState(() {
                    meetingId = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Enter Meeting ID",
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  var response = await startMeeeting(
                    currentUserID: currentUserID,
                  );
                  final body = json.decode(response!.body);
                  final meetId = body['data'];
                  validateMeeting(meetingId: meetId);
                },
                child: const Text("Start Meeting"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Join meeting
                  validateMeeting(meetingId: meetingId);
                },
                child: const Text("Join Meeting"),
              ),
            ],
          ),
        ),
      ),
    );

    //? ------------------------------------------------------------------------
  }

  // ---------------------------------------------------------------------------

  void validateMeeting({
    required String meetingId,
  }) async {
    try {
      debugPrint("IMPORTANT__ validateMeeting $meetingId");
      Response response = await joinMeeting(meetingId: meetingId);
      debugPrint("IMPORTANT__ response $response");
      var data = json.decode(response.body);
      final meetingDetails = MeetingDetail.fromJson(data["data"]);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetingPage(
            meetingId: meetingDetails.id,
            name: currentUserID,
            meetingDetail: meetingDetails,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  // ---------------------------------------------------------------------------
}
