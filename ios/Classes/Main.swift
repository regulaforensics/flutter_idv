import Foundation
import UIKit
import IDVSDK

let didStartSessionEvent = "didStartSessionEvent"
let didEndSessionEvent = "didEndSessionEvent"
let didStartRestoreSessionEvent = "didStartRestoreSessionEvent"
let didContinueRemoteSessionEvent = "didContinueRemoteSessionEvent"

func methodCall(_ method: String, _ args: [Any], _ callback: @escaping Callback) {
    switch (method) {
    case ("initialize"): initialize(callback)
//    case("getIsInitialized"): callback(IDV.shared.isInitialized())
//    case("getCurrentSessionId"): callback(IDV.shared.currentSessionId)
//    case("getSessionRestoreMode"): callback(IDV.shared.sessionRestoreMode.ordinal)
//    case("setSessionRestoreMode"): IDV.shared.sessionRestoreMode = args.first
//    case("initialize"): initialize(callback)
//    case("configureWithConnectionConfig"): configureWithConnectionConfig(callback, args(0))
//    case("configureWithUrlConnectionConfig"): configureWithUrlConnectionConfig(callback, args(0))
//    case("configureWithApiKeyConnectionConfig"): configureWithApiKeyConnectionConfig(callback, args(0))
//    case("deinitialize"): IDV.shared.deinitialize(context)
//    case("prepareWorkflow"): prepareWorkflow(callback, args(0))
//    case("getWorkflows"): getWorkflows(callback)
//    case("startWorkflow"): startWorkflow(callback, args(0))
    default: break
    }
}

// MARK: - implementation

func initialize(_ callback: @escaping Callback) {
    IDV.shared.initialize(config: IDVInitConfig(), completion: { result in
        callback(JSONConstructor.generateInitCompletion(true, result.failureOrNil))
    })
}
