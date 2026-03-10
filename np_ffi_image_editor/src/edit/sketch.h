#pragma once

#include "gpupixel_composite.h"

namespace np_image_editor {
namespace edit {

class Sketch : public GpupixelEdit {
public:
  Sketch(const float edgeStrength, const float edgeThreshold,
         const float hatching)
      : edgeStrength_(edgeStrength), edgeThreshold_(edgeThreshold),
        hatching_(hatching) {}

  std::shared_ptr<gpupixel::Source>
  addSink(gpupixel::Source *src) const override;

private:
  const float edgeStrength_;
  const float edgeThreshold_;
  const float hatching_;
};

} // namespace edit
} // namespace np_image_editor
