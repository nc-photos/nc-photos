#pragma once

#include "../edit.h"
#include <gpupixel/gpupixel.h>
#include <memory>
#include <vector>

namespace np_image_editor {
namespace edit {

class GpupixelEdit {
public:
  virtual ~GpupixelEdit() = default;

  virtual std::shared_ptr<gpupixel::Source>
  addSink(gpupixel::Source *src) const = 0;
};

class GpupixelComposite : public Edit {
public:
  GpupixelComposite();

  void pushBack(std::unique_ptr<GpupixelEdit> &&edit);

  void applyInPlace(Rgba8Image &image) const override;

private:
  std::vector<std::unique_ptr<GpupixelEdit>> edits_;
};

} // namespace edit
} // namespace np_image_editor
