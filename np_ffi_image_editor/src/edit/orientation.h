#pragma once

#include "../edit.h"

namespace np_image_editor {
namespace edit {

class Orientation : public Edit {
public:
  explicit Orientation(const int degree) : degree_(degree) {}

  void applyInPlace(Rgba8Image &image) const override;

private:
  void apply90Ccw(Rgba8Image &image) const;
  void apply90Cw(Rgba8Image &image) const;
  void apply180(Rgba8Image &image) const;

  // rotation degree, [-180, -90, 0, 90, 180]
  const int degree_;
};

} // namespace edit
} // namespace np_image_editor
