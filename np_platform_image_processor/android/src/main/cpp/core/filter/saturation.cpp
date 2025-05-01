#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <memory>
#include <vector>

#include "../log.h"
#include "hslhsv.h"
#include "saturation.h"

using namespace std;

namespace core {
namespace filter {

vector<uint8_t> applySaturation(const uint8_t *rgba8, const size_t width,
                                const size_t height, const float weight) {
  return Saturation().apply(rgba8, width, height, weight);
}

vector<uint8_t> Saturation::apply(const uint8_t *rgba8, const size_t width,
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
    auto hsl = filter::rgb8ToHsl(rgba8 + p);
    hsl[1] = clamp(hsl[1] * (1 + weight), 0.f, 1.f);
    const auto &newRgb = filter::hslToRgb8(hsl.data());
    memcpy(output.data() + p, newRgb.data(), 3);
    output[p + 3] = rgba8[p + 3];
  }
  return output;
}

} // namespace filter
} // namespace core
