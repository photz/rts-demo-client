import 'dart:html';
import 'dart:convert';
import 'package:rts_demo_client/server.dart';
import 'package:rts_demo_client/game-map.dart';

void main() {
  print("hello world!");

  Game g = new Game();
}

class Game {
  Server _server;
  InputElement _chatInput;
  DivElement _chatOutput;
  var _initialized = false;
  Element _map;
  var _testFactory = null;
  GameMap _gameMap;

  Game() {
    _gameMap = new GameMap();

    _server = new Server('ws://192.168.1.212', 9004);
    _server.events.listen(this._onServerEvent);

    _initChatInput();
    _initChatOutput();
  }

  void _onServerEvent(data) {

    // Player
    if (data.containsKey("player_id")) {
      _gameMap.setPlayerId(data["player_id"]);
    }

    // Point Masses
    if (data.containsKey("point_masses")) {
      _gameMap.setPointMasses(data["point_masses"]);
    }

    // Resources
    if (data.containsKey("resources")) {
      _gameMap.setResources(data["resources"]);
    }

    // Ownership
    if (data.containsKey("ownership")) {
      _gameMap.setOwnership(data["ownership"]);
    }

    // Unit Factories
    if (data.containsKey("unit_factories")) {
      _gameMap.setUnitFactories(data["unit_factories"]);
    }

    // TODO: containsKey("message")
  }

  void _onConnectionEstablished() {
    print('Connection established');
    // document.body.onMouseDown.listen(this._onMouseDown);
    // document.onVisibilityChange.listen(this._onVisibilityChange);
    // document.body.onKeyUp.listen(this._onKeyUp);
    // window.onKeyDown.listen(this._onKeyDown);
    // document.onPointerLockChange.listen(_onLockChange);
    // document.onPointerLockError.listen(_onLockError);
    // document.body.onMouseMove.listen(_onMouseMove);
  }

  void _onGetMessages(messages) {
    print('Get messages');
    print(messages);
    print(messages.length);
    if (messages.length > 0)
    {
      for (var i = 0; i < messages.length; i++)
      {
        var msg = messages[i];
        _createReceivedMessage(msg['message']);
      }
    }
  }

  void _initChatInput() {
    // Creating Elements
    DivElement background = new DivElement();
    background.className = 'chat-input__background';

    DivElement wrap = new DivElement();
    wrap.className = 'chat-input__wrap';

    _chatInput = new InputElement();
    _chatInput.className = 'chat-input';

    InputElement submit = new InputElement();
    submit.type = 'submit';
    submit.value = 'send';

    // Appending
    wrap.append(_chatInput);
    wrap.append(submit);
    background.append(wrap);
    document.body.append(background);

    // Setting Key Callbacks
    _chatInput.onKeyDown.listen(this._onChatInputKeyDown);
    submit.onMouseDown.listen(this._onSubmitClick);
  }

  void _initChatOutput() {
    // Creating Elements
    DivElement background = new DivElement();
    background.className = 'chat-output__background';

    _chatOutput = new DivElement();
    _chatOutput.className = 'chat-output';

    // Appending
    background.append(_chatOutput);
    document.body.append(background);
  }

  void _onChatInputKeyDown(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER) {
      this._handleChatSubmit();
    }
  }

  void _onSubmitClick(MouseEvent e) {
    this._handleChatSubmit();
  }

  void _handleChatSubmit() {
    _createReceivedMessage(_chatInput.value);
    _createSendMessage(_chatInput.value);

    // Send message to server
    // _nw.sendChatMessage(_chatInput.value);

    // Clear chat input field
    _chatInput.value = '';
  }

  void _createReceivedMessage(String message) {
    // Elements
    DivElement messageWrap = new DivElement();
    messageWrap.className = 'message__wrap';

    DivElement messageEl = new DivElement();
    messageEl.className = 'received';
    messageEl.text = message;
    messageWrap.append(messageEl);
    _chatInput.append(messageWrap);
  }

  void _createSendMessage(String message) {
    // Wrap
    DivElement messageWrap = new DivElement();
    messageWrap.style.width ='100%';
    messageWrap.style.textAlign ='left';
    messageWrap.style.paddingBottom ='10px';
    // Text
    DivElement messageEl = new DivElement();
    messageEl.text = message;
    messageEl.className = 'send';
    messageWrap.append(messageEl);
    _chatOutput.append(messageWrap);
  }
}

