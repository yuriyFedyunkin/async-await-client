import Foundation

public enum NetworkError: Error {
    case incorrectRequest
    case incorrectParameters
    case invalidBaseUrl
    case invalidResponse(error: Error)
    case parsingFailure
    case backend(_ statusCode: Int, _ data: Data)
}
