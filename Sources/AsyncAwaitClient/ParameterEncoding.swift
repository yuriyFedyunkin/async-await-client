import Foundation

public typealias Parameters = [String: Any]

public enum ParameterEncoding: Equatable {

    case JSONEncoding
    case URLEncoding
    case BodyStringEncoding(_ string: String)

    func encode(request: URLRequest, params: Parameters) throws -> URLRequest {
        try encoder.encode(request: request, params: params)
    }

    var encoder: RequestParamsEncoder {
        switch self {
        case .JSONEncoding:
            return RequestParamsJSONEncoder()
        case .URLEncoding:
            return RequestParamsURLEncoder(
                arrayEncoding: .brackets,
                boolEncoding: .literal
            )
        case let .BodyStringEncoding(string):
            return RequestBodyStringEncoder(body: string)
        }
    }
}
