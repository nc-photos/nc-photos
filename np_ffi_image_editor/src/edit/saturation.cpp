#include "saturation.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Saturation::addSink(Source *src) const {
  auto filter = SaturationFilter::Create();
  filter->setSaturation(weight_ + 1);
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
