part of "../../flutter_idv.dart";

late void Function()? _didStartSessionCompletion;
void _setDidStartSessionCompletion(void Function()? completion) {
  _didStartSessionCompletion = completion;
  _eventChannel(
    'didStartSessionEvent',
    (msg) => _didStartSessionCompletion?.call(),
  );
}

late void Function()? _didEndSessionCompletion;
void _setDidEndSessionCompletion(void Function()? completion) {
  _didEndSessionCompletion = completion;
  _eventChannel(
      'didEndSessionEvent', (msg) => _didEndSessionCompletion?.call());
}

late void Function()? _didStartRestoreSessionCompletion;
void _setDidStartRestoreSessionCompletion(void Function()? completion) {
  _didStartRestoreSessionCompletion = completion;
  _eventChannel(
    'didStartRestoreSessionEvent',
    (msg) => _didStartRestoreSessionCompletion?.call(),
  );
}

late void Function()? _didContinueRemoteSessionCompletion;
void _setDidContinueRemoteSessionCompletion(void Function()? completion) {
  _didContinueRemoteSessionCompletion = completion;
  _eventChannel(
    'didContinueRemoteSessionEvent',
    (msg) => _didContinueRemoteSessionCompletion?.call(),
  );
}
