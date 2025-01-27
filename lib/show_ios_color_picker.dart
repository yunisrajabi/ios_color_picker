import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_picker/color_observer.dart';
import 'custom_picker/ios_color_picker.dart';
import 'custom_picker/extensions.dart';
import 'native_picker/ios_color_picker_platform_interface.dart';

class ShowIOSColorPicker {
  Color selectedColor = Colors.green;
  static const _eventChannel = EventChannel('ios_color_picker_stream');
  StreamSubscription? _colorSubscription;

  ///iOS Native color Picker, Only for iOS
  Future<void> showNativeIosColorPicker({
    required ValueChanged<Color> onColorChanged,
    Color? startingColor,
  }) async {
    if (Platform.isIOS || Platform.isMacOS) {
      selectedColor = startingColor ?? selectedColor;

      IosColorPickerPlatform.instance.getPlatformColor(selectedColor.toMap());
      _colorSubscription =
          _eventChannel.receiveBroadcastStream().listen((event) {
        if (event != null) {
          selectedColor = (event as Map<Object?, Object?>).toColor();

          onColorChanged(selectedColor);
        }
      }, onError: (err) {});
    } else {
      throw "Platform is wrong";
    }
  }

  void showIOSCustomColorPicker({
    required BuildContext context,
    required ValueChanged<Color> onColorChanged,
    Color? startingColor,
  }) async {
    colorController.value = startingColor ?? selectedColor;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return IosColorPicker(
            onColorSelected: (value) {
              selectedColor = value;
              onColorChanged(selectedColor);
            },
          );
        });
  }
}
