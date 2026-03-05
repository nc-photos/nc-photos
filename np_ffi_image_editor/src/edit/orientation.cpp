#include "orientation.h"
#include "../log.h"
#include "../rgb8_image.h"
#include <vector>

using namespace std;

#define TAG "Crop"

namespace np_image_editor {
namespace edit {

void Orientation::applyInPlace(Rgba8Image &image) const {
  LOGI(TAG, "[applyInPlace] degree: %d", degree_);
  if (degree_ == 0) {
    return;
  } else if (degree_ == 90) {
    apply90Ccw(image);
  } else if (degree_ == -90) {
    apply90Cw(image);
  } else {
    apply180(image);
  }
}

void Orientation::apply90Ccw(Rgba8Image &image) const {
  vector<uint8_t> output(image.w() * image.h() * 4);
#pragma omp parallel for
  for (size_t y = 0; y < image.h(); ++y) {
    const auto yI = y * image.w() * 4;
    for (size_t x = 0; x < image.w(); ++x) {
      const auto p = x * 4 + yI;
      const auto desY = image.w() - x - 1;
      const auto desX = y;
      const auto desP = (desY * image.h() + desX) * 4;
      output[desP + 0] = image.pixel().data()[p + 0];
      output[desP + 1] = image.pixel().data()[p + 1];
      output[desP + 2] = image.pixel().data()[p + 2];
      output[desP + 3] = image.pixel().data()[p + 3];
    }
  }
  image = Rgba8Image(std::move(output), image.h(), image.w());
}

void Orientation::apply90Cw(Rgba8Image &image) const {
  vector<uint8_t> output(image.w() * image.h() * 4);
#pragma omp parallel for
  for (size_t y = 0; y < image.h(); ++y) {
    const auto yI = y * image.w() * 4;
    for (size_t x = 0; x < image.w(); ++x) {
      const auto p = x * 4 + yI;
      const auto desY = x;
      const auto desX = image.h() - y - 1;
      const auto desP = (desY * image.h() + desX) * 4;
      output[desP + 0] = image.pixel().data()[p + 0];
      output[desP + 1] = image.pixel().data()[p + 1];
      output[desP + 2] = image.pixel().data()[p + 2];
      output[desP + 3] = image.pixel().data()[p + 3];
    }
  }
  image = Rgba8Image(std::move(output), image.h(), image.w());
}

void Orientation::apply180(Rgba8Image &image) const {
  vector<uint8_t> output(image.w() * image.h() * 4);
#pragma omp parallel for
  for (size_t y = 0; y < image.h(); ++y) {
    const auto yI = y * image.w() * 4;
    for (size_t x = 0; x < image.w(); ++x) {
      const auto p = x * 4 + yI;
      const auto desY = image.h() - y - 1;
      const auto desX = image.w() - x - 1;
      const auto desP = (desY * image.w() + desX) * 4;
      output[desP + 0] = image.pixel().data()[p + 0];
      output[desP + 1] = image.pixel().data()[p + 1];
      output[desP + 2] = image.pixel().data()[p + 2];
      output[desP + 3] = image.pixel().data()[p + 3];
    }
  }
  image = Rgba8Image(std::move(output), image.w(), image.h());
}

} // namespace edit
} // namespace np_image_editor
