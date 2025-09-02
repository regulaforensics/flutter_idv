import Foundation
import UIKit
import IDVSDK

extension Result {
    var failureOrNil: Failure? {
        if case .failure(let error) = self { return error }
        else { return nil }
    }

    var successOrNil: Success? {
        if case .success(let value) = self { return value }
        else { return nil }
    }
}

public class JSONConstructor {
    
    // MARK: - Utils
    
    public static func toSendable(_ input: Any?) -> Any? {
        guard let input = input, !(input is NSNull) else { return nil }
        
        if let dict = input as? [String: Any],
           JSONSerialization.isValidJSONObject(dict) {
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
               let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            }
        }
        
        if let arr = input as? [Any],
           JSONSerialization.isValidJSONObject(arr) {
            if let data = try? JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted),
               let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            }
        }
        
        return input
    }
    
    private static func convertArray(_ input: [Any], _ converter: (Any) -> Any?) -> [Any] {
        return input.compactMap { converter($0) }
    }
    
    public static func generateArray(_ input: [Any]?, _ toJson: (Any) -> Any?) -> Any {
        guard let input = input else { return NSNull() }
        return convertArray(input, toJson)
    }
    
    public static func arrayFromJSON(_ input: [Any]?, _ fromJson: (Any) -> Any?) -> Any? {
        guard let input = input, !(input is NSNull) else { return nil }
        return convertArray(input, fromJson)
    }
    
    public static func base64Decode(_ input: String?) -> Data? {
        guard var input = input, !(input is NSNull) else { return nil }
        if input.hasPrefix("data"),
           let commaIndex = input.firstIndex(of: ",") {
            input = String(input[input.index(after: commaIndex)...])
        }
        return Data(base64Encoded: input)
    }
    
    public static func base64Encode(_ input: Data?) -> Any {
        guard let input = input else { return NSNull() }
        return input.base64EncodedString()
    }
    
    public static func imageWithBase64(_ input: String?) -> UIImage? {
        guard let data = base64Decode(input) else { return nil }
        return UIImage(data: data)
    }
    
    public static func base64WithImage(_ input: UIImage?) -> Any {
        guard let input = input,
              let data = input.pngData() else { return NSNull() }
        return base64Encode(data)
    }
    
    // MARK: - Init
    
    public static func generateInitCompletion(_ success: Bool, _ error: Error?) -> [String: Any] {
        return [
            "success": success,
            "error": generateError(error)
        ]
    }
    
    private static func generateError(_ error: Error?) -> Any {
        guard let error = error as NSError? else { return NSNull() }
        return [
            "code": error.code,
            "domain": error.domain,
            "message": error.localizedDescription
        ]
    }
}
