#pragma once

#include "rgb8_image.h"

namespace np_image_editor {

class Edit {
public:
  virtual ~Edit() = default;

  virtual void applyInPlace(Rgba8Image &image) const = 0;
};

} // namespace np_image_editor
