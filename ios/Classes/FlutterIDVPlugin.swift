import Flutter
import UIKit

let channelID = "flutter_idv"
var eventSinks: [String: FlutterEventSink] = [:]

private var args: [Any?] = []

func sendEvent(_ event: String, _ data: Any? = nil) {
    DispatchQueue.main.async {
        if let sink = eventSinks[event] {
            sink(data.toSendable())
        }
    }
}

func args<T>(_ index: Int) -> T {
    return args[index] as! T
}

func argsNullable<T>(_ index: Int) -> T? {
    if (args[index] is NSNull) { return nil }
    return args[index] as! T?
}

public class FlutterIDVPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        func setupEventChannel(_ eventId: String) {
            let channel = FlutterEventChannel(name: "\(channelID)/event/\(eventId)", binaryMessenger: registrar.messenger())
            channel.setStreamHandler(GenericStreamHandler(eventId))
        }
        setupEventChannel(didStartSessionEvent);
        setupEventChannel(didEndSessionEvent);
        setupEventChannel(didStartRestoreSessionEvent);
        setupEventChannel(didContinueRemoteSessionEvent);
        
        let channel = FlutterMethodChannel(name: "\(channelID)/method", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(FlutterIDVPlugin(), channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        args = call.arguments as! [Any?]
        methodCall(call.method, { data in result(data.toSendable()) })
    }
}

class GenericStreamHandler: NSObject, FlutterStreamHandler {
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

let rootViewController: () -> UIViewController? = {
    for window in UIApplication.shared.windows {
        if window.isKeyWindow {
            return window.rootViewController
        }
    }
    return nil
}
