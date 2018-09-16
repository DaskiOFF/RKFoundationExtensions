import Foundation

extension String {
    public func containsMatch(pattern: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern, options: .init(rawValue: 0))
        let range = NSMakeRange(0, self.count)
        guard let result = regex?.firstMatch(in: self, options: .init(rawValue: 0), range: range) else { return false }
        return result.range.length > 0
    }
}

extension String {
    public var isNumber: Bool {
        return self.containsMatch(pattern: "^\\d+$")
    }

    public var isEmail: Bool {
        return self.containsMatch(pattern: "^\\S+@\\S+\\.\\S+$")
    }
}
