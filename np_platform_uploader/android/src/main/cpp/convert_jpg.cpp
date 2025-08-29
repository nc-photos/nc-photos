#include <android/bitmap.h>
#include <fstream>
#include <memory>
#include <string>

#include "convert_jpg.h"
#include "image.h"
#include "log.h"

using namespace std;
using namespace np_uploader;

namespace {

bool compressWrite(void *userContext, const void *data, size_t size);

constexpr const char *TAG = "FormatConverterNative.Jpg";

} // namespace

namespace np_uploader {

bool convertToJpg(const unique_ptr<Image> &srcBmp, const string &dstPath,
                  const int quality) {
  LOGI(TAG, "[convertToJpg] Converting to: %s", dstPath.c_str());
  ofstream ofs(dstPath, ios_base::binary);

  AndroidBitmapInfo info;
  memset(&info, 0, sizeof(info));
  info.width = srcBmp->width;
  info.height = srcBmp->height;
  info.format = srcBmp->format;
  info.stride = srcBmp->stride;
  auto result = AndroidBitmap_compress(
      &info, srcBmp->dataSpace, srcBmp->pixels.data(),
      ANDROID_BITMAP_COMPRESS_FORMAT_JPEG, quality, &ofs, compressWrite);
  if (result != ANDROID_BITMAP_RESULT_SUCCESS) {
    LOGE(TAG, "[convertToJpg] Failed to compress image: %d", result);
    return false;
  } else {
    return true;
  }
}

} // namespace np_uploader

namespace {

bool compressWrite(void *userContext, const void *data, size_t size) {
  auto ofs = (ofstream *)userContext;
  ofs->write((const char *)data, size);
  return ofs->good();
}

} // namespace