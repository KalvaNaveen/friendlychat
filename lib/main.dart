import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(FriendlyChatApp());

final ThemeData kIOSTheme = ThemeData(
  primaryColor: Colors.grey[100],
  primarySwatch: Colors.orange,
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  primaryColor: Colors.purple[100],
  primarySwatch: Colors.orangeAccent[400],
);

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FriendlyChat',
      theme: defaultTargetPlatform == TargetPlatform.iOS?kIOSTheme:kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final List<ChatMessages> _messages = <ChatMessages>[];
 bool _isComposing = false;
  void _handleSubmitted(String text) {
    _textEditingController.clear();



    ChatMessages messages = ChatMessages(
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 700)),

    );
    setState(() {
      _isComposing=false;
      _messages.insert(0, messages);

    });

    messages.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessages messages in _messages)
      messages.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('FriendlyChat'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS?0.0:4.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, int index) => _messages[index],
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer()),
          ],
        ),
      ),
    );
  }

  //Text Widget in Separate method
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textEditingController,
                onChanged: (String text){
                  setState(() {
                    _isComposing = text.length>0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),

              child:  Theme.of(context).platform ==TargetPlatform.iOS? CupertinoButton(
                  child: Text('Send'),
                  onPressed: _isComposing?() =>
                      _handleSubmitted(_textEditingController.text):null): IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isComposing?() =>
                      _handleSubmitted(_textEditingController.text):null),
            )
          ],
        ),
      ),
    );
  }
}

//chat Messages
class ChatMessages extends StatelessWidget {
  final String text;
  final AnimationController animationController;

  const ChatMessages({Key key, this.text, this.animationController}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    const String _name = 'Naveen Kalva';
    return FadeTransition(
     opacity:  animationController,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(_name[0]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _name,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
