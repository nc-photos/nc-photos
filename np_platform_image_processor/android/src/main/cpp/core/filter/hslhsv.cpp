#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>

#include "hslhsv.h"

using namespace std;

namespace core {
namespace filter {

array<float, 3> rgb8ToHsl(const uint8_t *rgb8) {
  const auto max = std::max(std::max(rgb8[0], rgb8[1]), rgb8[2]);
  const auto min = std::min(std::min(rgb8[0], rgb8[1]), rgb8[2]);
  const auto chroma = max - min;

  float rgbF[] = {rgb8[0] / 255.f, rgb8[1] / 255.f, rgb8[2] / 255.f};
  const auto maxF = max / 255.f;
  const auto minF = min / 255.f;
  const auto chromaF = maxF - minF;

  const auto l = (maxF + minF) / 2;
  float h;
  if (chroma == 0) {
    h = 0;
  } else if (max == rgb8[0]) {
    h = fmodf(60 * (0 + (rgbF[1] - rgbF[2]) / chromaF) + 360, 360.f);
  } else if (max == rgb8[1]) {
    h = 60 * (2 + (rgbF[2] - rgbF[0]) / chromaF);
  } else if (max == rgb8[2]) {
    h = 60 * (4 + (rgbF[0] - rgbF[1]) / chromaF);
  }
  float s;
  if (std::abs(l - 0) < 1e-3 || std::abs(l - 1) < 1e-3) {
    s = 0;
  } else {
    s = chromaF / (1 - std::abs(2 * maxF - chromaF - 1));
  }
  return {h, s, l};
}

array<float, 3> rgb8ToHsv(const uint8_t *rgb8) {
  const auto max = std::max(std::max(rgb8[0], rgb8[1]), rgb8[2]);
  const auto min = std::min(std::min(rgb8[0], rgb8[1]), rgb8[2]);
  const auto chroma = max - min;

  float rgbF[] = {rgb8[0] / 255.f, rgb8[1] / 255.f, rgb8[2] / 255.f};
  const auto maxF = max / 255.f;
  const auto minF = min / 255.f;
  const auto chromaF = maxF - minF;

  float h;
  if (chroma == 0) {
    h = 0;
  } else if (max == rgb8[0]) {
    h = fmodf(60 * (0 + (rgbF[1] - rgbF[2]) / chromaF) + 360, 360.f);
  } else if (max == rgb8[1]) {
    h = 60 * (2 + (rgbF[2] - rgbF[0]) / chromaF);
  } else if (max == rgb8[2]) {
    h = 60 * (4 + (rgbF[0] - rgbF[1]) / chromaF);
  }
  float s;
  if (max == 0) {
    s = 0;
  } else {
    s = chromaF / maxF;
  }
  return {h, s, maxF};
}

array<uint8_t, 3> hslToRgb8(const float *hsl) {
  const auto chroma = hsl[1] * (1 - std::abs(2 * hsl[2] - 1));
  const auto h2 = hsl[0] / 60;
  const auto x = chroma * (1 - std::abs(fmodf(h2, 2) - 1));
  float r2, g2, b2;
  if (0 <= h2 && h2 < 1) {
    r2 = chroma;
    g2 = x;
    b2 = 0;
  } else if (1 <= h2 && h2 < 2) {
    r2 = x;
    g2 = chroma;
    b2 = 0;
  } else if (2 <= h2 && h2 < 3) {
    r2 = 0;
    g2 = chroma;
    b2 = x;
  } else if (3 <= h2 && h2 < 4) {
    r2 = 0;
    g2 = x;
    b2 = chroma;
  } else if (4 <= h2 && h2 < 5) {
    r2 = x;
    g2 = 0;
    b2 = chroma;
  } else {
    // 5 <= h2 && h2 < 6
    r2 = chroma;
    g2 = 0;
    b2 = x;
  }
  const auto m = hsl[2] - chroma / 2;
  return {static_cast<uint8_t>((r2 + m) * 255),
          static_cast<uint8_t>((g2 + m) * 255),
          static_cast<uint8_t>((b2 + m) * 255)};
}

array<uint8_t, 3> hsvToRgb8(const float *hsv) {
  const auto chroma = hsv[2] * hsv[1];
  const auto h2 = hsv[0] / 60;
  const auto x = chroma * (1 - std::abs(fmodf(h2, 2) - 1));
  float r2, g2, b2;
  if (0 <= h2 && h2 < 1) {
    r2 = chroma;
    g2 = x;
    b2 = 0;
  } else if (1 <= h2 && h2 < 2) {
    r2 = x;
    g2 = chroma;
    b2 = 0;
  } else if (2 <= h2 && h2 < 3) {
    r2 = 0;
    g2 = chroma;
    b2 = x;
  } else if (3 <= h2 && h2 < 4) {
    r2 = 0;
    g2 = x;
    b2 = chroma;
  } else if (4 <= h2 && h2 < 5) {
    r2 = x;
    g2 = 0;
    b2 = chroma;
  } else {
    // 5 <= h2 && h2 < 6
    r2 = chroma;
    g2 = 0;
    b2 = x;
  }
  const auto m = hsv[2] - chroma;
  return {static_cast<uint8_t>((r2 + m) * 255),
          static_cast<uint8_t>((g2 + m) * 255),
          static_cast<uint8_t>((b2 + m) * 255)};
}

std::array<float, 3> hslToHsv(const float *hsl) {
  const auto v = hsl[2] + hsl[1] * std::min(hsl[2], 1 - hsl[2]);
  float s;
  if (std::abs(v - 0) < 1e-3) {
    s = 0;
  } else {
    s = 2 * (1 - hsl[2] / v);
  }
  return {hsl[0], s, v};
}

std::array<float, 3> hsvToHsl(const float *hsv) {
  const auto l = hsv[2] * (1 - hsv[1] / 2);
  float s;
  if (std::abs(l - 0) < 1e-3 || std::abs(l - 1) < 1e-3) {
    s = 0;
  } else {
    s = (hsv[2] - l) / std::min(l, 1 - l);
  }
  return {hsv[0], s, l};
}

} // namespace filter
} // namespace core
