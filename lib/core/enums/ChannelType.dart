enum ChannelType {
  direct,
  group,
  bot,
  sms;


  static ChannelType fromString(String type) {
    switch (type) {
      case "sms":
        return ChannelType.sms;
      case "direct":
        return ChannelType.direct;
      case "ai-bot":
        return ChannelType.bot;
      default:
        return ChannelType.group;
    }
  }
}
