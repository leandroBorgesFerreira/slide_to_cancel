import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SlideToCancelButton extends StatefulWidget {
  const SlideToCancelButton({Key? key}) : super(key: key);

  @override
  State<SlideToCancelButton> createState() => _SlideToCancelButtonState();
}

class _SlideToCancelButtonState extends State<SlideToCancelButton> {
  var isActive = false;
  var dragValue = 0.0;

  var duration = Duration.zero;

  Color get _getColor => isActive ? Colors.blue : Colors.grey;

  double get paddingInitial => isActive ? 25 : 10;

  double get paddingDragCorrection => isActive ? min(dragValue / 10, 15) : 0;

  double get buttonPadding => paddingInitial - paddingDragCorrection;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      height: 80,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          AnimatedPositioned(
            right: dragValue - paddingInitial + 30,
            duration: duration,
            curve: const ElasticOutCurve(0.85),
            child: GestureDetector(
              onLongPressStart: (details) {
                HapticFeedback.heavyImpact();
              },
              onLongPressMoveUpdate: (details) {
                if (details.localPosition.dx < 0) {
                  if (details.localPosition.dx < -170) {
                    setState(() {
                      isActive = false;
                      duration = const Duration(milliseconds: 200);
                      dragValue = 0;
                    });
                  } else {
                    setState(() {
                      dragValue = details.localPosition.dx.abs();
                    });
                  }
                }
              },
              onLongPress: () {
                setState(() {
                  duration = Duration.zero;
                  isActive = true;
                });
              },
              onLongPressEnd: (details) {
                setState(() {
                  duration = const Duration(milliseconds: 200);
                  isActive = false;
                  dragValue = 0;
                });
              },
              child: Material(
                color: _getColor,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                  },
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(buttonPadding),
                    child: const Icon(Icons.mic_none, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
