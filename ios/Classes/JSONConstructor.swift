import IDVSDK
import IDVModule

public func generateCompletion(_ value: Any?, _ error: IDVModule.BaseError?) -> [String: Any?] {
    return [
        "success": value,
        "error": error?.fullChain
    ]
}

// MARK: - Config

public func credentialsConnectionConfigFromJSON(_ data: [String: Any?]) -> CredentialsConnectionConfig {
    let result = CredentialsConnectionConfig (userName: data["userName"] as! String,
                                              password: data["password"] as! String,
                                              baseURL: data["baseUrl"] as! String)
    if let httpTimeoutMs = data["httpTimeoutMs"] as? NSNumber { result.httpTimeoutMs = httpTimeoutMs }
    return result
}

public func generateCredentialsConnectionConfig(_ data: CredentialsConnectionConfig) -> [String: Any?] {
    return [
        "baseUrl": data.baseURL,
        "userName": data.userName,
        "password": data.password,
        "httpTimeoutMs": data.httpTimeoutMs,
    ]
}

public func tokenConnectionConfigFromJSON(_ data: [String: Any?]) -> TokenConnectionConfig {
    return TokenConnectionConfig(url: data["url"] as! String)
}

public func generateTokenConnectionConfig(_ data: TokenConnectionConfig) -> [String: Any?] {
    return [
        "url": data.url
    ]
}

public func apiKeyConnectionConfigFromJSON(_ data: [String: Any?]) -> ApiKeyConnectionConfig {
    let result = ApiKeyConnectionConfig(apiKey: data["apiKey"] as! String,
                                        baseURL: data["baseUrl"] as! String,
                                        ttl: data["ttl"] as? NSNumber)
    if let httpTimeoutMs = data["httpTimeoutMs"] as? NSNumber { result.httpTimeoutMs = httpTimeoutMs }
    return result
}

public func generateApiKeyConnectionConfig(_ data: ApiKeyConnectionConfig) -> [String: Any?] {
    return [
        "baseUrl": data.baseURL,
        "apiKey": data.apiKey,
        "ttl": data.ttl,
        "httpTimeoutMs": data.httpTimeoutMs,
    ]
}

public func prepareWorkflowConfigFromJSON(_ data: [String: Any?]) -> PrepareWorkflowConfig {
    return PrepareWorkflowConfig(workflowId: data["workflowId"] as! String)
}

public func generatePrepareWorkflowConfig(_ data: PrepareWorkflowConfig) -> [String: Any?] {
    return [
        "workflowId": data.workflowId
    ]
}

public func startWorkflowConfigFromJSON(input: [String: Any?]?) -> StartWorkflowConfig {
    let result = StartWorkflowConfig.default()
    guard let data = input else { return result }
    
    if let locale = data["locale"] as? String { result.locale = locale }
    if let metadata = data["metadata"] as? [String: Any] { result.metadata = metadata }
    
    return result
}

public func generateStartWorkflowConfig(_ data: StartWorkflowConfig) -> [String: Any?] {
    return [
        "locale": data.locale,
        "metadata": data.metadata
    ]
}

// MARK: - Model

public func workflowFromJSON(_ input: [String: Any?]?) -> Workflow? {
    guard var it = input else { return nil }
    it["client"] = [String: Any]()
    it["steps"] = [WorkflowStep]()
    it["_description"] = it["description"]
    return try! Workflow(from: it.toDecoder())
}

public func generateWorkflow(_ input: Workflow?) -> [String: Any?]? {
    guard let it = input else { return nil }
    return [
        "id": it.id,
        "name": it.name,
        "version": it.version,
        "description": it._description,
        "defaultLocale": it.defaultLocale
    ]
}

public func workflowStepFromJSON(_ input: [String: Any?]?) -> WorkflowStep? {
    guard var it = input else { return nil }
    it["type"] = ""
    it["final"] = false
    it["client"] = [String: Any]()
    return try! WorkflowStep(from: it.toDecoder())
}

public func generateWorkflowStep(_ input: WorkflowStep?) -> [String: Any?]? {
    guard let it = input else { return nil }
    return [
        "id": it.id,
        "name": it.name
    ]
}

public func workflowResultFromJSON(_ input: [String: Any?]?) -> WorkflowResult? {
    guard let it = input else { return nil }
    return try! WorkflowResult(from: it.toDecoder())
}

public func generateWorkflowResult(_ input: WorkflowResult?) -> [String: Any?]? {
    guard let it = input else { return nil }
    return [
        "sessionId": it.sessionId,
        "finalStep": generateWorkflowStep(it.finalStep)
    ]
}
