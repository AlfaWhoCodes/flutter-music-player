import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Banner(
          message: 'AWC',
          location: BannerLocation.topEnd,
          child: MusicPlayerScreen()),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setLocalAudio();

    _audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d ?? Duration.zero;
      });
    });

    _audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  Future<void> _setLocalAudio() async {
    await _audioPlayer.setUrl('https://alfawhocodes.com/sample/sixdays.mp3');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _next() {
    // Implement next functionality
  }

  void _previous() {
    // Implement previous functionality
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return [
      if (hours > 0) twoDigits(hours),
      twoDigits(minutes),
      twoDigits(seconds),
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(right: 32, top: 36, bottom: 12, left: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/sixdaysimage.jpg',
              width: 500,
              height: 300,
            ),
            const Text(
              'Six Days',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Album: Sample Album',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Singer :DJ Shadow',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Writtern by: Brian Farrell and Dennis Olivieri',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Slider(
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble(),
              thumbColor: Colors.black,
              activeColor: Colors.black,
              inactiveColor: Colors.black45,
              onChanged: (value) {
                setState(() {
                  _audioPlayer.seek(Duration(seconds: value.toInt()));
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position)),
                Text(_formatDuration(_duration)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 48.0,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: _previous,
                ),
                IconButton(
                  iconSize: 64.0,
                  icon: Icon(isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill),
                  onPressed: _playPause,
                ),
                IconButton(
                  iconSize: 48.0,
                  icon: const Icon(Icons.skip_next),
                  onPressed: _next,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
