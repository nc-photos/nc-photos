#include "crop.h"
#include "../log.h"
#include "../rgb8_image.h"
#include <algorithm>
#include <vector>

using namespace std;

#define TAG "Crop"

namespace np_image_editor {
namespace edit {

void Crop::applyInPlace(Rgba8Image &image) const {
  // prevent w/h == 0
  const auto widthPx = max<size_t>(image.w() * (right_ - left_), 1);
  const auto heightPx = max<size_t>(image.h() * (bottom_ - top_), 1);
  const auto topPx = (size_t)(image.h() * top_);
  const auto leftPx = (size_t)(image.w() * left_);
  LOGI(TAG, "[applyInPlace] top: %zu, left: %zu, width: %zu, height: %zu",
       topPx, leftPx, widthPx, heightPx);

  vector<uint8_t> output(widthPx * heightPx * 4);
#pragma omp parallel for
  for (size_t y = 0; y < heightPx; ++y) {
    const auto srcY = y + topPx;
    memcpy(output.data() + (y * widthPx * 4),
           image.pixel().data() + (srcY * image.w() + leftPx) * 4, widthPx * 4);
  }

  image = Rgba8Image(std::move(output), widthPx, heightPx);
}

} // namespace edit
} // namespace np_image_editor
