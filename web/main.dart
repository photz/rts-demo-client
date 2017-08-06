import 'dart:html';
import 'package:rts_demo_client/networked.dart';

void main() {
  print("hello world!");

  Game g = new Game();
}

class Game {
  Networked _nw;
  InputElement _chatInput;
  DivElement _chatOutput;

  Game() {
    print('launching game');
    _nw = new Networked('192.168.1.215', 9003, _onConnectionEstablished, _onGetMessages);

    _initChatInput();
    _initChatOutput();
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
    // Background
    DivElement div = new DivElement();
    div.style.width = '600px';
    div.style.height = '150px';
    div.style.position = 'absolute';
    div.style.right = '20px';
    div.style.bottom = '20px';
    div.style.backgroundColor = 'lightgrey';
    div.style.opacity = '1.0';

    // Input
    DivElement inputParent = new DivElement();
    inputParent.style.padding = '5%';

    _chatInput = new InputElement();
    _chatInput.style.marginRight = '10px';
    _chatInput.onKeyDown.listen(this._onChatInputKeyDown);
    inputParent.append(_chatInput);
    // Submit
    InputElement submit = new InputElement();
    submit.type = 'submit';
    submit.value = 'send';
    submit.onMouseDown.listen(this._onSubmitClick);
    inputParent.append(submit);

    div.append(inputParent);
    document.body.append(div);
  }

  void _initChatOutput() {
    // Background
    DivElement div = new DivElement();
    div.style.width = '300px';
    div.style.height = '700px';
    div.style.position = 'absolute';
    div.style.left = '20px';
    div.style.top = '20px';
    div.style.backgroundColor = 'lightgrey';
    div.style.opacity = '1.0';

    _chatOutput = new DivElement();
    _chatOutput.style.margin = '10%';

    div.append(_chatOutput);
    document.body.append(div);
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
    _nw.sendChatMessage(_chatInput.value);

    // Clear chat input field
    _chatInput.value = '';
  }

  void _createReceivedMessage(String message) {
    // Wrap
    DivElement outputWrap = new DivElement();
    outputWrap.style.width ='100%';
    outputWrap.style.textAlign ='right';
    outputWrap.style.paddingBottom ='10px';
    // Text
    DivElement output = new DivElement();
    output.text = message;
    output.className = 'received';
    outputWrap.append(output);
    _chatOutput.append(outputWrap);
  }

  void _createSendMessage(String message) {
    // Wrap
    DivElement outputWrap = new DivElement();
    outputWrap.style.width ='100%';
    outputWrap.style.textAlign ='left';
    outputWrap.style.paddingBottom ='10px';
    // Text
    DivElement output = new DivElement();
    output.text = message;
    output.className = 'send';
    outputWrap.append(output);
    _chatOutput.append(outputWrap);
  }
}

