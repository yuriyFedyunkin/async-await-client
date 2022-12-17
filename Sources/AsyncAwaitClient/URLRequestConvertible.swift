import Foundation

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

public extension RequestType {
    
    func asURLRequest() throws -> URLRequest {
        guard var url = URL(string: baseURL) else {
            throw NetworkError.invalidBaseUrl
        }
        
        if let apiVersion = config.apiVersion {
            url.appendPathComponent(apiVersion)
        }
        
        url = url.appendingPathComponent(path)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: config.timeoutInterval
        )
        
        request.httpMethod = method.stringValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(contentType.stringValue, forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        return try encoding.encode(request: request, params: parameters)
    }
}
