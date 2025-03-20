import 'package:flutter/material.dart';

class Tally extends StatefulWidget {
  final int points;
  final int max;
  final String text;

  const Tally({
    Key? key,
    required this.points,
    required this.max,
    required this.text,
  }) : super(key: key);

  @override
  State<Tally> createState() => _TallyState();
}

class _TallyState extends State<Tally> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  late int _oldPoints;

  @override
  void initState() {
    super.initState();
    _oldPoints = widget.points;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _animation = IntTween(begin: _oldPoints, end: widget.points).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(Tally oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.points != widget.points) {
      _oldPoints = oldWidget.points;
      _animation = IntTween(begin: _oldPoints, end: widget.points).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const width = 3;
    final max = widget.max > 0 ? widget.max : 1; // Prevent division by zero
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final points = _animation.value;
        final percent = points / max;
        
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${points.toString().padLeft(width, " ")} ${widget.text}",
                style: const TextStyle(fontSize: 21),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text("0", style: TextStyle(fontSize: 12)),
                ),
                Container(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(border: Border.all(width: 2.0)),
                  child: LinearProgressIndicator(
                    value: percent.isFinite ? percent.clamp(0.0, 1.0) : 0.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).indicatorColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "$max",
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
