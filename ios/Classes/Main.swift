import Foundation
import UIKit
import IDVSDK

let didStartSessionEvent = "didStartSessionEvent"
let didEndSessionEvent = "didEndSessionEvent"
let didStartRestoreSessionEvent = "didStartRestoreSessionEvent"
let didContinueRemoteSessionEvent = "didContinueRemoteSessionEvent"

func methodCall(_ method: String, _ callback: @escaping Callback) {
    switch (method) {
    case("setSessionRestoreMode"): IDV.shared.sessionRestoreMode = SessionRestoreMode(rawValue: args(0))!
    case("getCurrentSessionId"): callback(IDV.shared.currentSessionId)
    case ("initialize"): initialize(callback)
    case("deinitialize"): deinitialize(callback)
    case("configureWithToken"): configureWithToken(callback, args(0))
    case("configureWithCredentials"): configureWithCredentials(callback, args(0))
    case("configureWithApiKey"): configureWithApiKey(callback, args(0))
    case("prepareWorkflow"): prepareWorkflow(callback, args(0))
    case("startWorkflow"): startWorkflow(callback, argsNullable(0))
    case("getWorkflows"): getWorkflows(callback)
    default: break
    }
}

// MARK: - Implementation

func initialize(_ callback: @escaping Callback) {
    IDV.shared.initialize(config: IDVInitConfig(), completion: { result in
        IDV.shared.delegate = delegate
        callback(generateCompletion(result.isSuccess, result.failureOrNil))
    })
}

func deinitialize(_ callback: @escaping Callback) {
    IDV.shared.deinitialize(completion: { result in
        callback(generateCompletion(result.isSuccess, result.failureOrNil))
    })
}

func configureWithToken(_ callback: @escaping Callback, _ data: [String: Any?]) {
    IDV.shared.configure(with: tokenConnectionConfigFromJSON(data), completion: { result in
        callback(generateCompletion(result.successOrNil, result.failureOrNil))
    })
}

func configureWithCredentials(_ callback: @escaping Callback, _ data: [String: Any?]) {
    IDV.shared.configure(with: credentialsConnectionConfigFromJSON(data), completion: { result in
        callback(generateCompletion(result.isSuccess, result.failureOrNil))
    })
}

func configureWithApiKey(_ callback: @escaping Callback, _ data: [String: Any?]) {
    IDV.shared.configure(with: apiKeyConnectionConfigFromJSON(data), completion: { result in
        callback(generateCompletion(result.isSuccess, result.failureOrNil))
    })
}

func prepareWorkflow(_ callback: @escaping Callback, _ data: [String: Any?]) {
    IDV.shared.prepareWorkflow(by: prepareWorkflowConfigFromJSON(data), completion: { result in
        callback(generateCompletion(generateWorkflow(result.successOrNil), result.failureOrNil))
    })
}

func startWorkflow(_ callback: @escaping Callback, _ data: [String: Any?]?) {
    IDV.shared.startWorkflow(presenter: rootViewController()!,
                             config: startWorkflowConfigFromJSON(input: data),
                             completion: { result in
        callback(generateCompletion(generateWorkflowResult(result.successOrNil), result.failureOrNil))
    })
}

func getWorkflows(_ callback: @escaping Callback) {
    IDV.shared.getWorkflows(completion: { result in
        callback(generateCompletion(result.successOrNil?.compactMap { generateWorkflow($0) },
                                    result.failureOrNil))
    })
}


// MARK: - WeakReference

class IDVDelegate: IDVSDK.IDVDelegate {
    func didStartNewSession(idv: IDV) { sendEvent(didStartSessionEvent) }
    func didEndSession(idv: IDV) { sendEvent(didStartSessionEvent) }
    func didStartRestoreSession(idv: IDV) { sendEvent(didStartSessionEvent) }
    func didContinueRemoteSession(idv: IDV) { sendEvent(didStartSessionEvent) }
}
let delegate = IDVDelegate()
