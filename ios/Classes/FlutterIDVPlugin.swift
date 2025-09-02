import Flutter
import UIKit

public typealias Callback = (Any?) -> Void
public typealias EventSender = (String, Any?) -> Void
var eventSinks: [String: FlutterEventSink] = [:]

public class FlutterIDVPlugin: NSObject, FlutterPlugin {
    static let rootViewController: () -> UIViewController? = {
        for window in UIApplication.shared.windows {
            if window.isKeyWindow {
                return window.rootViewController
            }
        }
        return nil
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        func setupEventChannel(_ eventId: String) {
            let channel = FlutterEventChannel(name: "flutter_idv/event/\(eventId)", binaryMessenger: registrar.messenger())
            channel.setStreamHandler(CustomStreamHandler(eventId))
        }
        setupEventChannel(didStartSessionEvent);
        setupEventChannel(didEndSessionEvent);
        setupEventChannel(didStartRestoreSessionEvent);
        setupEventChannel(didContinueRemoteSessionEvent);
        
        let channel = FlutterMethodChannel(name: "flutter_idv/method", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(FlutterIDVPlugin(), channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let sendEvent: EventSender = { event, data in
            DispatchQueue.main.async {
                if let sink = eventSinks[event] {
                    sink(JSONConstructor.toSendable(data))
                }
            }
        }
        methodCall(call.method, call.arguments as! [Any], { data in result(JSONConstructor.toSendable(data)) })
    }
}

class CustomStreamHandler: NSObject, FlutterStreamHandler {
    private let eventId: String
    
    public init(_ eventId: String) {
        self.eventId = eventId
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        eventSinks[eventId] = eventSink
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSinks[eventId] = nil
        return nil
    }
}
