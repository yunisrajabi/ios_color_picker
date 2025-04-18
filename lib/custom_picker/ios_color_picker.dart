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
          margin: EdgeInsets.fromLTRB(
            10.0,
            0.0,
            10.0,
            MediaQuery.of(context).padding.bottom * 1.25,
          ),
          // width: maxWidth(context),
          //height: 340 + componentsHeight(context),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade50
                : Colors.grey.shade900,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
              // topRight: Radius.circular(10),
              // topLeft: Radius.circular(10),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    8,
                    4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        textScaler: TextScaler.noScaling,
                        overflow: TextOverflow.ellipsis,
                        'Color Picker',
                        style: GoogleFonts.anaheim().copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black87
                                  : Colors.white70,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.check_circle_rounded,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black87,
                          size: 24,
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
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Text(
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
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
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SizedBox(
                          height: 24,
                          width: 60,
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
                      height: 27,
                      width: 60,
                      margin: const EdgeInsets.only(right: 16, left: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.grey.shade800,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: ValueListenableBuilder<Color>(
                        valueListenable: colorController,
                        builder: (context, color, child) {
                          int alpha = (color.a * 100).toInt();
                          return Text(
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                            "$alpha%",
                            style: GoogleFonts.anaheim().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0095F6),
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
                  height: 40,
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
                                  Expanded(
                                      child: Container(color: Colors.white)),
                                  Expanded(
                                      child: Container(color: Colors.black)),
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
                              margin: const EdgeInsets.only(left: 16),
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
        ),
      ],
    );
  }
}
