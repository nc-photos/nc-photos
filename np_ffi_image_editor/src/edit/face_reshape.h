#pragma once

#include "gpupixel_composite.h"
#include <vector>

namespace np_image_editor {
namespace edit {

class FaceReshape : public GpupixelEdit {
public:
  FaceReshape(const float jawline, const float eyeSize,
              const std::vector<float> &facePoints,
              const std::vector<float> &leftEyePoints,
              const std::vector<float> &rightEyePoints,
              const std::vector<float> &noseBridgePoints,
              const std::vector<float> &noseBottomPoints)
      : jawline_(jawline), eyeSize_(eyeSize), facePoints_(facePoints),
        leftEyePoints_(leftEyePoints), rightEyePoints_(rightEyePoints),
        noseBridgePoints_(noseBridgePoints),
        noseBottomPoints_(noseBottomPoints) {}

  std::shared_ptr<gpupixel::Source>
  addSink(gpupixel::Source *src) const override;

private:
  // -1 to 1
  const float jawline_;
  // -1 to 1
  const float eyeSize_;
  const std::vector<float> facePoints_;
  const std::vector<float> leftEyePoints_;
  const std::vector<float> rightEyePoints_;
  const std::vector<float> noseBridgePoints_;
  const std::vector<float> noseBottomPoints_;
};

} // namespace edit
} // namespace np_image_editor
