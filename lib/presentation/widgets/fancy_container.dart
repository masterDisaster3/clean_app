
import 'package:flutter/material.dart';

class FancyContainer extends StatefulWidget {
  const FancyContainer({
    Key? key,
    this.height,
    this.width,
    this.color1,
    this.color2,
    this.textcolor,
    this.subtitlecolor,
    this.padding,
    required Widget child,
  }) : _child = child, super(key: key);

  final double? width;
  final double? height;
  final Color? color1;
  final Color? color2;
  final Color? textcolor;
  final Color? subtitlecolor;
  final EdgeInsetsGeometry? padding;
  final Widget _child;

  @override
  // ignore: library_private_types_in_public_api
  _FancyContainerState createState() => _FancyContainerState();
}

class _FancyContainerState extends State<FancyContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width, 
        //?? MediaQuery.of(context).size.width * 0.80,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(colors: [
            widget.color1 ?? const Color(0xFFCB1841),
            widget.color2 ?? const Color(0xFF2604DE)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: const [
             BoxShadow(
              color: Colors.grey,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: widget._child
    );
  }
}
