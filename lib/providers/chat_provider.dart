import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ChatProvider with ChangeNotifier {
  List<Map<String, dynamic>> _messages = [];
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  bool _isConnected = false;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isConnected => _isConnected;

  Future<void> initializePeerConnection() async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (candidate) {
      // In a real app, you would send this candidate to the other peer
      print('ICE candidate: ${candidate.toMap()}');
    };

    _peerConnection!.onDataChannel = (channel) {
      _dataChannel = channel;
      _setupDataChannel();
    };

    notifyListeners();
  }

  void _setupDataChannel() {
    _dataChannel!.onMessage = (message) {
      final data = jsonDecode(message.text);
      _messages.add(data);
      notifyListeners();
    };

    _isConnected = true;
    notifyListeners();
  }

  Future<void> createOffer() async {
    final dataChannelInit = RTCDataChannelInit();
    _dataChannel = await _peerConnection!.createDataChannel('chat', dataChannelInit);
    _setupDataChannel();

    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    // In a real app, you would send this offer to the other peer
    print('Offer: ${offer.toMap()}');
  }

  Future<void> handleOffer(Map<String, dynamic> offerData) async {
    final offer = RTCSessionDescription(offerData['sdp'], offerData['type']);
    await _peerConnection!.setRemoteDescription(offer);

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    // In a real app, you would send this answer to the other peer
    print('Answer: ${answer.toMap()}');
  }

  void sendMessage(String senderId, String username, String content, String profilePicture) {
    final message = {
      'sender': senderId,
      'username': username,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
      'profilePicture': profilePicture,
    };

    _messages.add(message);
    _dataChannel?.send(RTCDataChannelMessage(jsonEncode(message)));
    notifyListeners();
  }
}