import 'dart:async';

import 'package:dice_app_2/dice_shape.dart';
import 'package:dice_app_2/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'dice_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //variables

  //lists of dicesdata
  final List<DiceData> dicesPage1 = List.generate(3, (index) => DiceData(10));
  final List<DiceData> dicesPage2 = List.generate(2, (index) => DiceData(10));
  final List<DiceData> dicesPage3 = List.generate(1, (index) => DiceData(10));

  //merging all dicesPages in one
  late List<List> dicesPages = [
    dicesPage1.toList(),
    dicesPage2.toList(),
    dicesPage3.toList(),
  ];

  //controller of the dot page indicator
  final smoothPageIndicatorController =
      PageController(viewportFraction: 1, keepPage: true);

  //variables for the snackBar
  int _counter = 0;
  bool _timerRunning = false;

  //snackbar for the thanks to ralf
  final SnackBar hiddenMsg = SnackBar(
    backgroundColor: Colors.teal[800],
    duration: const Duration(milliseconds: 2000),
    content: SizedBox(
      height: 17,
      child: Center(
        child: Text("Special thanks to CodeItRalf",
            style: GoogleFonts.josefinSans(
              fontSize: 20,
            )),
      ),
    ),
  );

  final SnackBar pifiaMsg = SnackBar(
    backgroundColor: Colors.red[300],
    behavior: SnackBarBehavior.fixed,
    duration: const Duration(milliseconds: 4000),
    content: SizedBox(
      height: 50,
      child: Center(
        child: Text("Pifia :(",
            style: GoogleFonts.josefinSans(
              fontSize: 20,
            )),
      ),
    ),
  );

  final SnackBar exitoMgs = SnackBar(
    backgroundColor: Colors.green[300],
    duration: const Duration(milliseconds: 4000),
    content: SizedBox(
      height: 50,
      child: Center(
        child: Text("Éxito!!",
            style: GoogleFonts.josefinSans(
              fontSize: 20,
            )),
      ),
    ),
  );

  //bools for checking the rolling methods
  //todo create a class to make lists of dice data, this would be a variable of that class
  List<bool> isRollingList = List.generate(3, (index) => false);

  //methods

  //methods for displaying the toast message
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _sendToastMessage(SnackBar msg) {
    ScaffoldMessenger.of(context).showSnackBar(msg);
  }

  //timer to do the amount of taps to show the hidden msg
  void _startTimer() {
    if (!_timerRunning) {
      Timer(const Duration(seconds: 5), () {
        // Reset the counter when the timer expires
        _resetCounter();
        _timerRunning = false;
      });
      _timerRunning = true;
    }
  }

  void globalAnim(int dicesPagesIndex) {
    //lock the animation boolean to start it
    for (var dicesIndex = 0;
        dicesIndex < dicesPages[dicesPagesIndex].length;
        dicesIndex++) {
      dicesPages[dicesPagesIndex][dicesIndex].isAnimating = true;
    }
  }

  Future<void> globalRoll(int indexOfList) async {
    //things that have to happen at the start
    //only one instance at a time
    if (!isRollingList[indexOfList]) {
      isRollingList[indexOfList] = true;

      //how many number of dices do we have
      int numOfDices = indexOfList + 1;
      int dicesPagesIndex = (indexOfList - 2).abs();

      //start the animation
      globalAnim(dicesPagesIndex);

      for (int times = 0;
          //this has to change to make it less hardcoded todo fix this
          times < dicesPages[dicesPagesIndex][0].limit * 2;
          times++) {
        setState(() {
          for (var j = 0; j < numOfDices; j++) {
            dicesPages[dicesPagesIndex][j].rollValues();
          }
        });
        //todo fix this aswell
        await Future.delayed(DiceData.fractionOfRollingDuration(0.10));
      }
      //if you are throwing 3 dices, run the comparator
      if (dicesPagesIndex == 0) {
        setState(() {
          diceComparator();
        });
      }
      //wait a time so it doesnt look spameable
      await Future.delayed(DiceData.fractionOfRollingDuration(1.5));
      isRollingList[indexOfList] = false;
    }
  }

  void diceRestoreDefault() {
    for (int i = 0; i < dicesPages[0].length; i++) {
      dicesPages[0][i].isMin = false;
      dicesPages[0][i].isMax = false;
    }
  }

  void diceComparator() {
    //the last index of the array
    final int indexLimit = dicesPages[0].length - 1;

    //both of counterFor allow us to display the snack bar for the events when we want
    //store the maximum value for comparing and the index for changing isMax parameter
    //the Indexes are nullable so it doesnt have a defalut value and dont display any number by mistake
    int max = 0;
    int? maxIndex;
    int counterForExito = 0;

    //store the minimum value for comparing and the index for changing inMin parameter
    //mis starts at limit + 1 to force the min to change at least one time
    int min = (dicesPages[0][0].limit);
    int? minIndex;
    int counterForPifia = 0;

    for (int i = 0; i <= indexLimit; i++) {
      //searching the minimum value
      if (dicesPages[0][indexLimit - i].value < min) {
        min = dicesPages[0][indexLimit - i].value;
        minIndex = (indexLimit - i);
      }
      //searching for the ones TODO pifia fun
      if (dicesPages[0][indexLimit - i].value == 1) {
        dicesPages[0][indexLimit - i].isMin = true;
        counterForPifia++;
      }

      //searching for the max value TODO exito fun
      if (dicesPages[0][i].value > max) {
        max = dicesPages[0][i].value;
        maxIndex = i;
      }
      //searching for the limits
      if (dicesPages[0][i].value == dicesPages[0][0].limit) {
        dicesPages[0][i].isMax = true;
        counterForExito++;
      }
    }
    if (counterForPifia >= 2) {
      _sendToastMessage(pifiaMsg);
    } else if (counterForExito >= 2) {
      _sendToastMessage(exitoMgs);
    }

    //check for errors and if there is any, return without any value
    //I check the nullability to avoid errors
    if (maxIndex != null && minIndex != null) {
      if (maxIndex == minIndex) {
        print("error en diceComparator");
        return;
      } else {
        dicesPages[0][maxIndex].isMax = true;
        dicesPages[0][minIndex].isMin = true;
      }
    }
  }



  //build of the widget
  @override
  Widget build(BuildContext context) {
    //dont allow the user to the orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: smoothPageIndicatorController,
            children: <Widget>[
              //first
              GestureDetector(
                onTap: () {
                  //restore the values of isMin and isMax to go back to white
                  diceRestoreDefault();
                  globalRoll(2);
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        stops: const [0.90, 1],
                        begin: Alignment.centerLeft,
                        end: AlignmentDirectional.centerEnd,
                        //careful null!!!
                        colors: [Colors.teal[400]!, Colors.teal[500]!]),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DiceShape(diceData: dicesPages[0][0]),
                        DiceShape(diceData: dicesPages[0][1]),
                        DiceShape(diceData: dicesPages[0][2]),
                      ]),
                ),
              ),
              //second
              GestureDetector(
                onTap: () {
                  globalRoll(1);
                },
                child: Container(
                  color: Colors.teal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DiceShape(diceData: dicesPages[1][0]),
                      SizedBox(
                        width: ScreenSize.getFractionWidth(context, 25),
                      ),
                      DiceShape(diceData: dicesPages[1][1]),
                    ],
                  ),
                ),
              ),
              //third
              GestureDetector(
                onTap: () {
                  if (!_timerRunning) {
                    _startTimer();
                  }
                  _counter++;
                  if (_counter > 20) {
                    _resetCounter();
                    _sendToastMessage(hiddenMsg);
                  }
                  globalRoll(0);
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        stops: const [0, 0.10],
                        begin: Alignment.centerLeft,
                        end: AlignmentDirectional.centerEnd,
                        //careful null!!!
                        colors: [Colors.teal, Colors.teal[600]!]),
                  ),
                  child: Center(
                    child: DiceShape(diceData: dicesPages[2][0]),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              SmoothPageIndicator(
                controller: smoothPageIndicatorController,
                count: 3,
                effect: const JumpingDotEffect(
                  dotColor: Colors.white38,
                  activeDotColor: Colors.white,
                  dotHeight: 16,
                  dotWidth: 16,
                  verticalOffset: 10,
                  paintStyle: PaintingStyle.fill,
                ),
              ),
              SizedBox(height: ScreenSize.getFractionHeight(context, 17)),
            ]),
          ),
        ],
      ),
    );
  }
}
