import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as Audio;

class AudioPlayer extends StatefulWidget {
  AudioPlayer({super.key, required this.file});
  File file;

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  late Audio.AudioPlayer player = Audio.AudioPlayer();
  bool isPlaying = true;
  bool muted = false;
  bool repeat = false;
  Duration duration = const Duration(seconds: 0);
  Duration position = const Duration(seconds: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player.setUrl(widget.file.path);
    player.play();
    player.durationStream.listen((event) => setState(() => duration = event!));
    player.positionStream.listen((event) => setState(() => position = event));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  var currentTime = ValueNotifier<int>(0);

  toggleMute() {
    player.setVolume(muted ? 1 : 0);
    setState(() => muted = !muted);
  }

  togglePlayer() {
    if (isPlaying)
      player.pause();
    else
      player.play();
    setState(() => isPlaying = !isPlaying);
  }

  toggleRepeat() {
    player.setLoopMode(repeat ? Audio.LoopMode.off : Audio.LoopMode.one);
    setState(() => repeat = !repeat);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Audio Player"),
            SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 2,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                ),
                child: Slider(
                    value: position.inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble(),
                    onChanged: (pos) =>
                        player.seek(Duration(seconds: pos.toInt())))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Text(
                  getDuration(position),
                  style: Theme.of(context).textTheme.button,
                ),
                const Spacer(),
                Text(
                  getDuration(duration),
                  style: Theme.of(context).textTheme.button,
                )
              ]),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: toggleMute,
                    icon: Icon(muted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded)),
                const Spacer(),
                FloatingActionButton(
                  child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_arrow_rounded,
                      size: 32),
                  onPressed: togglePlayer,
                ),
                const Spacer(),
                IconButton(
                    onPressed: toggleRepeat,
                    icon:
                        Icon(repeat ? Icons.repeat_on_rounded : Icons.repeat)),
              ],
            )
          ],
        ),
      ),
    );
  }

  String getDuration(Duration duration) {
    duration.inSeconds;
    // final double _temp = duration / 1000;
    final int _minutes = duration.inMinutes;
    final int _seconds = (((duration.inSeconds / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      return _minutes.toString() + ":" + _seconds.toString();
    } else {
      return _minutes.toString() + ":0" + _seconds.toString();
    }
  }
}
