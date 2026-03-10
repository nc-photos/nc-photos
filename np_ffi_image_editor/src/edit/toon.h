#pragma once

#include "gpupixel_composite.h"

namespace np_image_editor {
namespace edit {

class Toon : public GpupixelEdit {
public:
  Toon(const float edgeThreshold, const float quantizationLevels)
      : edgeThreshold_(edgeThreshold), quantizationLevels_(quantizationLevels) {
  }

  std::shared_ptr<gpupixel::Source>
  addSink(gpupixel::Source *src) const override;

private:
  const float edgeThreshold_;
  const float quantizationLevels_;
};

} // namespace edit
} // namespace np_image_editor
