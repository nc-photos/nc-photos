#include <exception>
#include <exiv2/image.hpp>
#include <exiv2/types.hpp>
#include <fstream>
#include <jxl/encode.h>
#include <jxl/encode_cxx.h>
#include <memory>
#include <string>
#include <vector>

#include "convert_jxl.h"
#include "image.h"
#include "log.h"

using namespace std;
using namespace np_uploader;

namespace {

constexpr const char *TAG = "FormatConverterNative.Jxl";

constexpr const size_t BUFFER_SIZE = 4 * 1024 * 1024;

bool setupEncoder(JxlEncoder *encoder, const unique_ptr<Image> &srcBmp,
                  const uint8_t *srcBuf, const size_t srcBufSize,
                  const int quality);

bool addExifBox(JxlEncoder *encoder, const unique_ptr<Exiv2::Image> &srcExiv);

bool addXmpBox(JxlEncoder *encoder, const unique_ptr<Exiv2::Image> &srcExiv);

bool setIccProfile(JxlEncoder *encoder,
                   const unique_ptr<Exiv2::Image> &srcExiv);

bool exportJxl(JxlEncoder *encoder, const string &dstPath);

} // namespace

namespace np_uploader {

bool convertToJxl(const unique_ptr<Image> &srcBmp, const uint8_t *srcBuf,
                  const size_t srcBufSize, const string &dstPath,
                  const int quality) {
  LOGI(TAG, "[convertToJxl] Converting to: %s", dstPath.c_str());
  auto encoder = JxlEncoderMake(nullptr);
  return setupEncoder(encoder.get(), srcBmp, srcBuf, srcBufSize, quality) &&
         exportJxl(encoder.get(), dstPath);
}

} // namespace np_uploader

namespace {

bool setupEncoder(JxlEncoder *encoder, const unique_ptr<Image> &srcBmp,
                  const uint8_t *srcBuf, const size_t srcBufSize,
                  const int quality) {
  JxlEncoderStatus result;
  JxlBasicInfo info;
  JxlEncoderInitBasicInfo(&info);
  info.xsize = srcBmp->width;
  info.ysize = srcBmp->height;
  info.bits_per_sample = 8;
  info.num_color_channels = 3;
  info.num_extra_channels = 1;
  info.alpha_bits = 8;
  result = JxlEncoderSetBasicInfo(encoder, &info);
  if (result != JXL_ENC_SUCCESS) {
    LOGE(TAG, "[setupEncoder] Failed while JxlEncoderSetBasicInfo: %d",
         JxlEncoderGetError(encoder));
    return false;
  }

  auto settings = JxlEncoderFrameSettingsCreate(encoder, nullptr);
  JxlEncoderSetFrameDistance(settings, JxlEncoderDistanceFromQuality(quality));
  JxlEncoderFrameSettingsSetOption(settings, JXL_ENC_FRAME_SETTING_EFFORT, 7);

  JxlEncoderUseBoxes(encoder);
  auto srcExiv = Exiv2::ImageFactory::open(srcBuf, srcBufSize);
  srcExiv->readMetadata();
  if (!setIccProfile(encoder, srcExiv) || !addExifBox(encoder, srcExiv) ||
      !addXmpBox(encoder, srcExiv)) {
    return false;
  }

  const auto format = JxlPixelFormat{4, JXL_TYPE_UINT8, JXL_LITTLE_ENDIAN, 0};
  result = JxlEncoderAddImageFrame(settings, &format, srcBmp->pixels.data(),
                                   srcBmp->pixels.size());
  if (result != JXL_ENC_SUCCESS) {
    LOGE(TAG, "[setupEncoder] Failed while JxlEncoderAddImageFrame: %d",
         JxlEncoderGetError(encoder));
    return false;
  }
  JxlEncoderCloseInput(encoder);
  return true;
}

bool addExifBox(JxlEncoder *encoder, const unique_ptr<Exiv2::Image> &srcExiv) {
  if (srcExiv->exifData().empty()) {
    LOGD(TAG, "[addExifBox] No exif data, skipping");
    return true;
  }
  vector<uint8_t> buffer;
  Exiv2::ExifParser::encode(buffer, Exiv2::ByteOrder::littleEndian,
                            srcExiv->exifData());
  auto result =
      JxlEncoderAddBox(encoder, "Exif", buffer.data(), buffer.size(), false);
  if (result != JXL_ENC_SUCCESS) {
    LOGE(TAG, "[addExifBox] Failed while adding Exif box: %d",
         JxlEncoderGetError(encoder));
    return false;
  }
  return true;
}

bool addXmpBox(JxlEncoder *encoder, const unique_ptr<Exiv2::Image> &srcExiv) {
  if (srcExiv->xmpData().empty()) {
    LOGD(TAG, "[addXmpBox] No xmp data, skipping");
    return true;
  }
  string buffer;
  Exiv2::XmpParser::encode(
      buffer, srcExiv->xmpData(),
      Exiv2::XmpParser::XmpFormatFlags::omitPacketWrapper |
          Exiv2::XmpParser::XmpFormatFlags::useCompactFormat);
  auto result = JxlEncoderAddBox(
      encoder, "xml ", (const uint8_t *)buffer.data(), buffer.size(), false);
  if (result != JXL_ENC_SUCCESS) {
    LOGE(TAG, "[addXmpBox] Failed while adding xml box: %d",
         JxlEncoderGetError(encoder));
    return false;
  }
  return true;
}

bool setIccProfile(JxlEncoder *encoder,
                   const unique_ptr<Exiv2::Image> &srcExiv) {
  if (srcExiv->iccProfile().empty()) {
    LOGD(TAG, "[setIccProfile] No icc profile, skipping");
    return true;
  }
  auto result = JxlEncoderSetICCProfile(encoder, srcExiv->iccProfile().c_data(),
                                        srcExiv->iccProfile().size());
  if (result != JXL_ENC_SUCCESS) {
    LOGE(TAG, "[setIccProfile] Failed while setting icc profile: %d",
         JxlEncoderGetError(encoder));
    return false;
  }
  return true;
}

bool exportJxl(JxlEncoder *encoder, const string &dstPath) {
  vector<uint8_t> buffer(BUFFER_SIZE);
  uint8_t *bufferPtr = buffer.data();
  size_t availOut = BUFFER_SIZE;
  ofstream ofs(dstPath, ios_base::binary);
  JxlEncoderStatus result;
  try {
    while (true) {
      result = JxlEncoderProcessOutput(encoder, &bufferPtr, &availOut);
      if (result == JXL_ENC_ERROR) {
        LOGE(TAG, "[exportJxl] Failed while JxlEncoderProcessOutput: %d",
             JxlEncoderGetError(encoder));
        return false;
      }
      const auto processed = BUFFER_SIZE - availOut;
      LOGD(TAG, "[exportJxl] Processed %lu bytes", processed);
      // write to file
      ofs.write((char *)buffer.data(), processed);
      if (!ofs.good()) {
        LOGE(TAG, "[exportJxl] Failed while writing to ofstream");
        return false;
      }

      if (result == JXL_ENC_SUCCESS) {
        return true;
      }
      bufferPtr = buffer.data();
      availOut = BUFFER_SIZE;
    }
  } catch (const exception &e) {
    LOGE(TAG, "[exportJxl] Exception: %s", e.what());
    return false;
  }
}

} // namespace
