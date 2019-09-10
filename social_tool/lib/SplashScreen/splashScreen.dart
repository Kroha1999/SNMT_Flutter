/*THIS PAGE ALSO CONTAINS A SPLASH SCREEN AND INITIALIZE ROUTES FOR THE APP*/
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/MainPage/mainScreen.dart';


class SplashScreen extends StatefulWidget {
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
 
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    /// Initialize data, then navigator to Home screen.
    initData().then((value) {
      navigateToHomeScreen();
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Globals.interfaceCol,
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: AnimatedBackground()),
          onBottom(AnimatedWave(
            height: 180,
            speed: 1.0,
          )),
          onBottom(AnimatedWave(
            height: 120,
            speed: 0.9,
            offset: pi,
          )),
          onBottom(AnimatedWave(
            height: 220,
            speed: 1.2,
            offset: pi / 2,
          )),
          Positioned.fill(
            child: Center( 
              child:SpinKitCircle(color: Colors.white,duration: Duration(seconds: 1,milliseconds: 200),size: 30,),//Icon(Icons.supervised_user_circle,size: 100,color: Colors.white,) ,//Text("SNMT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30.0),),
            )
          ),
        ],
      ),
    );
  }
  
  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  Future initData() async {
    //var permissions = await Permission.getPermissionsStatus([PermissionName.Internet, PermissionName.Camera]);
    //var permissionNames = await Permission.requestPermissions([PermissionName.Internet, PermissionName.Camera]);

    //Permission.openSettings();
    //REstoring Data with accounts
    DataController.getAccounts();
    DataController.loadPosts();
    await Future.delayed(Duration(seconds: 3));
  }

  /// Navigate to Home screen.
  void navigateToHomeScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
  }
}


class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900)),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600))
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [animation["color1"], animation["color2"]])),
        );
      },
    );
  }
}

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: ControlledAnimation(
            playback: Playback.LOOP,
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}