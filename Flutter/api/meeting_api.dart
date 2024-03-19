import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String MEETING_API_URL = "http://10.0.0.8:4000/api/meeting";
var client = http.Client();

Future<http.Response?> startMeeeting({required String currentUserID}) async {
  debugPrint("IMPORTANT__ startMeeeting $currentUserID");

  Map<String, String> requestHeaders = {
    "Content-Type": "application/json",
  };

  debugPrint("IMPORTANT__ MEETING_API_URL $MEETING_API_URL");

  var response = await client.post(
    Uri.parse("$MEETING_API_URL/start"),
    headers: requestHeaders,
    body: jsonEncode({
      "hostId": currentUserID,
      "hostName": "",
    }),
  );

  debugPrint("IMPORTANT__ response $response");

  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response> joinMeeting({required String meetingId}) async {
  var response =
      await http.get(Uri.parse("$MEETING_API_URL/join?meetingId=$meetingId"));
  if (response.statusCode >= 200 && response.statusCode < 400) {
    return response;
  }
  throw Exception("Not a valid meeting");
}
