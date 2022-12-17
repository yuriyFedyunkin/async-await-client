import Foundation

public struct RequestBodyStringEncoder: RequestParamsEncoder {
    
    func encode(request: URLRequest, params: Parameters) throws -> URLRequest {
        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
        var urlRequest = request
        urlRequest.httpBody = data
        return urlRequest
    }
    
    private let body: String
    
    public init(body: String) {
        self.body = body
    }
}

extension RequestBodyStringEncoder {
    enum Errors: Error {
        case encodingProblem
    }
}

extension RequestBodyStringEncoder.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .encodingProblem: return "Encoding problem"
        }
    }
}
