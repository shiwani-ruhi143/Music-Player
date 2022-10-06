import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/Widgets/shadow_box.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    setAudio();

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

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    String url =
        'https://p320.djpunjab.is/data/48/48139/295505/Aj Kal Ve - Sidhu Moose Wala.mp3';
    audioPlayer.setSourceUrl(url);
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
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50.h,
                        width: 50.w,
                        child: ShadowBox(
                            child: Icon(
                          Icons.arrow_back,
                          size: 25.r,
                        )),
                      ),
                      Text(
                        "P L A Y L I S T",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                        width: 50.w,
                        child: ShadowBox(
                            child: Icon(
                          Icons.menu,
                          size: 25.r,
                        )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ShadowBox(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.r),
                        child: ClipRRect(
                          child: Image.asset(
                            'assets/images/song.jpg',
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.r),
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
                                      fontSize: 18.sp,
                                      color: Colors.grey[800]),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Text(
                                  "Aj Kal Ve",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.sp,
                                  ),
                                )
                              ],
                            ),
                            Icon(
                              Icons.favorite,
                              size: 32.r,
                              color: Colors.red[600],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
                  SizedBox(
                    height: 15.h,
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
                    height: 15.h,
                  ),
                  ShadowBox(
                      child: Slider(
                          // thumbColor: Colors.pinkAccent,
                          activeColor: Colors.red,
                          inactiveColor: Colors.grey[400],
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await audioPlayer.seek(position);
                            await audioPlayer.resume();
                            // audioPlayer.setVolume(1);
                          })),
                  SizedBox(
                    height: 80.h,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                            child: ShadowBox(
                                child: Icon(Icons.skip_previous, size: 40.r))),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                            flex: 2,
                            child: ShadowBox(
                              child: IconButton(
                                  onPressed: () async {
                                    if (isPlaying) {
                                      await audioPlayer.pause();
                                    } else {
                                      await audioPlayer.resume();
                                    }
                                  },
                                  icon: isPlaying
                                      ? Icon(
                                          Icons.pause,
                                          size: 35.r,
                                        )
                                      : Icon(
                                          Icons.play_arrow,
                                          size: 35.r,
                                        )),
                            )),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                            child: ShadowBox(
                                child: Icon(Icons.skip_next, size: 40.r)))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
