import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ios_color_picker/custom_picker/extensions.dart';
import 'ios_color_picker_platform_interface.dart';


/// An implementation of [IosColorPickerV2Platform] that uses method channels.
class MethodChannelIosColorPicker extends IosColorPickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ios_color_picker');
  final _eventChannel = EventChannel('ios_color_picker_stream');

  @override
  Future<Color?> getPlatformColor(Map<String, double>? defaultColor) async {
    final color = await methodChannel.invokeMethod<Map>(
      'pickColor',
      defaultColor != null ? {"defaultColor": defaultColor} : null,
    );
    if (color == null) {
      return null;
    }
    return Map<String, double>.from(color).toColor();
  }

  @override
  Future<Stream> getPlatformColorStream() async {
    return _eventChannel.receiveBroadcastStream();
  }
}
