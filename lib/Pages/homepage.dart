// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/Widgets/shadow_box.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Listen to states : playing,pause,stop
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    //Listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    //Listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
            backgroundColor: Colors.grey[300],
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: ShadowBox(
                              child: Icon(
                            Icons.arrow_back,
                            size: 30,
                          )),
                        ),
                        Text("P L A Y L I S T"),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: ShadowBox(
                              child: Icon(
                            Icons.menu,
                            size: 30,
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ShadowBox(
                        child: Column(
                      children: [
                        ClipRRect(
                          child: Image.asset('assets/images/cover.jpg'),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sidhu MooseWala",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.grey[800]),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Aj Kal Ve",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  )
                                ],
                              ),
                              Icon(
                                Icons.favorite,
                                size: 32,
                                color: Colors.red[600],
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(formatTime(position)),
                        Icon(Icons.shuffle_outlined),
                        Icon(Icons.repeat),
                        Text(formatTime(duration))
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ShadowBox(
                        child: Slider(
                            // thumbColor: Colors.pinkAccent,
                            activeColor: Colors.red,
                            inactiveColor: Colors.grey[400],
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) async {})),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                              child: ShadowBox(
                                  child: Icon(Icons.skip_previous, size: 40))),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              flex: 2,
                              child: ShadowBox(
                                child: IconButton(
                                    onPressed: () async {
                                      if (isPlaying) {
                                        await audioPlayer.pause();
                                      } else {
                                        String url =
                                            'https://soundcloud.com/monstercat/infected-mushroom-its-behind?utm_source=mobi&utm_medium=text&utm_campaign=social_sharing';
                                        await audioPlayer.play(UrlSource(url));
                                      }
                                    },
                                    icon: isPlaying
                                        ? Icon(
                                            Icons.pause,
                                            size: 40,
                                          )
                                        : Icon(
                                            Icons.play_arrow,
                                            size: 40,
                                          )),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: ShadowBox(
                                  child: Icon(Icons.skip_next, size: 40)))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
