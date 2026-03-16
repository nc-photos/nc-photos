#include "face_reshape.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> FaceReshape::addSink(Source *src) const {
  auto filter = MlkitFaceReshapeFilter::Create();
  // map -1 ~ 1 to -.075 ~ .075
  filter->SetFaceSlimLevel(jawline_ * .075);
  // map 0 ~ 1 to 0 ~ .4
  filter->SetEyeZoomLevel(eyeSize_ * .4);
  filter->SetFaceLandmarks(facePoints_, leftEyePoints_, rightEyePoints_,
                           noseBridgePoints_, noseBottomPoints_);
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
