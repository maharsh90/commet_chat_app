import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:comment_chat_app/conversations.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final idEditingController = TextEditingController(text: "SUPERHERO1");

  @override
  void initState() {
    super.initState();
    UIKitSettings uiKitSettings = (UIKitSettingsBuilder()
          ..subscriptionType = CometChatSubscriptionType.allUsers
          ..autoEstablishSocketConnection = true
          ..region = "IN" // Replace with your region

          ..appId = "26501690f4952a17" // Replace with your app ID

          ..authKey = "257f2156ce92a595f13862941c4d737b8525b3c3"
          ..extensions = CometChatUIKitChatExtensions
              .getDefaultExtensions() // Replace this with empty array; you want to disable all extensions

        ) // Replace with your auth key

        .build();
    CometChatUIKit.init(
        uiKitSettings: uiKitSettings,
        onSuccess: (String successMessage) {
          debugPrint("Initialization completed successfully  $successMessage");
        },
        onError: (CometChatException e) {
          debugPrint("Initialization failed with exception: ${e.message}");
        });
  }

  void _navigateToConversations() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const Conversations()));
  }

  void _login() {
    CometChatUIKit.login(idEditingController.text, onSuccess: (User user) {
      debugPrint("User logged in successfully  ${user.name}");
      _navigateToConversations();
    }, onError: (CometChatException e) {
      CometChatUIKit.createUser(
          User(name: idEditingController.text, uid: idEditingController.text),
          onSuccess: (User user) {
        CometChatUIKit.login(idEditingController.text, onSuccess: (User user) {
          debugPrint("User logged in successfully  ${user.name}");
          _navigateToConversations();
        }, onError: (CometChatException e) {
          debugPrint("Login failed with exception: ${e.message}");
        });
        debugPrint("User created successfully ${user.name}");
      }, onError: (CometChatException e) {
        debugPrint("Creating new user failed with exception: ${e.message}");
      });
      debugPrint("Login failed with exception: ${e.message}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: idEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter user ID',
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(onPressed: _login, child: const Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
