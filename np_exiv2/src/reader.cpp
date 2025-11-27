#include <exception>
#include <exiv2/types.hpp>
#include <exiv2/value.hpp>

#include "log.h"
#include "reader.h"

using namespace std;

#define TAG "Reader"

namespace np_exiv2 {
namespace reader {

namespace {
vector<uint8_t> copyRawValue(const Exiv2::Value &value) {
  if (value.size() == 0) {
    return {};
  }
  vector<uint8_t> buffer(value.size());
  value.copy(buffer.data(), Exiv2::ByteOrder::littleEndian);
  return buffer;
}

size_t valueToCount(const Exiv2::Value &value) {
  switch (value.typeId()) {
  case Exiv2::TypeId::signedByte:
  case Exiv2::TypeId::unsignedByte:
  case Exiv2::TypeId::unsignedShort:
  case Exiv2::TypeId::unsignedLong:
  case Exiv2::TypeId::tiffIfd:
  case Exiv2::TypeId::unsignedRational:
  case Exiv2::TypeId::signedShort:
  case Exiv2::TypeId::signedLong:
  case Exiv2::TypeId::signedRational:
  case Exiv2::TypeId::tiffFloat:
  case Exiv2::TypeId::tiffDouble:
  case Exiv2::TypeId::xmpText:
    return value.count();

  case Exiv2::TypeId::invalidTypeId:
  case Exiv2::TypeId::undefined:
  case Exiv2::TypeId::lastTypeId:
  case Exiv2::TypeId::directory:
  case Exiv2::TypeId::asciiString:
  case Exiv2::TypeId::string:
  case Exiv2::TypeId::comment:
  case Exiv2::TypeId::date:
  case Exiv2::TypeId::time:
  case Exiv2::TypeId::xmpAlt:
  case Exiv2::TypeId::xmpBag:
  case Exiv2::TypeId::xmpSeq:
  case Exiv2::TypeId::langAlt:
    return 1;

  case Exiv2::TypeId::unsignedLongLong:
  case Exiv2::TypeId::signedLongLong:
  case Exiv2::TypeId::tiffIfd8:
    return value.size() / 8;
  }
}

vector<uint8_t> valueToByteArray(const Exiv2::Value &value) {
  switch (value.typeId()) {
  case Exiv2::TypeId::unsignedByte:
  case Exiv2::TypeId::unsignedShort:
  case Exiv2::TypeId::unsignedLong:
  case Exiv2::TypeId::unsignedRational:
  case Exiv2::TypeId::signedByte:
  case Exiv2::TypeId::signedShort:
  case Exiv2::TypeId::signedLong:
  case Exiv2::TypeId::signedRational:
  case Exiv2::TypeId::asciiString:
  case Exiv2::TypeId::undefined:
  case Exiv2::TypeId::tiffFloat:
  case Exiv2::TypeId::tiffDouble:
  case Exiv2::TypeId::tiffIfd:
  case Exiv2::TypeId::unsignedLongLong:
  case Exiv2::TypeId::signedLongLong:
  case Exiv2::TypeId::tiffIfd8:
  case Exiv2::TypeId::string:
  case Exiv2::TypeId::directory:
  // the first 8 chars is the charset
  case Exiv2::TypeId::comment:
  case Exiv2::TypeId::invalidTypeId:
  case Exiv2::TypeId::lastTypeId:
    return copyRawValue(value);

  case Exiv2::TypeId::date: {
    // date format is not well defined, we rely on exiv2 to do the conversion
    // for us. Result will be saved as int32_t[3]
    const auto v = static_cast<const Exiv2::DateValue &>(value);
    const auto date = v.getDate();
    const int32_t valueBuffer[] = {date.year, date.month, date.day};
    vector<uint8_t> buffer(sizeof(valueBuffer));
    memcpy(buffer.data(), valueBuffer, sizeof(valueBuffer));
    return buffer;
  }

  case Exiv2::TypeId::time: {
    // date format is not well defined. Result will be saved as int32_t[5]
    const auto v = static_cast<const Exiv2::TimeValue &>(value);
    const auto time = v.getTime();
    const int32_t valueBuffer[] = {time.hour, time.minute, time.second,
                                   time.tzHour, time.tzMinute};
    vector<uint8_t> buffer(sizeof(valueBuffer));
    memcpy(buffer.data(), valueBuffer, sizeof(valueBuffer));
    return buffer;
  }

  case Exiv2::TypeId::xmpText:
  case Exiv2::TypeId::xmpAlt:
  case Exiv2::TypeId::xmpBag:
  case Exiv2::TypeId::xmpSeq:
  case Exiv2::TypeId::langAlt:
    // no xmp support
    return copyRawValue(value);
  }
}

TypeId convertTypeId(const Exiv2::TypeId value) {
  switch (value) {
  case Exiv2::TypeId::unsignedByte:
    return TypeId::unsignedByte;
  case Exiv2::TypeId::asciiString:
    return TypeId::asciiString;
  case Exiv2::TypeId::unsignedShort:
    return TypeId::unsignedShort;
  case Exiv2::TypeId::unsignedLong:
    return TypeId::unsignedLong;
  case Exiv2::TypeId::unsignedRational:
    return TypeId::unsignedRational;
  case Exiv2::TypeId::signedByte:
    return TypeId::signedByte;
  case Exiv2::TypeId::undefined:
    return TypeId::undefined;
  case Exiv2::TypeId::signedShort:
    return TypeId::signedShort;
  case Exiv2::TypeId::signedLong:
    return TypeId::signedLong;
  case Exiv2::TypeId::signedRational:
    return TypeId::signedRational;
  case Exiv2::TypeId::tiffFloat:
    return TypeId::tiffFloat;
  case Exiv2::TypeId::tiffDouble:
    return TypeId::tiffDouble;
  case Exiv2::TypeId::tiffIfd:
    return TypeId::tiffIfd;
  case Exiv2::TypeId::unsignedLongLong:
    return TypeId::unsignedLongLong;
  case Exiv2::TypeId::signedLongLong:
    return TypeId::signedLongLong;
  case Exiv2::TypeId::tiffIfd8:
    return TypeId::tiffIfd8;
  case Exiv2::TypeId::string:
    return TypeId::string;
  case Exiv2::TypeId::date:
    return TypeId::date;
  case Exiv2::TypeId::time:
    return TypeId::time;
  case Exiv2::TypeId::comment:
    return TypeId::comment;
  case Exiv2::TypeId::directory:
    return TypeId::directory;
  case Exiv2::TypeId::xmpText:
    return TypeId::xmpText;
  case Exiv2::TypeId::xmpAlt:
    return TypeId::xmpAlt;
  case Exiv2::TypeId::xmpBag:
    return TypeId::xmpBag;
  case Exiv2::TypeId::xmpSeq:
    return TypeId::xmpSeq;
  case Exiv2::TypeId::langAlt:
    return TypeId::langAlt;
  case Exiv2::TypeId::invalidTypeId:
  case Exiv2::TypeId::lastTypeId:
    return TypeId::invalidTypeId;
  }
}
} // namespace

Reader::Reader(const bool is_read_xmp) : is_read_xmp_(is_read_xmp) {}

unique_ptr<Result> Reader::read_file(const string &path) {
  auto image = Exiv2::ImageFactory::open(path, false);
  if (!image->good()) {
    LOGE(TAG, "Failed to open image file: %s", path.c_str());
    return nullptr;
  }
  return read_image(image);
}

unique_ptr<Result> Reader::read_buffer(const uint8_t *buffer,
                                       const size_t size) {
  auto image = Exiv2::ImageFactory::open(buffer, size);
  if (!image->good()) {
    LOGE(TAG, "Failed to open image buffer");
    return nullptr;
  }
  return read_image(image);
}

unique_ptr<Result> Reader::read_image(const Exiv2::Image::UniquePtr &image) {
  try {
    image->readMetadata();
  } catch (const exception &e) {
    LOGE(TAG, "Failed to read metadata: %s", e.what());
    return nullptr;
  }

  LOGI(TAG, "Processing IPTC data");
  vector<Metadatum> iptc;
  iptc.reserve(image->iptcData().count());
  for (auto it = image->iptcData().begin(); it != image->iptcData().end();
       ++it) {
    iptc.push_back({it->tagName(), convertTypeId(it->typeId()),
                    valueToByteArray(it->value()), valueToCount(it->value())});
  }

  LOGI(TAG, "Processing EXIF data");
  vector<Metadatum> exif;
  exif.reserve(image->exifData().count());
  for (auto it = image->exifData().begin(); it != image->exifData().end();
       ++it) {
    exif.push_back({it->tagName(), convertTypeId(it->typeId()),
                    valueToByteArray(it->value()), valueToCount(it->value())});
  }

  LOGI(TAG, "Processing XMP data");
  vector<Metadatum> xmp;
  if (is_read_xmp_) {
    xmp.reserve(image->xmpData().count());
    for (auto it = image->xmpData().begin(); it != image->xmpData().end();
         ++it) {
      // LOGD("Reader", "%s %d %lu", it->tagName().c_str(),
      //      convertTypeId(it->typeId()), valueToCount(it->value()));
      xmp.push_back({it->tagName(), convertTypeId(it->typeId()),
                     valueToByteArray(it->value()), valueToCount(it->value())});
    }
  }

  LOGI(TAG, "Done");
  auto result =
      make_unique<Result>(image->pixelWidth(), image->pixelHeight(),
                          std::move(iptc), std::move(exif), std::move(xmp));
  return result;
}

} // namespace reader
} // namespace np_exiv2
