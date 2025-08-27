#include <android/imagedecoder.h>
#include <cmath>
#include <cstring>
#include <exception>
#include <fstream>
#include <jni.h>
#include <memory>
#include <string>
#include <vector>

#include "converter.h"
#include "log.h"

using namespace std;

#define REQUIRES_API(x)                                                        \
  __attribute__((__availability__(android, introduced = x)))

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

struct Image {
  Image(const int32_t width, const int32_t height, const int32_t format,
        const size_t stride, const int32_t dataSpace,
        std::vector<uint8_t> &&pixels)
      : width(width), height(height), format(format), stride(stride),
        dataSpace(dataSpace), pixels(std::move(pixels)) {}

  int32_t width;
  int32_t height;
  int32_t format;
  size_t stride;
  int32_t dataSpace;
  std::vector<uint8_t> pixels;
};

int convert(const int srcFd, const std::string &dstPath,
            const ConvertTargetFormat format, const int quality,
            const double downsizeMp) REQUIRES_API(30);

bool convertToJpg(const std::unique_ptr<Image> &srcBmp,
                  const std::string &dstPath, const int quality)
    REQUIRES_API(30);

std::unique_ptr<Image> readFd(const int fd, const double downsizeMp)
    REQUIRES_API(30);

bool compressWrite(void *userContext, const void *data, size_t size);

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
  auto srcBmp = readFd(srcFd, downsizeMp);
  if (!srcBmp) {
    LOGE(TAG, "[convert] Failed to read the source file");
    return READ_FAILURE;
  }

  try {
    if (format == ConvertTargetFormat::JPEG) {
      return convertToJpg(srcBmp, dstPath, quality) ? OK : WRITE_FAILURE;
    }
    return WRITE_FAILURE;
  } catch (const exception &e) {
    LOGE(TAG, "[convert] Failed to convert image: %s", dstPath.c_str());
    return WRITE_FAILURE;
  }
}

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

unique_ptr<Image> readFd(const int fd, const double downsizeMp) {
  if (fd < 0) {
    LOGE(TAG, "[readFd] Invalid fd: %d", fd);
    return nullptr;
  }
  AImageDecoder *decoder;
  int result = AImageDecoder_createFromFd(fd, &decoder);
  if (result != ANDROID_IMAGE_DECODER_SUCCESS) {
    LOGE(TAG, "[readFd] Failed to create decoder: %d", result);
    return nullptr;
  }

  try {
    const auto info = AImageDecoder_getHeaderInfo(decoder);
    const auto width = AImageDecoderHeaderInfo_getWidth(info);
    const auto height = AImageDecoderHeaderInfo_getHeight(info);
    const auto format =
        (AndroidBitmapFormat)AImageDecoderHeaderInfo_getAndroidBitmapFormat(
            info);
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
             "[readFd] Resizing image to fit %.1fMP envelop: %d*%d -> %d*%d",
             downsizeMp, width, height, newWidth, newHeight);
        result = AImageDecoder_setTargetSize(decoder, newWidth, newHeight);
        if (result != ANDROID_IMAGE_DECODER_SUCCESS) {
          LOGE(TAG, "[readFd] Failed to set target size: %d", result);
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
      LOGE(TAG, "[readFd] Failed to decode image: %d", result);
      return nullptr;
    }

    return make_unique<Image>(dstWidth, dstHeight, format, stride, dataSpace,
                              std::move(pixels));
  } catch (const exception &e) {
    if (decoder) {
      AImageDecoder_delete(decoder);
    }
    LOGE(TAG, "[readFd] Exception: %s", e.what());
    return nullptr;
  }
}

bool compressWrite(void *userContext, const void *data, size_t size) {
  auto ofs = (ofstream *)userContext;
  ofs->write((const char *)data, size);
  return ofs->good();
}

} // namespace
