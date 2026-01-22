import Flutter
import Foundation
import Logging

/**
 * Container of pixel data stored in RGBA format
 */
public class Rgba8Image {
  public init(pixel: [UInt8], width: Int, height: Int) {
    assert(pixel.count == width * height * 4)
    self.pixel = pixel
    self.width = width
    self.height = height
  }

  public convenience init(flutterJson: [String:Any]) throws {
    let pixel = try (flutterJson["pixel"] as? FlutterStandardTypedData)
      .unwrap()
      .toArray(type: UInt8.self)
    let width = try (flutterJson["width"] as? Int).unwrap()
    let height = try (flutterJson["height"] as? Int).unwrap()
    self.init(pixel: pixel, width: width, height: height)
  }

  public convenience init(cgImage image: CGImage) throws {
    let provider = try image.dataProvider.unwrap()
    let data = try provider.data.unwrap()
    let length = CFDataGetLength(data)
    var pixels = Array<UInt8>(repeating: 0, count: length)
    pixels.withUnsafeMutableBufferPointer {
      CFDataGetBytes(data, CFRange(location: 0, length: length), $0.baseAddress)
    }
    Self.log.info("[init:CGImage] Image alpha info: \(image.alphaInfo)")
    switch image.alphaInfo {
    case .last, .premultipliedLast:
      self.init(pixel: pixels, width: image.width, height: image.height)

    case .noneSkipLast:
      for i in 0..<length / 4 {
        pixels[i * 4 + 3] = 0xFF
      }
      self.init(pixel: pixels, width: image.width, height: image.height)

    case .first, .premultipliedFirst:
      for i in 0..<length / 4 {
        let a = pixels[i * 4]
        pixels[i * 4] = pixels[i * 4 + 1]
        pixels[i * 4 + 1] = pixels[i * 4 + 2]
        pixels[i * 4 + 2] = pixels[i * 4 + 3]
        pixels[i * 4 + 3] = a
      }
      self.init(pixel: pixels, width: image.width, height: image.height)

    case .noneSkipFirst:
      for i in 0..<length / 4 {
        pixels[i * 4] = pixels[i * 4 + 1]
        pixels[i * 4 + 1] = pixels[i * 4 + 2]
        pixels[i * 4 + 2] = pixels[i * 4 + 3]
        pixels[i * 4 + 3] = 0xFF
      }
      self.init(pixel: pixels, width: image.width, height: image.height)

    case .none:
      var rgba = Array<UInt8>(repeating: 0, count: length / 3 * 4)
      for i in 0..<length / 3 {
        rgba[i * 4] = pixels[i * 3]
        rgba[i * 4 + 1] = pixels[i * 3 + 1]
        rgba[i * 4 + 2] = pixels[i * 3 + 2]
        rgba[i * 4 + 3] = 0xFF
      }
      self.init(pixel: rgba, width: image.width, height: image.height)

    case .alphaOnly:
      var rgba = Array<UInt8>(repeating: 0, count: length * 4)
      for i in 0..<length {
        rgba[i * 4] = 0
        rgba[i * 4 + 1] = 0
        rgba[i * 4 + 2] = 0
        rgba[i * 4 + 3] = pixels[i]
      }
      self.init(pixel: rgba, width: image.width, height: image.height)

    @unknown default:
      throw ArgumentError("Unknown alpha info: \(image.alphaInfo)")
    }
  }

  public func toFlutterJson() throws -> [String:Any] {
    var copy = Array(pixel)
    return try copy.withUnsafeMutableBufferPointer {
      return [
        "pixel": try FlutterStandardTypedData(
          bytes: Data(bytes: $0.baseAddress.unwrap(), count: pixel.count)
        ),
        "width": width,
        "height": height,
      ]
    }
  }

  public func toCGImage() throws -> CGImage {
    var copy = Array(pixel)
    return try copy.withUnsafeMutableBytes {
      let context = try CGContext(
        data: $0.baseAddress,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: width * 8 * 4,
        space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: CGImageAlphaInfo.last.rawValue
      ).unwrap()
      return try context.makeImage().unwrap()
    }
  }

  public let pixel: [UInt8]
  public let width: Int
  public let height: Int

  private static let log = Logger(label: "Rgba8Image")
}
