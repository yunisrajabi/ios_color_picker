import 'dart:async';
import 'dart:ui';
import 'package:ios_color_picker/custom_picker/extensions.dart';
import 'ios_color_picker_platform_interface.dart';


class NativeIosColorPicker {
  Future<Color?> getPlatformColor(
      Color? defaultColor,
      ) {
    return IosColorPickerPlatform.instance
        .getPlatformColor(defaultColor?.toMap());
  }

  Future<Stream> getPlatformColorStream(
      Color? defaultColor,
      ) {
    return IosColorPickerPlatform.instance.getPlatformColorStream();
  }
}


