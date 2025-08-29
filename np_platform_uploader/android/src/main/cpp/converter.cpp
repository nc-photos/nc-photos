#include <android/imagedecoder.h>
#include <cmath>
#include <cstring>
#include <exception>
#include <jni.h>
#include <memory>
#include <string>
#include <sys/stat.h>
#include <unistd.h>
#include <vector>

#include "convert_jpg.h"
#include "converter.h"
#include "copy_metadata.h"
#include "image.h"
#include "log.h"
#include "util.h"

using namespace std;
using namespace np_uploader;

namespace {

enum struct ConvertTargetFormat {
  JPEG = 0,
};

enum Result {
  OK = 0,
  READ_FAILURE,
  WRITE_FAILURE,
  UNKNOWN_FAILURE,
};

int convert(const int srcFd, const std::string &dstPath,
            const ConvertTargetFormat format, const int quality,
            const double downsizeMp) REQUIRES_API(30);

std::vector<uint8_t> readFd(const int fd);

std::unique_ptr<Image> readImage(const std::vector<uint8_t> &buf,
                                 const double downsizeMp) REQUIRES_API(30);

constexpr const char *TAG = "FormatConverterNative";

} // namespace

extern "C" JNIEXPORT jint JNICALL
Java_com_nkming_nc_1photos_np_1platform_1uploader_FormatConverter_convertNative(
    JNIEnv *env, jobject thiz, jint srcFd, jstring dstPath, jint format,
    jint quality, jdouble downsizeMp) REQUIRES_API(30) {
  const char *cDstPath = nullptr;
  try {
    cDstPath = env->GetStringUTFChars(dstPath, nullptr);
    auto result = convert(srcFd, cDstPath, (ConvertTargetFormat)format, quality,
                          downsizeMp);
    env->ReleaseStringUTFChars(dstPath, cDstPath);
    return result;
  } catch (const exception &e) {
    if (cDstPath) {
      env->ReleaseStringUTFChars(dstPath, cDstPath);
    }
    jclass clz = env->FindClass(
        "com/nkming/nc_photos/np_platform_uploader/NativeException");
    if (clz) {
      env->ThrowNew(clz, e.what());
    }
    return UNKNOWN_FAILURE;
  }
}

namespace {

int convert(const int srcFd, const string &dstPath,
            const ConvertTargetFormat format, const int quality,
            const double downsizeMp) {
  // read file
  const auto srcBuf = readFd(srcFd);
  if (srcBuf.empty()) {
    LOGE(TAG, "[convert] Failed to read the source file");
    return READ_FAILURE;
  }
  const auto srcBmp = readImage(srcBuf, downsizeMp);
  if (!srcBmp) {
    LOGE(TAG, "[convert] Failed to read the source file");
    return READ_FAILURE;
  }

  try {
    if (format == ConvertTargetFormat::JPEG) {
      if (!convertToJpg(srcBmp, dstPath, quality)) {
        return WRITE_FAILURE;
      }
      copyMetadata(srcBuf.data(), srcBuf.size(), dstPath);
      return OK;
    }
    return WRITE_FAILURE;
  } catch (const exception &e) {
    LOGE(TAG, "[convert] Failed to convert image (%s): %s", dstPath.c_str(),
         e.what());
    return WRITE_FAILURE;
  }
}

vector<uint8_t> readFd(const int fd) {
  if (fd < 0) {
    LOGE(TAG, "[readFd] Invalid fd: %d", fd);
    return {};
  }

  struct stat s;
  auto result = fstat(fd, &s);
  if (result < 0) {
    LOGE(TAG, "[readFd] Failed while fstat: %d", result);
    return {};
  }
  const auto fileSize = s.st_size;
  vector<uint8_t> buf(fileSize);
  result = read(fd, buf.data(), fileSize);
  if (result < 0) {
    LOGE(TAG, "[readFd] Failed while read: %d", result);
    return {};
  }
  return buf;
}

unique_ptr<Image> readImage(const vector<uint8_t> &buf,
                            const double downsizeMp) {
  AImageDecoder *decoder;
  int result = AImageDecoder_createFromBuffer(buf.data(), buf.size(), &decoder);
  if (result != ANDROID_IMAGE_DECODER_SUCCESS) {
    LOGE(TAG, "[readImg] Failed to create decoder: %d", result);
    return nullptr;
  }

  try {
    const auto info = AImageDecoder_getHeaderInfo(decoder);
    const auto width = AImageDecoderHeaderInfo_getWidth(info);
    const auto height = AImageDecoderHeaderInfo_getHeight(info);
    const auto format = AndroidBitmapFormat::ANDROID_BITMAP_FORMAT_RGBA_8888;
    result = AImageDecoder_setAndroidBitmapFormat(
        decoder, AndroidBitmapFormat::ANDROID_BITMAP_FORMAT_RGBA_8888);
    if (result != ANDROID_IMAGE_DECODER_SUCCESS) {
      LOGE(TAG, "[readImg] Failed to set bitmap format: %d", result);
      return nullptr;
    }
    const auto dataSpace = AImageDecoderHeaderInfo_getDataSpace(info);
    auto dstWidth = width;
    auto dstHeight = height;
    if (downsizeMp > 0) {
      const auto srcMp = (width * height) / 1000000.0;
      if (srcMp > downsizeMp) {
        const auto scale = sqrt(downsizeMp / srcMp);
        const auto newWidth = (int)(width * scale);
        const auto newHeight = (int)(height * scale);
        LOGI(TAG,
             "[readImg] Resizing image to fit %.1fMP envelop: %d*%d -> %d*%d",
             downsizeMp, width, height, newWidth, newHeight);
        result = AImageDecoder_setTargetSize(decoder, newWidth, newHeight);
        if (result != ANDROID_IMAGE_DECODER_SUCCESS) {
          LOGE(TAG, "[readImg] Failed to set target size: %d", result);
        } else {
          dstHeight = newHeight;
          dstWidth = newWidth;
        }
      }
    }
    const auto stride = AImageDecoder_getMinimumStride(decoder);
    const auto size = dstHeight * stride;
    vector<uint8_t> pixels(size);
    result = AImageDecoder_decodeImage(decoder, pixels.data(), stride, size);
    // We’re done with the decoder, so now it’s safe to delete it.
    AImageDecoder_delete(decoder);
    decoder = nullptr;
    if (result != ANDROID_IMAGE_DECODER_SUCCESS) {
      LOGE(TAG, "[readImg] Failed to decode image: %d", result);
      return nullptr;
    }

    return make_unique<Image>(dstWidth, dstHeight, format, stride, dataSpace,
                              std::move(pixels));
  } catch (const exception &e) {
    if (decoder) {
      AImageDecoder_delete(decoder);
    }
    LOGE(TAG, "[readImg] Exception: %s", e.what());
    return nullptr;
  }
}

} // namespace
