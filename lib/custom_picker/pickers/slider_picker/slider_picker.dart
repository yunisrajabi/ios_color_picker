import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ios_color_picker/custom_picker/extensions.dart';
import 'package:ios_color_picker/custom_picker/pickers/slider_picker/slider_helper.dart';
import 'package:toastification/toastification.dart';

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
    _hexController.text = '#${currentHsvColor.toColor().toHex().toUpperCase()}';
  }

  void _updateColorFromHex(String value) {
    // Ensure '#' is always present
    final hexCode = value.startsWith('#') ? value.substring(1) : value;

    if (hexCode.length == 6) {
      try {
        final color = Color(int.parse('0xFF$hexCode'));
        setState(() {
          currentHsvColor = HSVColor.fromColor(color);
        });
        widget.onColorChanged(currentHsvColor.toColor());
      } catch (e) {
        // Invalid hex code
      }
    }

    // Update the text field to include '#'
    if (!value.startsWith('#')) {
      _hexController.text = '#$value';
      _hexController.selection = TextSelection.fromPosition(
        TextPosition(offset: _hexController.text.length),
      );
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
          height: MediaQuery.of(context).size.height * 0.075,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  trackType.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Anaheim',
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
                      margin: const EdgeInsets.only(left: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          // Theme.of(context).brightness == Brightness.light
                          //     ? Colors.white
                          //     : Colors.grey.shade800,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Text(
                        textScaler: TextScaler.noScaling,
                        overflow: TextOverflow.ellipsis,
                        getColorParams(trackTypes.indexOf(trackType)),
                        style: TextStyle(
                          fontFamily: 'Anaheim',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFF0095F6)
                                  : Color(0xFF61B5FA),
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
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                textScaler: TextScaler.noScaling,
                overflow: TextOverflow.ellipsis,
                "Hex Color:  ",
                style: TextStyle(
                  fontFamily: 'Anaheim',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
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
                maxLength: 7,
                decoration: InputDecoration(
                  filled: false,
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xFF303030),
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0095F6)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Anaheim',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Color(0xFF0095F6)
                      : Color(0xFF61B5FA),
                ),
                onChanged: _updateColorFromHex,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^#?[0-9A-Fa-f]*$')),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 20),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: currentHsvColor.toColor().toHex().toUpperCase(),
                  ),
                );
                SnackBarHelper.show(
                  context,
                  'Copied #${currentHsvColor.toColor().toHex().toUpperCase()}',
                  messageType: MessageType.success,
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

enum MessageType { success, error, warning }

class SnackBarHelper {
  static void show(BuildContext context, String message,
      {MessageType messageType = MessageType.success, bool showIcon = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      ToastificationType toastType;
      IconData icon;
      Color? iconColor;

      switch (messageType) {
        case MessageType.success:
          toastType = ToastificationType.success;
          icon = Icons.check_circle_rounded;
          iconColor = Colors.green;
          break;
        case MessageType.error:
          toastType = ToastificationType.error;
          icon = Icons.cancel_rounded;
          iconColor = Color(0xFFF44336);
          break;
        case MessageType.warning:
          toastType = ToastificationType.warning;
          icon = Icons.error_rounded;
          iconColor = Color(0xFFEAB002);
          break;
      }

      toastification.show(
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(16.0),
        context: context,
        description: Text(
          message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontFamily: 'Anaheim',
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        borderSide: BorderSide(color: iconColor, width: 0.3),
        icon: Icon(icon, size: 30.0, color: iconColor),
        showIcon: true,
        style: ToastificationStyle.flatColored,
        dismissDirection: DismissDirection.horizontal,
        closeButton: ToastCloseButton(
          showType: CloseButtonShowType.none,
        ),
        autoCloseDuration: Duration(seconds: 3),
        margin: EdgeInsets.fromLTRB(
          20.0,
          0.0,
          20.0,
          MediaQuery.sizeOf(context).height * 0.77,
        ),
        type: toastType,
        showProgressBar: true,
        progressBarTheme: ProgressIndicatorThemeData(
          color: iconColor,
          linearTrackColor: iconColor.withValues(alpha: 0.1),
          linearMinHeight: 1.0,
        ),
      );
    });
  }
}
