import 'dart:convert';
import 'dart:html';

class Networked {

  String _host;
  int _port;
  WebSocket _ws;
  var _onGetMessages;
  var _onOpenCb;

  Networked(this._host, this._port, this._onOpenCb, this._onGetMessages) {
    String p = this._port.toString();
    _ws = new WebSocket('ws://${_host}:${p}');
    _ws.onOpen.listen(_onOpen);
  }

  void _onOpen(e) {
    _onOpenCb();
    _ws.onMessage.listen(_onMessage);
  }

  void _onMessage(MessageEvent e) {
    var data = JSON.decode(e.data);

    if (data.containsKey('messages'))
    {
      _onGetMessages(data['messages']);
    }
  }

  void _sendAsJson(obj) {
    String json = JSON.encode(obj);
    _ws.send(json);
  }

  void sendChatMessage(String message) {
    _sendAsJson({
      'msg_type': 'chat_message',
      'message': message
    });
  }
}
