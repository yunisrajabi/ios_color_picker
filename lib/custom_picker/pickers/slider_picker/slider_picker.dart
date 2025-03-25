import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ios_color_picker/custom_picker/extensions.dart';
import 'package:ios_color_picker/custom_picker/pickers/slider_picker/slider_helper.dart';

import '../../shared.dart';
import '../../utils.dart';

class SlidePicker extends StatefulWidget {
  const SlidePicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.colorModel = ColorModel.rgb,
    this.enableAlpha = true,
    this.sliderSize = const Size(260, 40),
    this.showSliderText = true,
    @Deprecated(
        'Use Theme.of(context).textTheme.bodyText1 & 2 to alter text style.')
    this.sliderTextStyle,
    this.showParams = true,
    @Deprecated('Use empty list in [labelTypes] to disable label.')
    this.showLabel = true,
    this.labelTypes = const [],
    @Deprecated(
        'Use Theme.of(context).textTheme.bodyText1 & 2 to alter text style.')
    this.labelTextStyle,
    this.showIndicator = true,
    this.indicatorSize = const Size(280, 50),
    this.indicatorAlignmentBegin = const Alignment(-1.0, -3.0),
    this.indicatorAlignmentEnd = const Alignment(1.0, 3.0),
    this.displayThumbColor = true,
    this.indicatorBorderRadius = const BorderRadius.all(Radius.zero),
  });

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final ColorModel colorModel;
  final bool enableAlpha;
  final Size sliderSize;
  final bool showSliderText;
  final TextStyle? sliderTextStyle;
  final bool showLabel;
  final bool showParams;
  final List<ColorLabelType> labelTypes;
  final TextStyle? labelTextStyle;
  final bool showIndicator;
  final Size indicatorSize;
  final AlignmentGeometry indicatorAlignmentBegin;
  final AlignmentGeometry indicatorAlignmentEnd;
  final bool displayThumbColor;
  final BorderRadius indicatorBorderRadius;

  @override
  State<StatefulWidget> createState() => _SlidePickerState();
}

class _SlidePickerState extends State<SlidePicker> {
  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);
  final TextEditingController _hexController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
    _updateHexController();
  }

  @override
  void didUpdateWidget(SlidePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
    _updateHexController();
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _updateHexController() {
    _hexController.text = currentHsvColor.toColor().toHex();
  }

  void _updateColorFromHex(String value) {
    if (value.length == 6) {
      try {
        final color = Color(int.parse('0xFF$value'));
        setState(() {
          currentHsvColor = HSVColor.fromColor(color);
        });
        widget.onColorChanged(currentHsvColor.toColor());
      } catch (e) {
        // Invalid hex code
      }
    }
  }

  Widget colorPickerSlider(TrackType trackType) {
    return ColorPickerSlider(
      trackType,
      currentHsvColor,
      small: false,
      (HSVColor color) {
        setState(() => currentHsvColor = color);
        widget.onColorChanged(currentHsvColor.toColor());
      },
    );
  }

  String getColorParams(int pos) {
    assert(pos >= 0 && pos < 4);
    if (widget.colorModel == ColorModel.rgb) {
      final Color color = currentHsvColor.toColor();
      return [
        color.red.toString(),
        color.green.toString(),
        color.blue.toString(),
        '${(color.a * 100).round()}',
      ][pos];
    } else if (widget.colorModel == ColorModel.hsv) {
      return [
        currentHsvColor.hue.round().toString(),
        (currentHsvColor.saturation * 100).round().toString(),
        (currentHsvColor.value * 100).round().toString(),
        (currentHsvColor.alpha * 100).round().toString(),
      ][pos];
    } else if (widget.colorModel == ColorModel.hsl) {
      HSLColor hslColor = hsvToHsl(currentHsvColor);
      return [
        hslColor.hue.round().toString(),
        (hslColor.saturation * 100).round().toString(),
        (hslColor.lightness * 100).round().toString(),
        (currentHsvColor.alpha * 100).round().toString(),
      ][pos];
    } else {
      return '??';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TrackType> trackTypes = [
      if (widget.colorModel == ColorModel.hsv) ...[
        TrackType.hue,
        TrackType.saturation,
        TrackType.value
      ],
      if (widget.colorModel == ColorModel.hsl) ...[
        TrackType.hue,
        TrackType.saturationForHSL,
        TrackType.lightness
      ],
      if (widget.colorModel == ColorModel.rgb) ...[
        TrackType.red,
        TrackType.green,
        TrackType.blue
      ],
    ];
    List<SizedBox> sliders = [
      for (TrackType trackType in trackTypes)
        SizedBox(
          height: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  trackType.toString().split('.').last.toUpperCase(),
                  style: GoogleFonts.anaheim().copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: colorPickerSlider(trackType)),
                    Container(
                      height: 25,
                      width: 60,
                      margin: const EdgeInsets.only(left: 28),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.grey.shade800,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Text(
                        textScaler: TextScaler.noScaling,
                        overflow: TextOverflow.ellipsis,
                        getColorParams(trackTypes.indexOf(trackType)),
                        style: GoogleFonts.anaheim().copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.showIndicator) const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textScaler: TextScaler.noScaling,
              overflow: TextOverflow.ellipsis,
              "Hex Color:  ",
              style: GoogleFonts.anaheim().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            Container(
              height: 36,
              width: 90,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      '#',
                      style: GoogleFonts.anaheim().copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      contextMenuBuilder: (context, editableTextState) {
                        return SizedBox.shrink();
                      },
                      cursorRadius: const Radius.circular(100.0),
                      controller: _hexController,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        counterText: '',
                        contentPadding:
                            EdgeInsets.only(bottom: 16.0, right: 10.0),
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.anaheim().copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                      onChanged: _updateColorFromHex,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: currentHsvColor.toColor().toHex(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          size: 24,
                          color: Colors.green,
                        ),
                        SizedBox(width: 12.0),
                        Text(
                          textScaler: TextScaler.noScaling,
                          overflow: TextOverflow.ellipsis,
                          'Copied #${currentHsvColor.toColor().toHex()}',
                          style: GoogleFonts.anaheim().copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[800]
                                    : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black12
                            : Colors.white10,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: MediaQuery.sizeOf(context).height * 0.8,
                    ),
                    elevation: 0.0,
                    dismissDirection: DismissDirection.horizontal,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[200]
                            : Colors.grey[850],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...sliders,
      ],
    );
  }
}
