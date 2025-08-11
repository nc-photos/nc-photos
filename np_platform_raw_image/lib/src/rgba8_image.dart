import 'dart:typed_data';

/// Container of pixel data stored in RGBA format
class Rgba8Image {
  const Rgba8Image(this.pixel, this.width, this.height);

  factory Rgba8Image.fromJson(Map<String, dynamic> json) =>
      Rgba8Image(json["pixel"], json["width"], json["height"]);

  Map<String, dynamic> toJson() => {
    "pixel": pixel,
    "width": width,
    "height": height,
  };

  final Uint8List pixel;
  final int width;
  final int height;
}
