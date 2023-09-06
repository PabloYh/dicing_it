import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dice_data.dart';
import 'screen_size.dart';

class DiceShape extends StatefulWidget {
  const DiceShape({required this.diceData, super.key});

  final DiceData diceData;
  final int animationDuration = 1;

  @override
  State<DiceShape> createState() => _DiceShapeState();
}

class _DiceShapeState extends State<DiceShape> {
  void returnStartAnim() {
    widget.diceData.isAnimating = false;
  }

  Color? minMaxColor() {
    if (widget.diceData.isMin) {
      return Colors.red[300];
    } else if (widget.diceData.isMax) {
      return Colors.lightGreen[300];
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSize.getFractionHeight(context, 8.4118),
      width: ScreenSize.getFractionHeight(context, 8.4118),
      child: Stack(children: [
        //Shadow container
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  width: widget.diceData.isAnimating
                      ? ScreenSize.getFractionHeight(context, 9.67)
                      : ScreenSize.getFractionHeight(context, 9),
                  height: widget.diceData.isAnimating
                      ? ScreenSize.getFractionHeight(context, 9.67)
                      : ScreenSize.getFractionHeight(context, 9),
                  curve: Curves.easeInOut,
                  onEnd: returnStartAnim,
                  duration: Duration(seconds: widget.animationDuration),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: ScreenSize.getFractionWidth(context, 72),
                      color: Colors.black26,
                    ),
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      style: GoogleFonts.josefinSans(
                        fontSize: ScreenSize.getFractionWidth(context, 9.47),
                        color: Colors.black12,
                      ),
                      duration: DiceData.fractionOfRollingDuration(1),
                      curve: Curves.bounceInOut,
                      child: Text(
                        widget.diceData.value.toString(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        //Front container
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedContainer(
                  width: widget.diceData.isAnimating
                      ? ScreenSize.getFractionHeight(context, 9.67)
                      : ScreenSize.getFractionHeight(context, 9),
                  height: widget.diceData.isAnimating
                      ? ScreenSize.getFractionHeight(context, 9.67)
                      : ScreenSize.getFractionHeight(context, 9),
                  curve: Curves.easeInOut,
                  onEnd: returnStartAnim,
                  duration: DiceData.fractionOfRollingDuration(1),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: ScreenSize.getFractionWidth(context, 72),
                    ),
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      style: GoogleFonts.josefinSans(
                        fontSize: ScreenSize.getFractionWidth(context, 9.47),
                        color: minMaxColor(),
                      ),
                      duration: Duration(seconds: widget.animationDuration),
                      curve: Curves.bounceInOut,
                      child: Text(
                        widget.diceData.value.toString(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
