import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ios_color_picker/custom_picker/pickers/slider_picker/slider_helper.dart';
import 'package:ios_color_picker/custom_picker/pickers_selector_row.dart';
import 'package:ios_color_picker/custom_picker/shared.dart';

import 'color_observer.dart';
import 'helpers/cache_helper.dart';
import 'history_colors.dart';

///Returns iOS Style color Picker
class IosColorPicker extends StatefulWidget {
  const IosColorPicker({
    super.key,
    required this.onColorSelected,
  });

  ///returns the selected color
  final ValueChanged<Color> onColorSelected;

  @override
  State<IosColorPicker> createState() => _IosColorPickerState();
}

class _IosColorPickerState extends State<IosColorPicker> {
  @override
  void initState() {
    CacheHelper.init();
    super.initState(); // Access the current theme
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              width: maxWidth(context),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10.0),
          // width: maxWidth(context),
          // height: 340 + componentsHeight(context),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
              // topRight: Radius.circular(10),
              // topLeft: Radius.circular(10),
            ),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  8,
                  2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Colors',
                      style: GoogleFonts.anaheim().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    IconButton(
                      highlightColor: Colors.transparent,
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.check_circle_rounded,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              PickersSelectorRow(
                onColorChanged: widget.onColorSelected,
              ),

              ///ALL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'OPACITY',
                  style: GoogleFonts.anaheim().copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: SizedBox(
                        height: 30.0,
                        child: ValueListenableBuilder<Color>(
                          valueListenable: colorController,
                          builder: (context, color, child) {
                            return ColorPickerSlider(
                                TrackType.alpha, HSVColor.fromColor(color),
                                small: false, (v) {
                              colorController.updateOpacity(v.alpha);
                              widget.onColorSelected(colorController.value);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 32,
                    width: 72,
                    margin: const EdgeInsets.only(right: 16, left: 16),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: valueColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: ValueListenableBuilder<Color>(
                      valueListenable: colorController,
                      builder: (context, color, child) {
                        int alpha = (color.a * 100).toInt();
                        return Text(
                          "$alpha%",
                          style: GoogleFonts.anaheim().copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              // const SizedBox(
              //   height: 44,
              // ),
              Divider(
                height: 30,
                thickness: 0.2,
                indent: 17,
                endIndent: 17,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: const EdgeInsets.only(
                          left: 16,
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Transform.scale(
                          scale: 1.5,
                          child: Transform.rotate(
                            angle: 0.76,
                            child: Row(
                              children: [
                                Expanded(child: Container(color: Colors.white)),
                                Expanded(child: Container(color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ValueListenableBuilder<Color>(
                        valueListenable: colorController,
                        builder: (context, color, child) {
                          return Container(
                            height: 70,
                            width: 70,
                            margin: const EdgeInsets.only(
                              left: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: color,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  HistoryColors(
                    onColorChanged: widget.onColorSelected,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
