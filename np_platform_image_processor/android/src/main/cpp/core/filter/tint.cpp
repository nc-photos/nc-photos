#include <algorithm>
#include <cstdint>
#include <cstring>
#include <exception>
#include <vector>

#include "../log.h"
#include "yuv.h"

using namespace core;
using namespace std;

namespace {

class Tint {
public:
  std::vector<uint8_t> apply(const uint8_t *rgba8, const size_t width,
                             const size_t height, const float weight);

private:
  static constexpr const char *TAG = "Tint";
};

} // namespace

namespace core {
namespace filter {

vector<uint8_t> applyTint(const uint8_t *rgba8, const size_t width,
                          const size_t height, const float weight) {
  return Tint().apply(rgba8, width, height, weight);
}

} // namespace filter
} // namespace core

namespace {

vector<uint8_t> Tint::apply(const uint8_t *rgba8, const size_t width,
                            const size_t height, const float weight) {
  LOGI(TAG, "[apply] weight: %.2f", weight);
  if (weight == 0) {
    // shortcut
    return vector<uint8_t>(rgba8, rgba8 + width * height * 4);
  }

  vector<uint8_t> output(width * height * 4);
#pragma omp parallel for
  for (size_t i = 0; i < width * height; ++i) {
    const auto p = i * 4;
    auto yuv = filter::rgb8ToYuv(rgba8 + p);
    // +-0.1
    yuv[1] = clamp(yuv[1] + 0.1f * weight, 0.f, 1.f);
    yuv[2] = clamp(yuv[2] + 0.1f * weight, 0.f, 1.f);
    const auto &newRgb = filter::yuvToRgb8(yuv.data());
    memcpy(output.data() + p, newRgb.data(), 3);
    output[p + 3] = rgba8[p + 3];
  }
  return output;
}

} // namespace
