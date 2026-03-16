#pragma once

#include <vector>
#include "gpupixel/filter/filter.h"
#include "gpupixel/gpupixel_define.h"

namespace gpupixel {

class GPUPIXEL_API MlkitFaceReshapeFilter : public Filter {
 public:
  static std::shared_ptr<MlkitFaceReshapeFilter> Create();
  bool Init();
  bool DoRender(bool updateSinks = true) override;

  void SetFaceSlimLevel(float level);
  void SetEyeZoomLevel(float level);
  void SetFaceLandmarks(const std::vector<float>& face,
                        const std::vector<float>& leftEye,
                        const std::vector<float>& rightEye,
                        const std::vector<float>& noseBridge,
                        const std::vector<float>& noseBottom);

 protected:
  MlkitFaceReshapeFilter() {};

  float thinFaceDelta_ = 0.0;
  float bigEyeDelta_ = 0.0;

  std::vector<float> facePoints_;
  std::vector<float> leftEyePoints_;
  std::vector<float> rightEyePoints_;
  std::vector<float> noseBridgePoints_;
  std::vector<float> noseBottomPoints_;
  int hasFace_ = 0;
};

}  // namespace gpupixel
