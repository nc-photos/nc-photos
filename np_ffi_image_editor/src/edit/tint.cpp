#include "tint.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Tint::addSink(Source *src) const {
  auto filter = TintFilter::Create();
  // map -1 ~ 1 to -.08 ~ .08
  filter->setTintAdjustment(weight_ * .08f);
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
