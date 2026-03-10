#pragma once

#include "../edit.h"

namespace np_image_editor {
namespace edit {

class Crop : public Edit {
public:
  explicit Crop(const float top, const float left, const float bottom,
                const float right)
      : top_(top), left_(left), bottom_(bottom), right_(right) {}

  void applyInPlace(Rgba8Image &image) const override;

private:
  // normalized coords, [0, 1]
  const float top_;
  const float left_;
  const float bottom_;
  const float right_;
};

} // namespace edit
} // namespace np_image_editor
