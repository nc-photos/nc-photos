import Foundation

public class AppError: Error {
  public init(_ message: String? = nil, stackTrace: [String] = Thread.callStackSymbols) {
    self.message_ = message
    self.stackTrace = stackTrace.joined(separator: "\n")
  }

  public var description: String {
    return "\(message_ ?? "") (throw: \(String(describing: self))\nStack trace:\n\(stackTrace)"
  }

  public var message: String {
    return message_ == nil ? String(describing: self) : message_!
  }

  public let stackTrace: String
  private let message_: String?
}

public class NilError: AppError {
}

public class ArgumentError: AppError {
}
