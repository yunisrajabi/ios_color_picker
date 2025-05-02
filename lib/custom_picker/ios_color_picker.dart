import 'package:flutter/material.dart';
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
  late Color _tempColor;

  @override
  void initState() {
    super.initState();
    CacheHelper.init();
    _tempColor = colorController.value; // Initialize with the current color
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
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Color(0xFFFAFAFA)
                : Color(0xFF212121),
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.0),
                PickersSelectorRow(
                  onColorChanged: (color) {
                    setState(() {
                      _tempColor = color;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Text(
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
                    'OPACITY',
                    style: TextStyle(
                      fontFamily: 'Anaheim',
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
                                setState(() {
                                  _tempColor = v.toColor();
                                });
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
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: ValueListenableBuilder<Color>(
                        valueListenable: colorController,
                        builder: (context, color, child) {
                          int alpha = (color.opacity * 100).toInt();
                          return Text(
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                            "$alpha%",
                            style: TextStyle(
                              fontFamily: 'Anaheim',
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
                const SizedBox(height: 30.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 64,
                          width: 64,
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
                                    child: Container(color: Colors.white),
                                  ),
                                  Expanded(
                                    child: Container(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<Color>(
                          valueListenable: colorController,
                          builder: (context, color, child) {
                            return Container(
                              height: 64,
                              width: 64,
                              margin: const EdgeInsets.only(left: 16),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: _tempColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    HistoryColors(
                      onColorChanged: (color) {
                        setState(() {
                          _tempColor = color;
                        });
                      },
                    )
                  ],
                ),
                Divider(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black38
                      : Colors.white54,
                  thickness: 0.2,
                  indent: 18,
                  endIndent: 18,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            overlayColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black12
                                    : Colors.white10,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          ),
                          child: Text(
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Anaheim',
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: VerticalDivider(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black12
                                  : Colors.white10,
                          thickness: 1.0,
                          width: 20.0,
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide.none,
                            overlayColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black12
                                    : Colors.white10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          ),
                          child: Text(
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                            'Done',
                            style: TextStyle(
                              fontFamily: 'Anaheim',
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          onPressed: () {
                            widget.onColorSelected(_tempColor);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// class _IosColorPickerState extends State<IosColorPicker> {
//   @override
//   void initState() {
//     CacheHelper.init();
//     super.initState(); // Access the current theme
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: InkWell(
//             splashColor: Colors.transparent,
//             focusColor: Colors.transparent,
//             onTap: () => Navigator.pop(context),
//             child: SizedBox(
//               width: maxWidth(context),
//             ),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.fromLTRB(
//             10.0,
//             0.0,
//             10.0,
//             MediaQuery.of(context).padding.bottom * 1.25,
//           ),
//           // width: maxWidth(context),
//           //height: 340 + componentsHeight(context),
//           decoration: BoxDecoration(
//             color: Theme.of(context).brightness == Brightness.light
//                 ? Color(0xFFFAFAFA)
//                 : Color(0xFF212121),
//             borderRadius: BorderRadius.all(
//               Radius.circular(20.0),
//               // topRight: Radius.circular(10),
//               // topLeft: Radius.circular(10),
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               // mainAxisAlignment: MainAxisAlignment.start,
//               // crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20.0),
//                 // Padding(
//                 //   padding: const EdgeInsets.fromLTRB(
//                 //     20,
//                 //     0,
//                 //     8,
//                 //     4,
//                 //   ),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     crossAxisAlignment: CrossAxisAlignment.center,
//                 //     children: [
//                 //       Text(
//                 //         textScaler: TextScaler.noScaling,
//                 //         overflow: TextOverflow.ellipsis,
//                 //         'Color Picker',
//                 //         style: TextStyle(
//                 //           fontFamily: 'Anaheim',
//                 //           fontSize: 18,
//                 //           fontWeight: FontWeight.w600,
//                 //           color:
//                 //               Theme.of(context).brightness == Brightness.light
//                 //                   ? Colors.black
//                 //                   : Colors.white,
//                 //         ),
//                 //       ),
//                 //       IconButton(
//                 //         onPressed: () => Navigator.pop(context),
//                 //         icon: Icon(
//                 //           Icons.check_circle_rounded,
//                 //           color: Theme.of(context).brightness == Brightness.dark
//                 //               ? Colors.white
//                 //               : Colors.black,
//                 //           size: 24,
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 PickersSelectorRow(
//                   onColorChanged: widget.onColorSelected,
//                 ),

//                 ///ALL
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 20.0,
//                     right: 20.0,
//                   ),
//                   child: Text(
//                     textScaler: TextScaler.noScaling,
//                     overflow: TextOverflow.ellipsis,
//                     'OPACITY',
//                     style: TextStyle(
//                       fontFamily: 'Anaheim',
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: Theme.of(context).brightness == Brightness.light
//                           ? Colors.black
//                           : Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                         child: SizedBox(
//                           height: 24,
//                           width: 60,
//                           child: ValueListenableBuilder<Color>(
//                             valueListenable: colorController,
//                             builder: (context, color, child) {
//                               return ColorPickerSlider(
//                                   TrackType.alpha, HSVColor.fromColor(color),
//                                   small: false, (v) {
//                                 colorController.updateOpacity(v.alpha);
//                                 widget.onColorSelected(colorController.value);
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 27,
//                       width: 60,
//                       margin: const EdgeInsets.only(right: 16, left: 16),
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           // Theme.of(context).brightness == Brightness.light
//                           //     ? Colors.white
//                           //     : Colors.grey.shade800,
//                           borderRadius: BorderRadius.all(Radius.circular(100))),
//                       child: ValueListenableBuilder<Color>(
//                         valueListenable: colorController,
//                         builder: (context, color, child) {
//                           int alpha = (color.a * 100).toInt();
//                           return Text(
//                             textScaler: TextScaler.noScaling,
//                             overflow: TextOverflow.ellipsis,
//                             "$alpha%",
//                             style: TextStyle(
//                               fontFamily: 'Anaheim',
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF0095F6),
//                             ),
//                           );
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 30.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Stack(
//                       children: [
//                         Container(
//                           height: 70,
//                           width: 70,
//                           clipBehavior: Clip.antiAliasWithSaveLayer,
//                           margin: const EdgeInsets.only(
//                             left: 16,
//                           ),
//                           decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(10),
//                             ),
//                           ),
//                           child: Transform.scale(
//                             scale: 1.5,
//                             child: Transform.rotate(
//                               angle: 0.76,
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(color: Colors.white),
//                                   ),
//                                   Expanded(
//                                     child: Container(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         ValueListenableBuilder<Color>(
//                           valueListenable: colorController,
//                           builder: (context, color, child) {
//                             return Container(
//                               height: 70,
//                               width: 70,
//                               margin: const EdgeInsets.only(left: 16),
//                               decoration: BoxDecoration(
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(10),
//                                 ),
//                                 color: color,
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     HistoryColors(
//                       onColorChanged: widget.onColorSelected,
//                     )
//                   ],
//                 ),
//                 Divider(
//                   color: Theme.of(context).brightness == Brightness.light
//                       ? Colors.black38
//                       : Colors.white54,
//                   thickness: 0.2,
//                   indent: 17,
//                   endIndent: 17,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             overlayColor:
//                                 Theme.of(context).brightness == Brightness.light
//                                     ? Colors.black12
//                                     : Colors.white10,
//                             side: BorderSide.none,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(100.0),
//                             ),
//                           ),
//                           child: Text(
//                             textScaler: TextScaler.noScaling,
//                             overflow: TextOverflow.ellipsis,
//                             'Cancel',
//                             style: TextStyle(
//                               fontFamily: 'Anaheim',
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Theme.of(context).brightness ==
//                                       Brightness.light
//                                   ? Colors.black
//                                   : Colors.white,
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20.0,
//                         child: VerticalDivider(
//                           color:
//                               Theme.of(context).brightness == Brightness.light
//                                   ? Colors.black12
//                                   : Colors.white10,
//                           thickness: 1.0,
//                           width: 20.0,
//                         ),
//                       ),
//                       Expanded(
//                         child: OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             side: BorderSide.none,
//                             overlayColor:
//                                 Theme.of(context).brightness == Brightness.light
//                                     ? Colors.black12
//                                     : Colors.white10,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(100.0),
//                             ),
//                           ),
//                           child: Text(
//                             textScaler: TextScaler.noScaling,
//                             overflow: TextOverflow.ellipsis,
//                             'Done',
//                             style: TextStyle(
//                               fontFamily: 'Anaheim',
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Theme.of(context).brightness ==
//                                       Brightness.light
//                                   ? Colors.black
//                                   : Colors.white,
//                             ),
//                           ),
//                           onPressed: () {
//                             widget.onColorSelected(colorController.value);
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
