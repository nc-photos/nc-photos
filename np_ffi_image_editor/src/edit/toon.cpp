#include "toon.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Toon::addSink(Source *src) const {
  auto filter = Toon2Filter::Create();
  filter->setThreshold(edgeThreshold_);
  filter->setQuantizationLevels(quantizationLevels_);
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
