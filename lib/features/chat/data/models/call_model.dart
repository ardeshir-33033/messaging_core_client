class CallModel {
  String? callCommand;
  String? reason;
  String? callName;
  String? token;
  int? calleeId;
  String? channelId;
  bool? enableVideo;

  CallModel(
      {this.callCommand,
      this.reason,
      this.callName,
      this.calleeId,
      this.channelId,
      this.token,
      this.enableVideo});

  CallModel.fromJson(Map<String, dynamic> json) {
    callCommand = json['callCommand'];
    reason = json['reason'];
    callName = json['callName'];
    token = json['token'];
    calleeId = json['userId'];
    channelId = json['channelId'];
    enableVideo = json['enableVideo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['callCommand'] = callCommand;
    data['reason'] = reason;
    data['callName'] = callName;
    data['token'] = token;
    data['userId'] = calleeId;
    data['channelId'] = channelId;
    data['enableVideo'] = enableVideo;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
