import Flutter
import UIKit


public class IosColorPickerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink? // EventSink for streaming data

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "ios_color_picker", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "ios_color_picker_stream", binaryMessenger: registrar.messenger())

        let instance = IosColorPickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "pickColor":
            if let args = call.arguments as? [String: Any],
               let defaultColor = args["defaultColor"] as? [String: CGFloat] {
                self.pickColor(defaultColor: defaultColor, result: result)
            } else {
                self.pickColor(defaultColor: nil, result: result)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func pickColor(defaultColor: [String: CGFloat]?, result: @escaping FlutterResult) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = defaultColor?.toUIColor() ?? .red
        colorPicker.modalPresentationStyle = .popover

        colorPicker.delegate = self

        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            rootViewController.present(colorPicker, animated: true, completion: nil)
        }

        result(nil) // Method call ends here, stream handles further updates
    }

    // MARK: - FlutterStreamHandler

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

// MARK: - UIColorPickerViewControllerDelegate

extension IosColorPickerPlugin: UIColorPickerViewControllerDelegate {
    public func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor) {
        // Stream color updates to Flutter
       if let rgba = viewController.selectedColor.toRGBA(), let eventSink = self.eventSink {
           eventSink(rgba)
       }
    }

       public func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
           // Stream color updates to Flutter
                if let rgba = viewController.selectedColor.toRGBA(), let eventSink = self.eventSink {
                    eventSink(rgba)
                }
            }
}

//    public func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
//       if let rgba = viewController.selectedColor.toRGBA(), let eventSink = self.eventSink {
//                 print("Sending color to Flutter: \(rgba)")
//                 eventSink(rgba)
//             }
//        else if let eventSink = self.eventSink {
//            eventSink(FlutterError(code: "CLOSED", message: "Color picker closed", details: nil))
//        }
//    }
//
//
//    public func colorPickerViewControllerDidCancel(_ viewController: UIColorPickerViewController) {
//        // Notify that the picker is canceled
//          if let rgba = viewController.selectedColor.toRGBA(), let eventSink = self.eventSink {
//                        print("Sending color to Flutter: \(rgba)")
//                        eventSink(rgba)
//                    }
//               else if let eventSink = self.eventSink {
//            eventSink(FlutterError(code: "CANCELLED", message: "Color picker cancelled", details: nil))
//        }
//    }



extension UIColor {
    func toRGBA() -> [String: CGFloat]? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        return [
            "red": red ,
            "green": green ,
            "blue": blue ,
            "alpha": alpha
        ]
    }
}

extension Dictionary where Key == String, Value == CGFloat {
    func toUIColor() -> UIColor {
        let red = self["red"] ?? 0
        let green = self["green"] ?? 0
        let blue = self["blue"] ?? 0
        let alpha = self["alpha"] ?? 1

        return UIColor(
            red: red ,
            green: green ,
            blue: blue ,
            alpha: alpha
        )
    }
}
