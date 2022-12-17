import Foundation

public struct RequestParamsJSONEncoder: RequestParamsEncoder {
    func encode(request: URLRequest, params: Parameters) throws -> URLRequest {
        var requestWithParams = request
        
        do {
            let dataParams = try JSONSerialization.data(
                withJSONObject: params,
                options: .prettyPrinted
            )
            requestWithParams.httpBody = dataParams
        } catch {
            throw NetworkError.incorrectParameters
        }
        
        return requestWithParams
    }
}
