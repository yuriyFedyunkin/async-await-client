import Foundation

public protocol RequestType: URLRequestConvertible {
    
    /// Base URL. Full URL is constructing with base + api version (``RequestType/config/apiVersion``) + path (``RequestType/path``) + parameter
    ///  in case of GET request type
    var baseURL: String { get }
    
    /// Path to endpoint
    var path: String { get }
    
    /// Request's method (POST, GET, PUT etc.)
    var method: HTTPMethod { get }
    
    /// Request's parameters
    var parameters: [String : Any] { get }
    
    /// Encoding type (JSON, URL)
    var encoding: ParameterEncoding { get }
    
    /// Request's headers
    var headers: [String: String]? { get }
    
    var allowsNoResponseData: Bool { get }
    
    /// Content type (JSON, URL encoded)
    var contentType: ContentType { get }
    
    /// Additional settings such as API version and request timeout interval
    var config: RequestConfig { get }
}

public extension RequestType {
    var allowsNoResponseData: Bool {
        false
    }
    
    var config: RequestConfig {
        RequestConfig()
    }
}

public struct RequestConfig {
    public let apiVersion: String?
    let timeoutInterval: TimeInterval
    
    public init(
        apiVersion: String? = nil,
        timeoutInterval: TimeInterval = 60.0
    ) {
        self.apiVersion = apiVersion
        self.timeoutInterval = timeoutInterval
    }
}
