import Flutter
import JxlCoder
import Logging
import NpIosCore
import UIKit

public class NpPlatformImageFormatJxlPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()
    let api = NpPlatformImageFormatJxlPlugin()
    MyHostApiSetup.setUp(binaryMessenger: messenger, api: api)
  }
}

extension NpPlatformImageFormatJxlPlugin: MyHostApi {
  func load(
    filepath: String, w: Int64?, h: Int64?, completion: @escaping (Result<Image, Error>) -> Void
  ) {
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let uiImage: UIImage
        if let w = w, let h = h {
          let size = try JXLCoder.getSize(url: URL.init(filePath: filepath))
          let dstSize = Self.fitSize(size: size, bbox: CGSize(width: Int(w), height: Int(h)))
          uiImage = try JXLCoder.decode(url: URL.init(filePath: filepath), rescale: dstSize)
        } else {
          uiImage = try JXLCoder.decode(url: URL.init(filePath: filepath))
        }
        let rgba8 = try Rgba8Image(uiImage: uiImage)
        let result = Image(
          pixel: rgba8.pixel.toFlutterTypedData(), width: Int64(rgba8.width),
          height: Int64(rgba8.height))
        completion(.success(result))
      } catch let e {
        Self.log.error("Failed to decode file: \(filepath) (\(e.localizedDescription))")
        completion(
          .failure(
            PigeonError(
              code: "decode-error", message: "Failed to decode file",
              details: e.localizedDescription)))
      }
    }
  }

  func loadBytes(
    bytes: FlutterStandardTypedData, w: Int64?, h: Int64?,
    completion: @escaping (Result<Image, Error>) -> Void
  ) {
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let uiImage: UIImage
        if let w = w, let h = h {
          let size = try JXLCoder.getSize(data: bytes.data)
          let dstSize = Self.fitSize(size: size, bbox: CGSize(width: Int(w), height: Int(h)))
          uiImage = try JXLCoder.decode(data: bytes.data, rescale: dstSize)
        } else {
          uiImage = try JXLCoder.decode(data: bytes.data)
        }
        let rgba8 = try Rgba8Image(uiImage: uiImage)
        let result = Image(
          pixel: rgba8.pixel.toFlutterTypedData(), width: Int64(rgba8.width),
          height: Int64(rgba8.height))
        completion(.success(result))
      } catch let e {
        Self.log.error("Failed to decode data (\(e.localizedDescription))")
        completion(
          .failure(
            PigeonError(
              code: "decode-error", message: "Failed to decode data",
              details: e.localizedDescription)))
      }
    }
  }

  func loadMetadata(filepath: String, completion: @escaping (Result<Metadata?, Error>) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let size = try JXLCoder.getSize(url: URL.init(filePath: filepath))
        let result = Metadata(w: Int64(size.width), h: Int64(size.height))
        completion(.success(result))
      } catch let e {
        Self.log.error("Failed to decode file: \(filepath) (\(e.localizedDescription))")
        completion(
          .failure(
            PigeonError(
              code: "decode-error", message: "Failed to decode file",
              details: e.localizedDescription)))
      }
    }
  }

  func save(img: Image, filepath: String, completion: @escaping (Result<Bool, Error>) -> Void) {
    // TODO: Implement JXL image saving
    completion(
      .failure(
        PigeonError(code: "NOT_IMPLEMENTED", message: "save method not implemented", details: nil)))
  }

  func convertJpeg(
    filepath: String, w: Int64?, h: Int64?, completion: @escaping (Result<Void, Error>) -> Void
  ) {
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let uiImage: UIImage
        if let w = w, let h = h {
          let size = try JXLCoder.getSize(url: URL.init(filePath: filepath))
          let dstSize = Self.fitSize(size: size, bbox: CGSize(width: Int(w), height: Int(h)))
          uiImage = try JXLCoder.decode(url: URL.init(filePath: filepath), rescale: dstSize)
        } else {
          uiImage = try JXLCoder.decode(url: URL.init(filePath: filepath))
        }
        guard let jpegData = uiImage.jpegData(compressionQuality: 0.85) else {
          Self.log.error("Failed to compress as JPEG: \(filepath)")
          completion(
            .failure(
              PigeonError(
                code: "compress-error", message: "Failed to compress as JPEG", details: nil)))
          return
        }
        do {
          try jpegData.write(to: URL(filePath: filepath))
          completion(.success(()))
        } catch let e {
          Self.log.error("Failed to write JPEG file: \(filepath) (\(e.localizedDescription))")
          completion(
            .failure(
              PigeonError(
                code: "compress-error", message: "Failed to write JPEG",
                details: e.localizedDescription)))
        }
      } catch let e {
        Self.log.error("Failed to decode file: \(filepath) (\(e.localizedDescription))")
        completion(
          .failure(
            PigeonError(
              code: "decode-error", message: "Failed to decode file",
              details: e.localizedDescription)))
      }
    }
  }

  private static func fitSize(size: CGSize, bbox: CGSize) -> CGSize {
    let aspectRatio = size.width / size.height
    let bboxAspectRatio = bbox.width / bbox.height

    if aspectRatio > bboxAspectRatio {
      // Fit by width
      return CGSize(width: bbox.width, height: bbox.width / aspectRatio)
    } else {
      // Fit by height
      return CGSize(width: bbox.height * aspectRatio, height: bbox.height)
    }
  }

  private static let log = Logger(label: "NpPlatformImageFormatJxlPlugin")
}
