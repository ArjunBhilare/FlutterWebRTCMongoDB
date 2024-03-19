class MeetingDetail {
  String? id;
  String? hostId;
  String? hostName;

  MeetingDetail({this.id, this.hostId, this.hostName});

  factory MeetingDetail.fromJson(Map<String, dynamic> json) {
    return MeetingDetail(
      id: json['id'],
      hostId: json['hostId'],
      hostName: json['hostName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostId': hostId,
      'hostName': hostName,
    };
  }
}
