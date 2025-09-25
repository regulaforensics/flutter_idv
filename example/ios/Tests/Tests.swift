import XCTest
import IDVSDK
import flutter_idv

class Tests: XCTestCase {
    // MARK: - Config
    
    func test_credentialsConnectionConfig() {
        compare(name: "credentialsConnectionConfig", fromJson: credentialsConnectionConfigFromJSON, generate: generateCredentialsConnectionConfig)
    }
    
    func test_tokenConnectionConfig() {
        compare(name: "tokenConnectionConfig", fromJson: tokenConnectionConfigFromJSON, generate: generateTokenConnectionConfig)
    }
    
    func test_apiKeyConnectionConfig() {
        compare(name: "apiKeyConnectionConfig", fromJson: apiKeyConnectionConfigFromJSON, generate: generateApiKeyConnectionConfig)
    }
    
    func test_prepareWorkflowConfig() {
        compare(name: "prepareWorkflowConfig", fromJson: prepareWorkflowConfigFromJSON, generate: generatePrepareWorkflowConfig)
    }
    
    func test_startWorkflowConfig() {
        compare(name: "startWorkflowConfig", fromJson: startWorkflowConfigFromJSON, generate: generateStartWorkflowConfig)
    }
    
    // MARK: - Model
    
    func test_workflow() {
        compare(name: "workflow", fromJson: workflowFromJSON, generate: generateWorkflow)
    }
    
    func test_workflowStep() {
        compare(name: "workflowStep", fromJson: workflowStepFromJSON, generate: generateWorkflowStep)
    }
    
        func test_workflowResult() {
            compare(name: "workflowResult", fromJson: workflowResultFromJSON, generate: generateWorkflowResult)
        }
}
