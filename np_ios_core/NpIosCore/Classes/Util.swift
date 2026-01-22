import Flutter
import Foundation

public extension Optional {
  func unwrap(
    _ errorBuilder: (() -> Error)? = nil,
    file: String = #fileID,
    line: Int = #line
  ) throws -> Wrapped {
    guard let value = self else {
      throw errorBuilder?() ?? NilError("\(type(of: self)) is nil in \(file):\(line)")
    }
    return value
  }
}

public extension FlutterStandardTypedData {
  func toArray<T>(type: T.Type) throws -> [T] {
    let ptr = try data.withUnsafeBytes {
      try $0.baseAddress.unwrap().assumingMemoryBound(to: T.self)
    }
    return [T](UnsafeBufferPointer(start: ptr, count: data.count / MemoryLayout<T>.stride))
  }
}
