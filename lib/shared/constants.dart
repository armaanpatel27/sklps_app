//purpose: constant widgets needed throughout app
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklps_app/shared/size_config.dart';

class LoadingWheel extends StatelessWidget {
  const LoadingWheel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue[500]!],
          )),
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.black,
          size: SizeConfig.screenHeight/10,
        ),
      ),
    );
  }
}
//text with built in font
class TextDefault extends StatefulWidget {
  String text;
  TextAlign? align;
  double sizeMultiplier;
  Color color;
  FontWeight? bold;
  FontStyle? style;
  TextDecoration? decoration;
  double? height;
  TextDefault({Key? key, required this.text, this.align, required this.sizeMultiplier
    , required this.color, this.bold, this.style, this.decoration, this.height}) : super(key: key);

  @override
  State<TextDefault> createState() => _TextDefaultState();
}

class _TextDefaultState extends State<TextDefault> {


  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.align,
      style: GoogleFonts.hind(
        textStyle: TextStyle(
          fontSize: SizeConfig.safeBlockVertical * widget.sizeMultiplier,
          color: widget.color,
          fontWeight: widget.bold,
          fontStyle: widget.style,
          decoration: widget.decoration,
          height: widget.height,
        ),
      ),
    );
  }
}

class TableRowColumns extends StatelessWidget {
  final String text1;
  final String text2;
  final Color initialColor;
  const TableRowColumns({Key? key, required this.text1, required this.text2, this.initialColor = Colors.black}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextDefault(
            text: text1,
            sizeMultiplier: 2,
            color: Colors.blue,
          align: TextAlign.center,
          bold: FontWeight.bold,
        ),
        TextDefault(
          text: text2,
          sizeMultiplier: 2,
          color: initialColor,
          align: TextAlign.center,
          bold: FontWeight.w500,
        ),
      ],
    );
  }
}


class TableRowColumnsAdmin extends StatefulWidget {
  String text1;
  String text2;
  bool isEditable;
  Function(String)? onChanged;
  void Function()? onTap;
  Color color;
  Color initialColor;
  TableRowColumnsAdmin({Key? key, required this.text1, required this.text2, required this.isEditable, this.onChanged, this.onTap, required this.color, this.initialColor = Colors.black}) : super(key: key);

  @override
  State<TableRowColumnsAdmin> createState() => _TableRowColumnsAdminState();
}

class _TableRowColumnsAdminState extends State<TableRowColumnsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextDefault(
          text: widget.text1,
          sizeMultiplier: 2,
          color: Colors.blue,
          align: TextAlign.center,
          bold: FontWeight.bold,
        ),
        TextFormField(
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, SizeConfig.safeBlockVertical*1.1),
            isDense: true,
          ),
          minLines: 1,
          maxLines: 3,
          enabled: widget.isEditable,
          textAlign: TextAlign.center,
          initialValue: widget.text2,
          style: TextStyle(
            fontSize: SizeConfig.safeBlockVertical * 2,
            color: widget.isEditable? widget.color: widget.initialColor,
          ),
        )
      ],
    );
  }
}

//Defines default background style for Container in UI screen
var boxDecorationBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.blue[500]!],
    ));







