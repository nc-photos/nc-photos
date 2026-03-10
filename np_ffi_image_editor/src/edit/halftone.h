#pragma once

#include "gpupixel_composite.h"

namespace np_image_editor {
namespace edit {

class Halftone : public GpupixelEdit {
public:
  Halftone() {}

  std::shared_ptr<gpupixel::Source>
  addSink(gpupixel::Source *src) const override;
};

} // namespace edit
} // namespace np_image_editor
