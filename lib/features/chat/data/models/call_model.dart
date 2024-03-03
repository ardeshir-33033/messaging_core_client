class CallModel {
  String? callCommand;
  String? reason;
  String? callName;
  String? callerName;
  String? calleeName;
  String? token;
  int? calleeId;
  int? initiatorId;
  int? receiverId;
  bool? enableVideo;

  CallModel(
      {this.callCommand,
      this.reason,
      this.callName,
      this.calleeId,
      this.initiatorId,
      this.token,
      this.calleeName,
      this.callerName,
      this.receiverId,
      this.enableVideo});

  CallModel.fromJson(Map<String, dynamic> json) {
    callCommand = json['callCommand'];
    reason = json['reason'];
    callName = json['callName'];
    token = json['token'];
    calleeId = json['userId'];
    calleeName = json['calleeName'];
    callerName = json["callerName"];
    initiatorId = json['initiatorId'];
    receiverId = json['receiverId'];
    enableVideo = json['enableVideo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['callCommand'] = callCommand;
    data['reason'] = reason;
    data['callName'] = callName;
    data['token'] = token;
    data['userId'] = calleeId;
    data['calleeName'] = calleeName;
    data['callerName'] = callerName;
    data['initiatorId'] = initiatorId;
    data['receiverId'] = receiverId;
    data['enableVideo'] = enableVideo;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
