#pragma once

#include <cstdint>
#include <exiv2/exiv2.hpp>
#include <memory>
#include <string>
#include <utility>
#include <vector>

namespace np_exiv2 {
namespace reader {

enum struct TypeId {
  unsignedByte = 0,
  asciiString,
  unsignedShort,
  unsignedLong,
  unsignedRational,
  signedByte,
  undefined,
  signedShort,
  signedLong,
  signedRational,
  tiffFloat,
  tiffDouble,
  tiffIfd,
  unsignedLongLong,
  signedLongLong,
  tiffIfd8,
  string,
  date,
  time,
  comment,
  directory,
  xmpText,
  xmpAlt,
  xmpBag,
  xmpSeq,
  langAlt,
  invalidTypeId,
};

struct Metadatum {
  Metadatum(const std::string &tag_key, const TypeId type_id,
            std::vector<uint8_t> &&data, const size_t count)
      : tag_key(tag_key), type_id(type_id), data(std::move(data)),
        count(count) {}

  Metadatum(Metadatum &&other)
      : tag_key(other.tag_key), type_id(other.type_id),
        data(std::move(other.data)), count(other.count) {}

  std::string tag_key;
  TypeId type_id;
  std::vector<uint8_t> data;
  // number of elements in data if it's an array, 1 otherwise
  size_t count;
};

struct Result {
  Result(const uint32_t width, const uint32_t height,
         std::vector<Metadatum> &&iptc_data, std::vector<Metadatum> &&exif_data,
         std::vector<Metadatum> &&xmp_data)
      : width(width), height(height), iptc_data(std::move(iptc_data)),
        exif_data(std::move(exif_data)), xmp_data(std::move(xmp_data)) {}

  Result(Result &&other)
      : width(other.width), height(other.height),
        iptc_data(std::move(other.iptc_data)),
        exif_data(std::move(other.exif_data)),
        xmp_data(std::move(other.xmp_data)) {}

  uint32_t width;
  uint32_t height;
  std::vector<Metadatum> iptc_data;
  std::vector<Metadatum> exif_data;
  std::vector<Metadatum> xmp_data;
};

class Reader {
public:
  std::unique_ptr<Result> read_file(const std::string &path);
  std::unique_ptr<Result> read_buffer(const uint8_t *buffer, const size_t size);

private:
  std::unique_ptr<Result> read_image(const Exiv2::Image::UniquePtr &image);
};

} // namespace reader
} // namespace np_exiv2
