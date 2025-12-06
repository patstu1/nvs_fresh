import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livekit_client/livekit_client.dart';
import 'nvs_live_constants.dart';

class LiveKitController {
  Room? _room;
  EventsListener<RoomEvent>? _listener;

  Room? get room => _room;

  Future<String> _fetchToken({required String roomName, required String identity}) async {
    final http.Response res = await http.post(
      Uri.parse(tokenEndpoint),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'room': roomName, 'identity': identity}),
    );
    if (res.statusCode != 200) {
      throw Exception('Token fetch failed: ${res.statusCode} ${res.body}');
    }
    final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['token'] as String;
  }

  Future<void> connect({
    required String roomName,
    required String identity,
    required void Function() onParticipantsChanged,
  }) async {
    await LiveKitClient.initialize();

    final String token = await _fetchToken(roomName: roomName, identity: identity);
    _room = Room();

    _listener = _room!.createListener();
    _listener!
      ..on<RoomDisconnectedEvent>((_) => onParticipantsChanged())
      ..on<ParticipantConnectedEvent>((_) => onParticipantsChanged())
      ..on<ParticipantDisconnectedEvent>((_) => onParticipantsChanged())
      ..on<TrackSubscribedEvent>((_) => onParticipantsChanged())
      ..on<TrackUnsubscribedEvent>((_) => onParticipantsChanged());

    await _room!.connect(liveKitWssUrl, token, connectOptions: const ConnectOptions());

    await _room!.localParticipant?.setCameraEnabled(true);
    await _room!.localParticipant?.setMicrophoneEnabled(true);

    onParticipantsChanged();
  }

  Future<void> leave() async {
    try {
      await _room?.disconnect();
    } finally {
      _listener?.dispose();
      _room?.dispose();
      _room = null;
    }
  }
}
