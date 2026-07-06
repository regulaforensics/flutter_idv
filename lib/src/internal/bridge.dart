part of "../../flutter_idv.dart";

const _methodChannelID = 'flutter_idv/method';
const MethodChannel _bridge = const MethodChannel(_methodChannelID);

String _eventPrefix = 'flutter_idv/event/';
List<String> _eventChannels = [];

void _eventChannel(String id, listen(msg)) {
  if (_eventChannels.contains(id)) return;
  _eventChannels.add(id);
  EventChannel(_eventPrefix + id).receiveBroadcastStream().listen(listen);
}
