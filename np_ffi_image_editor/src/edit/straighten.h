#pragma once

#include "../edit.h"

namespace np_image_editor {
namespace edit {

class Straighten : public Edit {
public:
  explicit Straighten(const int degree, const float positionX,
                      const float positionY)
      : degree_(degree), positionX_(positionX), positionY_(positionY) {}

  void applyInPlace(Rgba8Image &image) const override;

private:
  // rotation degree, [-90, 90]
  const int degree_;
  // relative offset of the ROI from the center [-1, 1]
  const float positionX_;
  const float positionY_;
};

} // namespace edit
} // namespace np_image_editor
