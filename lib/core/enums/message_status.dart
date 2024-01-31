enum MessageStatus {
  pending, //are not ready to be sent (processing, uploading file, ...)
  pendingFail,
  sending,
  sent,
  fail,
}
