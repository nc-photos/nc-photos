#include <RenderScriptToolkit.h>
#include <algorithm>
#include <android/asset_manager.h>
#include <cstdarg>
#include <exception>
#include <iterator>
#include <memory>
#include <omp.h>
#include <sstream>
#include <string>
#include <tensorflow/lite/c/c_api.h>
#include <vector>

#include "util.h"
#include "log.h"

using namespace im_proc;
using namespace std;

namespace im_proc {

Asset::Asset(AAssetManager *const aam, const string &name, const int mode) {
  asset = AAssetManager_open(aam, name.c_str(), AASSET_MODE_BUFFER);
  if (!asset) {
    throw runtime_error("Error loading asset file");
  }
}

Asset::Asset(Asset &&rhs) {
  if (this != &rhs) {
    asset = rhs.asset;
    rhs.asset = nullptr;
  }
}

Asset::~Asset() {
  if (asset) {
    AAsset_close(asset);
    asset = nullptr;
  }
}

const void *Asset::getBuffer() const { return AAsset_getBuffer(asset); }

const size_t Asset::getSize() const {
  return static_cast<size_t>(AAsset_getLength(asset));
}

void initOpenMp() {
  const auto count = omp_get_num_procs();
  LOGI("OpenMp", "Number of threads: %d", count);
  omp_set_num_threads(count);
}

int getNumberOfProcessors() { return omp_get_num_procs(); }

renderscript::RenderScriptToolkit &getToolkitInst() {
  static renderscript::RenderScriptToolkit inst(getNumberOfProcessors());
  return inst;
}

string strprintf(const char *format, ...) {
  va_list arg;
  va_start(arg, format);

  va_list arg_copy;
  va_copy(arg_copy, arg);
  const int size = vsnprintf(nullptr, 0, format, arg_copy);
  va_end(arg_copy);

  if (size < 0) {
    va_end(arg);
    return "";
  }

  string str(size + 1, '\0');
  vsnprintf(&str[0], size + 1, format, arg);
  // We don't want the null char
  str.pop_back();

  va_end(arg);
  return str;
}

string toString(const TfLiteTensor &tensor) {
  const auto numDims = TfLiteTensorNumDims(&tensor);
  stringstream ss;
  ss << "[";
  for (int i = 0; i < numDims; ++i) {
    ss << TfLiteTensorDim(&tensor, i) << ", ";
  }
  ss << "]";

  return strprintf("TfLiteTensor {"
                   "\"type: %d\", "
                   "\"dimension\": %s, "
                   "\"byteSize: %d\", "
                   "}",
                   TfLiteTensorType(&tensor), ss.str().c_str(),
                   TfLiteTensorByteSize(&tensor));
}

vector<float> rgb8ToRgbFloat(const uint8_t *rgb8, const size_t size,
                             const bool shouldNormalize) {
  vector<float> rgbF(size);
#pragma omp parallel for
  for (size_t i = 0; i < size; ++i) {
    if (shouldNormalize) {
      rgbF[i] = rgb8[i] / 255.0f;
    } else {
      rgbF[i] = rgb8[i];
    }
  }
  return rgbF;
}

vector<uint8_t> rgbFloatToRgb8(const float *rgbF, const size_t size,
                               const bool isNormalized) {
  vector<uint8_t> rgb8(size);
#pragma omp parallel for
  for (size_t i = 0; i < size; ++i) {
    if (isNormalized) {
      rgb8[i] = clamp<int>(rgbF[i] * 255, 0, 255);
    } else {
      rgb8[i] = clamp<int>(rgbF[i], 0, 255);
    }
  }
  return rgb8;
}

vector<uint8_t> rgb8ToRgba8(const uint8_t *rgb8, const size_t width,
                            const size_t height) {
  vector<uint8_t> rgba8(width * height * 4);
#pragma omp parallel for
  for (size_t y = 0; y < height; ++y) {
    for (size_t x = 0; x < width; ++x) {
      const auto i1 = y * width + x;
      const auto i3 = i1 * 3;
      const auto i4 = i1 * 4;
      memcpy(rgba8.data() + i4, rgb8 + i3, 3);
      rgba8[i4 + 3] = 0xFF;
    }
  }
  return rgba8;
}

vector<uint8_t> rgba8ToRgb8(const uint8_t *rgba8, const size_t width,
                            const size_t height) {
  vector<uint8_t> rgb8(width * height * 3);
#pragma omp parallel for
  for (size_t y = 0; y < height; ++y) {
    for (size_t x = 0; x < width; ++x) {
      const auto i1 = y * width + x;
      const auto i3 = i1 * 3;
      const auto i4 = i1 * 4;
      memcpy(rgb8.data() + i3, rgba8 + i4, 3);
    }
  }
  return rgb8;
}

void alphaBlend(const uint8_t *src, uint8_t *dst, const size_t width,
                const size_t height) {
#pragma omp parallel for
  for (size_t y = 0; y < height; ++y) {
    for (size_t x = 0; x < width; ++x) {
      const auto i4 = (y * width + x) * 4;
      const auto srcA = src[i4 + 3] / 255.0f;
      const auto dstA = dst[i4 + 3] / 255.0f;
      const auto endA = srcA + dstA * (1 - srcA);
      // rgb
      for (int i = 0; i < 3; ++i) {
        dst[i4 + i] =
            (src[i4 + i] * srcA + dst[i4 + i] * dstA * (1 - srcA)) / endA;
      }
      // a
      dst[i4 + 3] = clamp<int>(endA * 255, 0, 255);
    }
  }
}

vector<uint8_t> argmax(const float *output, const size_t width,
                       const size_t height, const unsigned channel) {
  vector<uint8_t> product(width * height);
  size_t j = 0;
  for (size_t i = 0; i < width * height; ++i) {
    const float *point = output + j;
    const auto maxIt = max_element(point, point + channel);
    product[i] = distance(point, maxIt);
    j += channel;
  }
  return product;
}

} // namespace im_proc
