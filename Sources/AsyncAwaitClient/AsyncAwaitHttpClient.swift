import Foundation

public protocol AsyncAwaitHttpClient {
    func perform<T: Decodable>(request: RequestType, decoder: JSONDecoder) async throws -> T
    func download(request: RequestType) async throws -> Data
}

public final class AsyncAwaitHttpClientImp: AsyncAwaitHttpClient {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func perform<T: Decodable>(request: RequestType, decoder: JSONDecoder) async throws -> T {
        guard let urlRequest = try? request.asURLRequest() else {
            throw NetworkError.incorrectRequest
        }
        
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse else {
                if let decodedResponse = try? decoder.decode(T.self, from: data) {
                    return decodedResponse
                }
                throw NetworkError.parsingFailure
            }
            
            switch response.statusCode {
            case 200 ..< 300:
                guard let decodedResponse = try? decoder.decode(T.self, from: data) else {
                    throw NetworkError.parsingFailure
                }
                return decodedResponse
            default:
                throw NetworkError.backend(response.statusCode, data)
            }
        } catch {
            throw NetworkError.invalidResponse(error: error)
        }
    }
    
    public func download(request: RequestType) async throws -> Data {
        guard let urlRequest = try? request.asURLRequest() else {
            throw NetworkError.incorrectRequest
        }
        
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            return data
        } catch {
            throw NetworkError.invalidResponse(error: error)
        }
    }
}
