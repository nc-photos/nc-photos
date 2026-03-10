#include "contrast.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Contrast::addSink(Source *src) const {
  auto filter = ContrastFilter::Create();
  // map -1 ~ 1 to .85 ~ 1.45
  if (weight_ < 0) {
    filter->setContrast(weight_ * .15f + 1);
  } else {
    filter->setContrast(weight_ * .45f + 1);
  }
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
