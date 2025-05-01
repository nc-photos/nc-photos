#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <memory>
#include <vector>

#include "../log.h"
#include "hslhsv.h"

using namespace core;
using namespace std;

namespace {

class Contrast {
public:
  std::vector<uint8_t> apply(const uint8_t *rgba8, const size_t width,
                             const size_t height, const float weight);

private:
  static constexpr const char *TAG = "Contrast";
};

inline uint8_t applySingle(const uint8_t p, const float mul) {
  return clamp(static_cast<int>((p - 127) * mul + 127), 0, 0xFF);
}

std::vector<uint8_t> buildLut(const float mul);

} // namespace

namespace core {
namespace filter {

vector<uint8_t> applyContrast(const uint8_t *rgba8, const size_t width,
                              const size_t height, const float weight) {
  return Contrast().apply(rgba8, width, height, weight);
}

} // namespace filter
} // namespace core

namespace {

vector<uint8_t> Contrast::apply(const uint8_t *rgba8, const size_t width,
                                const size_t height, const float weight) {
  LOGI(TAG, "[apply] weight: %.2f", weight);
  if (weight == 0) {
    // shortcut
    return vector<uint8_t>(rgba8, rgba8 + width * height * 4);
  }

  const float mul = weight >= 0 ? weight + 1 : (weight + 1) * .4f + .6f;
  const auto lut = buildLut(mul);
  vector<uint8_t> output(width * height * 4);
#pragma omp parallel for
  for (size_t i = 0; i < width * height; ++i) {
    const auto p = i * 4;
    output[p + 0] = lut[rgba8[p + 0]];
    output[p + 1] = lut[rgba8[p + 1]];
    output[p + 2] = lut[rgba8[p + 2]];
    output[p + 3] = rgba8[p + 3];
  }
  return output;
}

vector<uint8_t> buildLut(const float mul) {
  vector<uint8_t> product(256);
#pragma omp parallel for
  for (size_t i = 0; i < 256; ++i) {
    product[i] = applySingle(i, mul);
  }
  return product;
}

} // namespace
