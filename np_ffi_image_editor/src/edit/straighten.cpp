#include "straighten.h"
#include "../log.h"
#include "../rgb8_image.h"
#include <algorithm>
#include <cmath>
#include <vector>

using namespace std;

#define TAG "Straighten"

namespace np_image_editor {
namespace edit {

void Straighten::applyInPlace(Rgba8Image &image) const {
  LOGI(TAG, "[applyInPlace] degree: %d, position: (%f, %f)", degree_,
       positionX_, positionY_);
  if (degree_ == 0) {
    return;
  }
  const auto theta = degree_ * M_PI / 180.0;
  const auto sinT = sin(theta);
  const auto cosT = cos(theta);
  const auto sinA = abs(sinT);
  const auto cosA = abs(cosT);

  const auto ratio = (double)image.w() / image.h();
  const auto halfH = min(image.w() / (2.0 * (ratio * cosA + sinA)),
                         image.h() / (2.0 * (ratio * sinA + cosA)));
  const auto innerW = ratio * halfH * 2.0;
  const auto innerH = halfH * 2.0;
  const auto rangeX =
      max(0.0, (image.w() - innerW * cosA - innerH * sinA) / 2.0);
  const auto rangeY =
      max(0.0, (image.h() - innerW * sinA - innerH * cosA) / 2.0);
  const auto localCx =
      image.w() / 2.0 + clamp<double>(positionX_, -1, 1) * rangeX - 0.5;
  const auto localCy =
      image.h() / 2.0 + clamp<double>(positionY_, -1, 1) * rangeY - 0.5;

  const auto dstW = max<size_t>(round(innerW), 1);
  const auto dstH = max<size_t>(round(innerH), 1);
  LOGI(TAG, "[applyInPlace] output: %zux%zu", dstW, dstH);

  vector<uint8_t> output((size_t)dstW * dstH * 4);
  const auto src = image.pixel().data();
#pragma omp parallel for
  for (size_t y = 0; y < dstH; ++y) {
    const auto dy = y + 0.5 - dstH / 2.0;
    auto *dst = output.data() + (size_t)y * dstW * 4;
    for (size_t x = 0; x < dstW; ++x) {
      const auto dx = x + 0.5 - dstW / 2.0;
      const auto sx =
          clamp<double>(cosT * dx + sinT * dy + localCx, 0.0, image.w() - 1);
      const auto sy =
          clamp<double>(-sinT * dx + cosT * dy + localCy, 0.0, image.h() - 1);
      const auto x0 = (size_t)sx;
      const auto y0 = (size_t)sy;
      const auto x1 = min<size_t>(x0 + 1, image.w() - 1);
      const auto y1 = min<size_t>(y0 + 1, image.h() - 1);
      const auto fx = sx - x0;
      const auto fy = sy - y0;
      const auto *p00 = src + (y0 * image.w() + x0) * 4;
      const auto *p01 = src + (y0 * image.w() + x1) * 4;
      const auto *p10 = src + (y1 * image.w() + x0) * 4;
      const auto *p11 = src + (y1 * image.w() + x1) * 4;
      for (int c = 0; c < 4; ++c) {
        const auto top = p00[c] + (p01[c] - p00[c]) * fx;
        const auto bottom = p10[c] + (p11[c] - p10[c]) * fx;
        dst[x * 4 + c] = (uint8_t)lround(top + (bottom - top) * fy);
      }
    }
  }
  image = Rgba8Image(std::move(output), dstW, dstH);
}

} // namespace edit
} // namespace np_image_editor
