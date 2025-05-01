#include <algorithm>
#include <cstdint>
#include <vector>

#include "../log.h"

using namespace std;

namespace {

constexpr float INPUT_AMPLITUDE = .4f;
constexpr uint8_t OUTPUT_AMPLITUDE = 100;

class WhitePoint {
public:
  std::vector<uint8_t> apply(const uint8_t *rgba8, const size_t width,
                             const size_t height, const float weight);

private:
  static uint8_t applyInputLevel(const uint8_t p, const float weight) {
    const auto pf = p / 255.f;
    const auto max = 1 - weight * INPUT_AMPLITUDE;
    return clamp<int>(clamp(pf, 0.f, max) / max * 255.f, 0, 255);
  }

  static uint8_t applyOutputLevel(const uint8_t p, const float weight) {
    return clamp<int>(p / 255.f * (255 - weight * OUTPUT_AMPLITUDE), 0, 255);
  }

  static std::vector<uint8_t> buildLut(const float weight);

  static constexpr const char *TAG = "WhitePoint";
};

class BlackPoint {
public:
  std::vector<uint8_t> apply(const uint8_t *rgba8, const size_t width,
                             const size_t height, const float weight);

private:
  static inline uint8_t applyInputLevel(const uint8_t p, const float weight) {
    const auto pf = p / 255.f;
    const auto min = weight * INPUT_AMPLITUDE;
    return clamp<int>((clamp(pf, min, 1.f) - min) / (1 - min) * 255.f, 0, 255);
  }

  static inline uint8_t applyOutputLevel(const uint8_t p, const float weight) {
    const auto x = weight * OUTPUT_AMPLITUDE;
    return clamp<int>(p / 255.f * (255 - x) + x, 0, 255);
  }

  static std::vector<uint8_t> buildLut(const float weight);

  static constexpr const char *TAG = "BlackPoint";
};

} // namespace

namespace core {
namespace filter {

vector<uint8_t> applyWhitePoint(const uint8_t *rgba8, const size_t width,
                                const size_t height, const float weight) {
  return WhitePoint().apply(rgba8, width, height, weight);
}

vector<uint8_t> applyBlackPoint(const uint8_t *rgba8, const size_t width,
                                const size_t height, const float weight) {
  return BlackPoint().apply(rgba8, width, height, weight);
}

} // namespace filter
} // namespace core

namespace {

vector<uint8_t> WhitePoint::apply(const uint8_t *rgba8, const size_t width,
                                  const size_t height, const float weight) {
  LOGI(TAG, "[apply] weight: %.2f", weight);
  if (weight == 0) {
    // shortcut
    return vector<uint8_t>(rgba8, rgba8 + width * height * 4);
  }

  const auto lut = buildLut(weight);
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

vector<uint8_t> WhitePoint::buildLut(const float weight) {
  vector<uint8_t> product(256);
  const float weightAbs = std::abs(weight);
  const auto fn =
      weight > 0 ? &WhitePoint::applyInputLevel : &WhitePoint::applyOutputLevel;
#pragma omp parallel for
  for (size_t i = 0; i < 256; ++i) {
    product[i] = fn(i, weightAbs);
  }
  return product;
}

vector<uint8_t> BlackPoint::apply(const uint8_t *rgba8, const size_t width,
                                  const size_t height, const float weight) {
  LOGI(TAG, "[apply] weight: %.2f", weight);
  if (weight == 0) {
    // shortcut
    return vector<uint8_t>(rgba8, rgba8 + width * height * 4);
  }

  const auto lut = buildLut(weight);
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

vector<uint8_t> BlackPoint::buildLut(const float weight) {
  vector<uint8_t> product(256);
  const float weightAbs = std::abs(weight);
  const auto fn =
      weight > 0 ? &BlackPoint::applyInputLevel : &BlackPoint::applyOutputLevel;
#pragma omp parallel for
  for (size_t i = 0; i < 256; ++i) {
    product[i] = fn(i, weightAbs);
  }
  return product;
}

} // namespace
