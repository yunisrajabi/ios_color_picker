import 'package:flutter/material.dart';
import 'package:ios_color_picker/custom_picker/pickers/area_picker.dart';
import 'package:ios_color_picker/custom_picker/pickers/grid_picker.dart';
import 'package:ios_color_picker/custom_picker/pickers/slider_picker/slider_picker.dart';
import 'package:ios_color_picker/custom_picker/shared.dart';

import 'color_observer.dart';
import 'helpers/cache_helper.dart';

class PickersSelectorRow extends StatefulWidget {
  final ValueChanged<Color> onColorChanged;
  const PickersSelectorRow({super.key, required this.onColorChanged});

  @override
  State<PickersSelectorRow> createState() => _PickersSelectorRowState();
}

class _PickersSelectorRowState extends State<PickersSelectorRow> {
  int typeIndex = 0;
  final List<String> typeText = ["Grids", "Spectrum", "Sliders"];

  @override
  void initState() {
    (CacheHelper().getData(key: "selector_index") as Future<dynamic>)
        .then((onValue) {
      if (onValue != null && onValue is int) {
        setState(() {
          typeIndex = onValue;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    CacheHelper().setData(value: typeIndex, key: "selector_index");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(2),
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 0.5),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.grey.shade800,
            border: Border.all(color: Colors.black.withValues(alpha: 0.02)),
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        if (index != 2)
                          Container(
                            height: 16,
                            width: 1,
                            color: Colors.transparent,
                            //  const Color(0xffCFCFD5)
                            //     .withValues(alpha: 0.2),
                          )
                        else
                          const SizedBox(height: 16, width: 1),
                      ],
                    ),
                  );
                }),
              ),
              AnimatedAlign(
                alignment: typeIndex == 0
                    ? Alignment.centerLeft
                    : typeIndex == 1
                        ? Alignment.center
                        : Alignment.centerRight,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: ((maxWidth(context) - 40) / 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF0095F6),
                    //color: selectedSliderColor,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withValues(alpha: 0.04),
                    //     blurRadius: 1,
                    //     offset: const Offset(0, 1),
                    //   ),
                    //   BoxShadow(
                    //     color: Colors.black.withValues(alpha: 0.12),
                    //     blurRadius: 8,
                    //     offset: const Offset(0, 3),
                    //   ),
                    // ],
                  ),
                ),
              ),
              Row(
                children: List.generate(3, (index) {
                  return Expanded(
                      child: InkWell(
                    onTap: () {
                      setState(() {
                        typeIndex = index;
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              textScaler: TextScaler.noScaling,
                              overflow: TextOverflow.ellipsis,
                              typeText[index],
                              style: TextStyle(
                                fontFamily: 'Anaheim',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? typeIndex == index
                                        ? Colors.white
                                        : Colors.black
                                    : Colors.white,
                              ),
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .bodyMedium
                              //     ?.copyWith(
                              //       color: Colors.white,
                              //       fontSize: 13,
                              //       fontWeight: typeIndex == index
                              //           ? FontWeight.w700
                              //           : FontWeight.w600,
                              //),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
                }),
              ),
            ],
          ),
        ),
        if (typeIndex == 0)
          ValueListenableBuilder<Color>(
            valueListenable: colorController,
            builder: (context, color, child) {
              return GridPicker(onColorChanged: (v) {
                colorController.updateColor(v);
                widget.onColorChanged(colorController.value);
              });
            },
          ),
        if (typeIndex == 1)
          ValueListenableBuilder<Color>(
            valueListenable: colorController,
            builder: (context, color, child) {
              return AreaColorPicker(
                pickerColor: colorController.value,
                onColorChanged: (v) {
                  colorController.updateColor(v);
                  widget.onColorChanged(colorController.value);
                },
                paletteType: ColorsType.hslWithSaturation,
              );
            },
          ),
        if (typeIndex == 2)
          Container(
            height: componentsHeight(context),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            alignment: Alignment.topCenter,
            margin:
                const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 17),
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: ValueListenableBuilder<Color>(
              valueListenable: colorController,
              builder: (context, color, child) {
                return SlidePicker(
                  enableAlpha: false,
                  pickerColor: color,
                  onColorChanged: (Color value) {
                    colorController.updateColor(value);
                    widget.onColorChanged(colorController.value);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
