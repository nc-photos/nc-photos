#include "sketch.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Sketch::addSink(Source *src) const {
  auto filter = Sketch2Filter::Create();
  filter->setEdgeStrength(edgeStrength_);
  filter->setThreshold(edgeThreshold_);
  filter->setHatching(hatching_);
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
