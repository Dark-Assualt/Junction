import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:junction/buttons.dart';

const _urls = [
  'https://firebasestorage.googleapis.com/v0/b/videos-aad64.appspot.com/o/Animation.mp4?alt=media&token=1dd0209c-2a21-4c4f-bf6f-9765e6373183',
  'https://firebasestorage.googleapis.com/v0/b/videos-aad64.appspot.com/o/20221108_164940.mp4?alt=media&token=90ef4593-e775-469f-9382-ccc370c6ec06',
  'https://firebasestorage.googleapis.com/v0/b/videos-aad64.appspot.com/o/20221108_165343.mp4?alt=media&token=5bb4cc4f-9077-4382-bbbf-e3891fe30221',
  'https://firebasestorage.googleapis.com/v0/b/videos-aad64.appspot.com/o/20221108_174935.mp4?alt=media&token=7f23c9eb-2cea-44f5-8daa-4ee25a3ea321',
  ];

final _whatPageIsIt = ValueNotifier<int?>(null);
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp() : super(key: const ValueKey('MyApp'));

  @override
  Widget build(BuildContext context) => const MaterialApp( debugShowCheckedModeBanner: false, home: MyHomePage());
}

class MyHomePage extends StatelessWidget {
  const MyHomePage() : super(key: const ValueKey('MyHomePage'));

  @override
  Widget build(BuildContext context) => Material(
    child: PageView.builder( scrollDirection: Axis.vertical,
      onPageChanged: (i) => _whatPageIsIt.value = i,
      itemCount: _urls.length,
      itemBuilder: (context, index) => MyWidget(index),),
  );
}

class MyWidget extends StatefulWidget {
  final int index;
  MyWidget(this.index) : super(key: ValueKey('MyWidget: $index'));

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(_urls[widget.index])
      ..setLooping(true);
    _whatPageIsIt.addListener(() => _whatPageIsIt.value == widget.index
        ? _controller.play()
        : _controller.pause());
  }

  @override
  void didChangeDependencies() {
    _whatPageIsIt.value ??= widget.index;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<dynamic> _init() async {
    await _controller.initialize();
    return Null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(),
      builder: (context, future) => !future.hasData
          ? const Align(child: CircularProgressIndicator())
          : future.hasError
          ? const Align(child: Icon(Icons.error))
          : GestureDetector(
        onTap: () => _controller.value.isPlaying
            ? _controller.pause()
            : _controller.play(),
        child: Stack(
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            Icon(Icons.favorite,
              color: Colors.pink,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            Icon(Icons.favorite,
              color: Colors.pink,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
          ],
          ),
            Align(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}