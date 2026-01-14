public typealias Callback = (Any?) -> Void

extension Any? {
    func toSendable() -> Any {
        guard let self else { return NSNull() }
        if self is [String: Any?] || self is [Any?] {
            let data = try! JSONSerialization.data(withJSONObject: fixNulls(self), options: .prettyPrinted)
            return String(data: data, encoding: .utf8)!
        }
        return self
    }
}

func fixNulls(_ value: Any?) -> Any {
    guard let value else { return NSNull() }
    switch value {
    case let value as [String: Any?]:
        var dict = [String: Any]()
        for (k, v) in value { dict[k] = fixNulls(v) }
        return dict
    case let value as [Any?]: return value.map { fixNulls($0) }
    default: return value
    }
}

extension [String: Any?] {
    func toDecoder() -> Decoder {
        let data = try! JSONSerialization.data(withJSONObject: fixNulls(self), options: .prettyPrinted)
        return try! JSONDecoder().decode(DecoderWrapper.self, from: data).decoder
    }
}
struct DecoderWrapper: Decodable {
    let decoder: Decoder
    init(from decoder: Decoder) { self.decoder = decoder }
}

extension Result {
    var successOrNil: Success? {
        if case .success(let value) = self { return value }
        else { return nil }
    }
    
    var failureOrNil: Failure? {
        if case .failure(let error) = self { return error }
        else { return nil }
    }
    
    var isSuccess: Bool {
        if case .success = self { return true }
        else { return false }
    }
}
