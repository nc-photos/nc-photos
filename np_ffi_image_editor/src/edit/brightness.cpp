#include "brightness.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Brightness::addSink(Source *src) const {
  auto filter = BrightnessFilter::Create();
  // map -1 ~ 1 to .25 ~ 1.75
  filter->setBrightness(weight_ * .2f);
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
