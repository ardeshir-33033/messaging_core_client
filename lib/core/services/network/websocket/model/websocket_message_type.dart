enum MessageType {
  // Pinging Types
  ping,
  pong,
  // Command Responses
  ack,
  nak,
  // Contents
  sendContent,
  userContent,
  getContents,
  // Channels
  createChannel,
  createChannelV1,
  getChannels,
  // Subscribes
  addSubscribers,
  removeSubscribers,
  getSubscribers,
  // Signals
  sendSignal,
  userSignal,
  sendSequence,
  userSequence,
  getSequence,
  getSequences,
  userChannel,
  getStatuses,
  getWallet,
  getTransactions,
  sendToken,
  leaveChannel,
  deleteChannel,
  isTypingSignal,
  remove,
  undefined;

  static MessageType fromString(String? status) {
    status = status?.toLowerCase();
    switch (status ?? "") {
      case "istypingsignal":
        return MessageType.isTypingSignal;
      case "remove":
        return MessageType.remove;

      default:
        return MessageType.undefined;
    }
  }
}
