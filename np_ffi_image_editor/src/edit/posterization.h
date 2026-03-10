#pragma once

#include "gpupixel_composite.h"

namespace np_image_editor {
namespace edit {

class Posterization : public GpupixelEdit {
public:
  explicit Posterization(const int levels) : levels_(levels) {}

  std::shared_ptr<gpupixel::Source>
  addSink(gpupixel::Source *src) const override;

private:
  const int levels_;
};

} // namespace edit
} // namespace np_image_editor
