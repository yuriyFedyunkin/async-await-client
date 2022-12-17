import Foundation

public protocol AsyncAwaitHttpClient {
    func perform<T: Decodable>(request: RequestType, decoder: JSONDecoder) async -> Result<T, Error>
    func download(request: RequestType) async -> Result<Data, Error>
}

public final class AsyncAwaitHttpClientImp: AsyncAwaitHttpClient {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func perform<T: Decodable>(request: RequestType, decoder: JSONDecoder) async -> Result<T, Error> {
        guard let urlRequest = try? request.asURLRequest() else {
            return .failure(NetworkError.incorrectRequest)
        }
        
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse else {
                if let decodedResponse = try? decoder.decode(T.self, from: data) {
                    return .success(decodedResponse)
                }
                return .failure(NetworkError.parsingFailure)
            }
            
            switch response.statusCode {
            case 200 ..< 300:
                guard let decodedResponse = try? decoder.decode(T.self, from: data) else {
                    return .failure(NetworkError.parsingFailure)
                }
                return .success(decodedResponse)
            default:
                return .failure(NetworkError.backend(response.statusCode, data))
            }
        } catch {
            return .failure(NetworkError.invalidResponse(error: error))
        }
    }
    
    public func download(request: RequestType) async -> Result<Data, Error> {
        guard let urlRequest = try? request.asURLRequest() else {
            return .failure(NetworkError.incorrectRequest)
        }
        
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            return .success(data)
        } catch {
            return .failure(NetworkError.invalidResponse(error: error))
        }
    }
}
