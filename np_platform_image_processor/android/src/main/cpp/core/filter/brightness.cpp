#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <vector>

#include "../log.h"
#include "hslhsv.h"

using namespace core;
using namespace std;

namespace {

class Brightness {
public:
  std::vector<uint8_t> apply(const uint8_t *rgba8, const size_t width,
                             const size_t height, const float weight);

private:
  static constexpr const char *TAG = "Brightness";
};

} // namespace

namespace core {
namespace filter {

vector<uint8_t> applyBrightness(const uint8_t *rgba8, const size_t width,
                                const size_t height, const float weight) {
  return Brightness().apply(rgba8, width, height, weight);
}

} // namespace filter
} // namespace core

namespace {

vector<uint8_t> Brightness::apply(const uint8_t *rgba8, const size_t width,
                                  const size_t height, const float weight) {
  LOGI(TAG, "[apply] weight: %.2f", weight);
  if (weight == 0) {
    // shortcut
    return vector<uint8_t>(rgba8, rgba8 + width * height * 4);
  }

  const float mul = 1 + weight / 2;
  vector<uint8_t> output(width * height * 4);
#pragma omp parallel for
  for (size_t i = 0; i < width * height; ++i) {
    const auto p = i * 4;
    auto hsv = filter::rgb8ToHsv(rgba8 + p);
    hsv[2] = clamp(hsv[2] * mul, 0.f, 1.f);
    const auto &newRgb = filter::hsvToRgb8(hsv.data());
    memcpy(output.data() + p, newRgb.data(), 3);
    output[p + 3] = rgba8[p + 3];
  }
  return output;
}

} // namespace
