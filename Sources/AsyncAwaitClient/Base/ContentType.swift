public enum ContentType: Equatable {
    case applicationJson
    case applicationPdf
    case formUrlEncoded
    
    var stringValue: String {
        switch self {
        case .applicationJson:
            return "application/json"
        case .applicationPdf:
            return "application/json"
        case .formUrlEncoded:
            return "application/x-www-form-urlencoded"
        }
    }
}
