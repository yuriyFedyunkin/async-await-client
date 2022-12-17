import Foundation

protocol RequestParamsEncoder {
    func encode(request: URLRequest, params: Parameters) throws -> URLRequest
}
