#include <algorithm>
#include <array>
#include <cstdint>

#include "yuv.h"

using namespace std;

namespace core {
namespace filter {

array<float, 3> rgb8ToYuv(const uint8_t *rgb8) {
  const float rgbF[] = {rgb8[0] / 255.f, rgb8[1] / 255.f, rgb8[2] / 255.f};
  return {
      clamp(rgbF[0] * .299f + rgbF[1] * .587f + rgbF[2] * .114f, 0.f, 1.f),
      clamp(rgbF[0] * -.168736f + rgbF[1] * -.331264f + rgbF[2] * .5f + .5f,
            0.f,
            1.f),
      clamp(rgbF[0] * .5f + rgbF[1] * -.418688f + rgbF[2] * -.081312f + .5f,
            0.f,
            1.f),
  };
}

array<uint8_t, 3> yuvToRgb8(const float *yuv) {
  const float yuv_[] = {yuv[0], yuv[1] - .5f, yuv[2] - .5f};
  const float rgbF[] = {
      yuv_[0] + yuv_[2] * 1.4f,
      yuv_[0] + yuv_[1] * -.343f + yuv_[2] * -.711f,
      yuv_[0] + yuv_[1] * 1.765f,
  };
  return {
      static_cast<uint8_t>(clamp<int>(rgbF[0] * 255, 0, 255)),
      static_cast<uint8_t>(clamp<int>(rgbF[1] * 255, 0, 255)),
      static_cast<uint8_t>(clamp<int>(rgbF[2] * 255, 0, 255)),
  };
}

} // namespace filter
} // namespace core
