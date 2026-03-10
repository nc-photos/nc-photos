#pragma once

#include "gpupixel_composite.h"

namespace np_image_editor {
namespace edit {

class Tint : public GpupixelEdit {
public:
  explicit Tint(const float weight) : weight_(weight) {}

  std::shared_ptr<gpupixel::Source>
  addSink(gpupixel::Source *src) const override;

private:
  // -1 to 1
  const float weight_;
};

} // namespace edit
} // namespace np_image_editor
