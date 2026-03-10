#include "pixelation.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Pixelation::addSink(Source *src) const {
  auto filter = PixellationFilter::Create();
  filter->setPixelSize(weight_);
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
